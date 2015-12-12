$(document).ready ->
  $(document).on 'page:change', ->
    new VelocityChart($('.activity__graph__velocity'))
    new AltitudeChart($('.activity__graph__altitude'))
    if window.lapData.laps.length
      new LapChart($('.activity__graph__laps'))

class VelocityChart
  constructor: ($el) ->
    @$el = $el
    @$el.hide()
    @speed = new StreamData('velocity_smooth').downsample()
    @distance = new StreamData('distance').downsample()

    @chart = c3.generate
      size:
        height: 120
      bindto: @$el[0]
      data:
        columns: [
          ['speed'].concat(@speed),
          ['distance'].concat(@distance)
        ]
        x: 'distance'
      legend:
        show: false
      point:
        show: false
      onrendered: =>
        @$el.show()
      axis:
        y:
          padding:
            top: 0
            bottom: 0
          tick:
            values: [15, 30, 45, 60]
          label:
            text: 'Speed (km/h)',
            position: 'outer-middle'
        x:
          padding:
            left: 0
            right: 0
          tick:
            values: @_tickValues()
            format: (distance) ->
              "#{distance / 1000} km"

      tooltip:
        format:
          title: (data) ->
            "Distance #{parseFloat((data / 1000).toFixed(2))} km"
          value: (value, ratio, id) ->
            if id == 'speed'
              "#{parseFloat(value.toFixed(2))} km/h"

  _tickValues: ->
    values = []
    totalDistance = @distance[@distance.length - 1]
    displayValues = 7

    tickSize = Math.floor((totalDistance / displayValues) / 100) * 100

    for i in [0..displayValues - 1] by 1
      values.push(tickSize * i)

    values

class AltitudeChart
  constructor: ($el) ->
    @$el = $el
    @$el.hide()
    @altitude = new StreamData('altitude').downsample()
    @distance = new StreamData('distance').downsample()
    @grade = new StreamData('grade_smooth').downsample()

    @chart = c3.generate
      size:
        height: 180
      bindto: @$el[0]
      data:
        columns: [
          ['grade'].concat(@grade),
          ['altitude'].concat(@altitude),
          ['distance'].concat(@distance)
        ]
        types:
          altitude: 'area'
        colors:
          altitude: '#888888'
          grade: 'transparent'
        x: 'distance'
      legend:
        show: false
      point:
        show: false
      onrendered: =>
        @$el.show()
      axis:
        y:
          min: 0
          padding:
            top: 0
            bottom: 0
          label:
            text: 'Altitude (metres)',
            position: 'outer-middle'
        x:
          show: false
          padding:
            left: 0
            right: 0
      tooltip:
        format:
          title: (data) ->
            "Distance #{parseFloat((data / 1000).toFixed(2))} km"
          value: (value, ratio, id) ->
            if id == 'altitude'
              "#{parseFloat(value.toFixed(0))} m"
            else if id == 'grade'
              "#{parseFloat(value.toFixed(1))} %"

class LapChart
  constructor: ($el) ->
    @$el = $el
    @$el.hide()
    @timeData = $.map(window.lapData.laps, (data) -> data.time)
    @fastestLapTime = window.lapData.fastest_lap_time

    @chart = c3.generate
      size:
        height: 140
      bindto: @$el[0]
      data:
        columns: [
          ['laptime'].concat(@timeData)
        ]
        colors:
          laptime: '#FACB0F'
        type: 'line'
        color: (color, d) =>
          if d.id && d.id == 'laptime' && d.value == @fastestLapTime
            '#2B9E16'
          else
            color

      onrendered: =>
        @$el.show()
      axis:
        y:
          padding:
            top: 50
            bottom: 50
          label:
            text: 'Laptime'
            position: 'outer-middle'
          tick:
            format: (seconds) ->
              date = new Date(seconds * 1000)
              "#{date.getMinutes()}:#{("0"+date.getSeconds()).slice(-2)}"
            count: 5
        x:
          show: false
          padding:
            left: 0.5
            right: 0.5
      legend:
        show: false
      point:
        r: 5
      tooltip:
        format:
          title: (lapNumber) =>
            titleString = "Lap #{lapNumber + 1}"
            if @timeData[lapNumber] == @fastestLapTime
              "#{titleString} - Fastest Lap"
            else
              titleString
          value: (value, ratio, id) ->
            date = new Date(value * 1000)
            "#{date.getMinutes()}:#{("0"+date.getSeconds()).slice(-2)}"

$(document).ready ->
  $(document).on 'page:change', ->
    new VelocityChart($('.activity__graph__velocity'))
    new AltitudeChart($('.activity__graph__altitude'))
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
    @timeData = $.map(window.lapData, (data) -> data.time)

    @chart = c3.generate
      size:
        height: 180
      bindto: @$el[0]
      data:
        columns: [
          ['time'].concat(@timeData)
        ]
        type: 'scatter'
      onrendered: =>
        @$el.show()

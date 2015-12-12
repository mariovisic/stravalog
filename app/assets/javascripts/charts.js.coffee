$(document).ready ->
  $(document).on 'page:change', ->
    $el = $('.activity__graph__velocity')
    new Charts($el)

class Charts
  constructor: ($el) ->
    @$el = $el
    @$el.hide()
    @speed = new StreamData('velocity_smooth').downsample()
    @distance = new StreamData('distance').downsample()

    @chart = c3.generate
      bindto: @$el[0]
      data:
        columns: [
          ['speed'].concat(@speed),
          ['Distance'].concat(@distance)
        ]
        x: 'Distance'
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
            "#{parseFloat((data / 1000).toFixed(2))} km"
          value: (value, ratio, id) ->
            if id == 'speed'
              "#{parseFloat(value.toFixed(2))} km/h"
            else
              id

  _tickValues: ->
    values = []
    totalDistance = @distance[@distance.length - 1]
    displayValues = 7

    tickSize = Math.floor((totalDistance / displayValues) / 100) * 100

    for i in [0..displayValues - 1] by 1
      values.push(tickSize * i)

    values

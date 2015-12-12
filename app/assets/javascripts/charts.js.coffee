$(document).ready ->
  $(document).on 'page:change', ->
    $el = $('.activity__graph__velocity')
    new Charts($el)

class Charts
  constructor: ($el) ->
    @$el = $el
    @$el.hide()
    @speed = new StreamData('velocity_smooth').downsample()

    @chart = c3.generate
      bindto: @$el[0]
      data:
        columns: [ ['speed'].concat(@speed) ]
      legend:
        show: false
      point:
        show: false
      onrendered: =>
        @$el.show()
      axis:
        y:
          label:
            text: 'Speed (km/h)',
            position: 'outer-middle'
        x:
          show: false

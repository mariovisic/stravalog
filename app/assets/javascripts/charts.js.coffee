$(document).ready ->
  $(document).on 'page:change', ->
    $el = $('.activity__graph__velocity')
    new Charts($el)

class Charts
  constructor: ($el) ->
    @$el  = $el
    @streamDatas = window.streamData.filter (data) ->
      data['type'] == 'velocity_smooth'

    @speed = $.map @streamDatas[0].data, (speed) ->
      speed * 3.6 # m/s to km/h

    @chart = c3.generate
      bindto: @$el[0]
      data:
        columns: [ ['speed'].concat(@speed) ]
      transition:
        duration: 0 # hack to speed up rendering
      point:
        show: false
      oninit: =>
        @$el.hide()
        window.chartRenderStart = new Date().getTime()
      onrendered: =>
        @$el.show()
        loadTime = new Date().getTime() - window.chartRenderStart
        $('body').append("<strong>Load Time:</strong> #{loadTime / 1000.0} seconds")

      axis:
        y:
          label:
            text: 'Speed (km/h)',
            position: 'outer-middle'
        x:
          show: false

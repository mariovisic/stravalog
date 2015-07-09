$(document).ready ->
  $(document).on 'page:change', ->
    @$el = $('[data-all-map]')

    if @$el.length > 0
      new Map(@$el).draw()

class Map
  constructor: ($el) ->
    @$el  = $el
    @datas = JSON.parse(@$el.attr('data-polylines'))

  draw: ->
    @map = new google.maps.Map(@$el[0], @_mapOptions())
    @bounds = new google.maps.LatLngBounds()

    for data in @datas
      pathCoordinates = google.maps.geometry.encoding.decodePath(data)

      for coordinate in pathCoordinates
        @bounds.extend(coordinate)

      path = new google.maps.Polyline(
        path: pathCoordinates,
        geodesic: true,
        strokeColor: '#FF0000',
        strokeOpacity: 1.0,
        strokeWeight: 2
      )

      path.setMap(@map)

    @map.fitBounds(@bounds)

  _mapOptions: ->
      mapTypeId: google.maps.MapTypeId.TERRAIN

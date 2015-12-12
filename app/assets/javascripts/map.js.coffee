$(document).ready ->
  $(document).on 'page:change', ->
    @$el = $('[data-map]')

    if @$el.length > 0
      new Map(@$el).draw()

class Map
  constructor: ($el) ->
    @$el  = $el
    @data = new StreamData('latlng').downsample()

  draw: ->
    @map = new google.maps.Map(@$el[0], @_mapOptions())
    @bounds = new google.maps.LatLngBounds()
    @pathCoordinates = @data.map((data) =>
      latLng = new google.maps.LatLng(data[0], data[1])
      @bounds.extend(latLng)

      latLng
    )

    @path = new google.maps.Polyline(
      path: @pathCoordinates,
      geodesic: true,
      strokeColor: '#FF0000',
      strokeOpacity: 1.0,
      strokeWeight: 2
    )

    @path.setMap(@map)
    @map.fitBounds(@bounds)

  _mapOptions: ->
      mapTypeId: google.maps.MapTypeId.TERRAIN

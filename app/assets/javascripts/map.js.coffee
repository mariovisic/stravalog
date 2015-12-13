$(document).ready ->
  $(document).on 'page:change', ->
    @$el = $('[data-map]')

    if @$el.length > 0
      window.map = new Map(@$el)
      window.map.draw()

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

  setIndex: (dataIndex) ->
    latlng = @data[dataIndex]
    position = new google.maps.LatLng(latlng[0], latlng[1])

    if @marker
      @marker.setPosition(position)

      if !@map.getBounds().contains(position)
        @map.setCenter(position)
    else
      @marker = new google.maps.Marker
        position: position
        map: @map
        icon:
          path: google.maps.SymbolPath.CIRCLE
          fillColor: '#006699'
          strokeColor: '#ffffff'
          fillOpacity: 1.0
          strokeOpacity: 1.0
          strokeWeight: 2.0
          scale: 6

  _mapOptions: ->
      mapTypeId: google.maps.MapTypeId.TERRAIN

class window.StreamData
  constructor: (name, max_points = 900) ->
    @name = name
    @max_points = max_points

  all: ->
    all = @_streamDatas()

    if @name == 'velocity_smooth'
      all = $.map all, (speed) ->
        speed * 3.6 # m/s to km/h

    all

  downsample: ->
    all = @all()
    mod = Math.max(Math.round(all.length / @max_points), 1)
    downsample = []
    $.each all, (index, value) ->
      if index % mod == 0
        downsample.push(value)

    downsample

  _streamDatas: ->
    data = window.streamData.filter (data) =>
      data['type'] == @name

    data[0].data

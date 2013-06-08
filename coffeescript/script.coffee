$ ->
  iosocket = io.connect()
  iosocket.on 'new image', (photo) ->
    $('#images').prepend('<div class="img-crop"><img src="'+ photo.url + '"></div>')

  filepicker.setKey('AvovSWfJJQCaOl9IhtTofz')

  $('#fpicker').click () ->
    filepicker.pickAndStore {
      mimetype: 'image/*',
      maxSize: 2097152
    }, {},
      (fpfile) ->
        iosocket.emit 'upload', fpfile[0]
      (fpfile) ->
        console.log "ERROR"
    return false

  hasNextPage = true

  $(document).ready () ->
     $(window).bind('scroll', loadOnScroll)

  loadOnScroll = () ->
    if $(window).scrollTop() > $(document).height() - ($(window).height()*2)
      $(window).unbind()
      loadItems()

  loadItems = () ->
    if !hasNextPage
      return false
    else


$ ->
  iosocket = io.connect()
  iosocket.on 'new image', (photo) ->
    $('#photos').prepend('<div class="img-crop"><img src="'+ photo.url + '"></div>')

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
  createdAt = ""

  $(document).ready () ->
    $(window).bind('scroll', loadOnScroll)
    $('#browserid').click () ->
      navigator.id.get (assertion) ->
        if assertion
          $("input[name=assertion]").val assertion
          $("form[name=persona]").submit()
        else
         location.reload()
    ajaxPhotos()


  loadOnScroll = () ->
    if $(window).scrollTop() > $(document).height() - ($(window).height()*2)
      $(window).unbind()
      loadItems()

  loadItems = () ->
    if !hasNextPage
      return false
    else
      ajaxPhotos()

  ajaxPhotos = () ->
    $.ajax
      url: 'list?createdAt=' + createdAt,
      success: (data, status, jqXHR) ->
        for photo in data
          $("#photos").append('<div class="img-crop"><img src="' + photo.url + '"></div>')
        dataLength = data.length
        if dataLength < 10
          hasNextPage = false
        createdAt = data[dataLength - 1].createdAt

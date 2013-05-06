$ ->
  iosocket = io.connect()
  iosocket.on 'connect', () ->
    iosocket.on 'new image', (name) ->
      $('#images').prepend("<div class='img-crop'><img src='/uploads/#{name}'></div>")

  send_message = (message) ->
    $('#progress-bar').hide()
    $('#message strong').text(message)
    $('#message').show()

  # standardize the file input field
  $('#user-file-text, #user-file-button').click ->
    $('#user-file').click()
  $('#user-file').change (e) ->
    # standardize the file path
    val = $(e.target).val()
    index = if val.indexOf('\\') >= 0 then val.lastIndexOf('\\') else val.lastIndexOf('/')
    if index >= 0
      val = val.substring(index + 1)
    $('#user-file-text').val(val)
    
    $('input[type="submit"]').show()


  $('input[type="submit"]').on 'click', (evt) ->
    evt.preventDefault()
    $('#progress-bar').show()
    formData =  new FormData
    file = $('#user-file')[0].files[0]
    formData.append('image', file)

    xhr = new XMLHttpRequest()
    xhr.open 'post', '/', true

    xhr.upload.onprogress = (e) ->
      if e.lengthComputable
        percentage = (e.loaded / e.total) * 100
        $('#progress-bar .bar').css('width', percentage + '%')

    xhr.onerror = (e) ->
      send_message 'An error occured while uploading your image. Make sure your image is no larger than 2 mb.'

    xhr.onload = ->
      if @status != 200
        send_message 'An error occured while uploading your image. Make sure your image is no larger than 2 mb.'
      else
        send_message this.statusText

    xhr.send formData

    @form.reset()
    $('input[type="submit"]').hide()


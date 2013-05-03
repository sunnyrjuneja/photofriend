$() ->
  send_message = (message) ->
    $('div.progress').hide()
    $('strong.message')text(message)
    $('div.alert').show()

 $('input[type="submit"').on 'click' (evt) ->
   evt.preventDefault()
   $('div.progress').show()
   formData =  new FormData
   file = $('#user-file')[0].files[0]
   formData.append('image', file)

   xhr = new XMLHttpRequest()
   xhr.open('post', '/', true)

   xhr.upload.onprogress = (e) ->
     if e.lengthComputable
       percentage = (e.loaded / e.total) * 100
       $('div.progress div.bar').css('width', percentage + '%')

   xhr.onerror = (e) ->
     send_message('An error occured while upload the image. Make sure your image is no larger than 2 mb.')

   xhr.onload =  () ->
     send_message this.statusText

   xhr.send formData

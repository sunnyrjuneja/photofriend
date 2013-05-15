$ ->
  iosocket = io.connect()
  iosocket.on 'connect', () ->
    iosocket.on 'new image', (name) ->
      $('#images').prepend("<div class='img-crop'><img src='/uploads/#{name}'></div>")
  
  filepicker.setKey("AvovSWfJJQCaOl9IhtTofz")

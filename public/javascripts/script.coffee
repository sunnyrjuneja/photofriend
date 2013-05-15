$ ->
  iosocket = io.connect()
  
  filepicker.setKey("AvovSWfJJQCaOl9IhtTofz")

  filepicker.pickAndStore {
    mimetype: 'image/*',
    maxSize: 2097152
  }, {},
    (fpfile) ->
      console.log "Success"
      iosocket.emit 'upload', fpfile
    (fpfile) ->
      console.log "ERROR"

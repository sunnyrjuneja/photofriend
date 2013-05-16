$ ->
  iosocket = io.connect()
  
  filepicker.setKey("AvovSWfJJQCaOl9IhtTofz")

  $("#fpicker").click () ->
    filepicker.pickAndStore {
      mimetype: 'image/*',
      maxSize: 2097152
    }, {},
      (fpfile) ->
        iosocket.emit 'upload', fpfile[0]
      (fpfile) ->
        console.log "ERROR"
    return false

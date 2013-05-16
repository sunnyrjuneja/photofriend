$ ->
  iosocket = io.connect()
  
  filepicker.setKey("AvovSWfJJQCaOl9IhtTofz")

  $("#filepicker").click () ->
    console.log "Hmm"
    filepicker.pickAndStore {
      mimetype: 'image/*',
      maxSize: 2097152
    }, {}, ((fpfile) ->
        console.log "Success"
        iosocket.emit 'upload', fpfile),
      ((fpfile) ->
        console.log "ERROR")
    return false

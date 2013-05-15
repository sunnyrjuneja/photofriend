express = require 'express'
app = express()
server = require('http').Server(app)
io = require('socket.io').listen(server)
path = require 'path'
fs = require 'fs'
mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/test'

Photo = mongoose.model "Photo",
  url: String,
  filename: String,
  mimetype: String,
  size: Number,
  key: String,
  isWriteable: Boolean

app.configure () ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.logger 'dev'
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(path.join(__dirname, 'public'))
 
if 'development' == app.get 'env'
  app.use express.errorHandler()

app.get '/', (req, res) ->
  res.render 'index'

server.listen app.get('port'), () ->
  console.log('Express server listening on port ' + app.get('port'))

io.sockets.on 'connection', (socket) ->
  socket.on 'upload', (json) ->
    console.log "Trying"
    p = new Photo(json)
    p.save (err) ->
      if err
        console.log "Photo upload failed"
        console.log err
      else
        console.log "SUCCESS"

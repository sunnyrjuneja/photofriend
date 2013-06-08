express = require 'express'
app = express()
server = require('http').Server(app)
io = require('socket.io').listen(server)
path = require 'path'
fs = require 'fs'
mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/photos'

Photo = mongoose.model "Photo",
  url: String,
  filename: String,
  mimetype: String,
  size: Number,
  key: String,
  isWriteable: Boolean,
  createdAt: Date

app.configure () ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.logger 'dev'
  app.use express.methodOverride()
  app.use app.router
  app.use express.static path.join __dirname, 'public'
 
if 'development' == app.get 'env'
  app.use express.errorHandler()

app.get '/', (req, res) ->
  res.render 'index'

app.get '/list', (req, res) ->
  createdAt = req.query["createdAt"]
  if createdAt == ""
    Photo.find().sort('createdAt': -1).limit(10).exec (err, docs) ->
      if err
        console.log err
      else
        res.json docs
  else
    Photo.where('createdAt').lt(createdAt).sort('createdAt': -1).limit(10).exec (err, docs) ->
      if err
        console.log err
      else
        res.json docs

server.listen app.get('port'), () ->
  console.log 'Express server listening on port ' + app.get 'port'

io.sockets.on 'connection', (socket) ->
  socket.on 'upload', (json) ->
    console.log "Trying"
    json.createdAt = new Date()
    p = new Photo(json)
    p.save (err) ->
      if err
        console.log "Photo upload failed"
        console.log err
      else
        console.log "Success"
        io.sockets.emit 'new image', p

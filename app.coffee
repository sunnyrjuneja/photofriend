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
  Photo.find().sort('createdAt': 1).limit(20).exec (err, docs) ->
    if err
      console.log err
    else
      res.render 'index', "photos": docs

app.get '/list', (req, res) ->
  Photo.where('createdAt').lt(req.query["createdAt"]).sort('createdAt': 1).limit(20).exec (err, docs) ->
    if err
      console.log err
    else
      res.json docs

server.listen app.get('port'), () ->
  console.log 'Express server listening on port ' + app.get 'port'

io.sockets.on 'connection', (socket) ->
  socket.on 'upload', (json) ->
    console.log "Trying"
    console.log json
    p = new Photo(json)
    p.save (err) ->
      if err
        console.log "Photo upload failed"
        console.log err
      else
        console.log "Success"
        io.sockets.emit 'new image', p

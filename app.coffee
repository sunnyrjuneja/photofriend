express = require 'express'
routes = require './routes'
http = require 'http'
path = require 'path'
fs = require 'fs'
io = require 'socket.io'

app = express()
server = http.createServer(app)
sockets = io.listen(server)

images = fs.readdirSync('./public/uploads')

app.configure () ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.logger 'dev'
  app.use express.bodyParser
    keepExtensions: true
    uploadDir: './public/uploads'
    limit: '2mb'
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(path.join(__dirname, 'public'))
 
if 'development' == app.get 'env'
  app.use express.errorHandler()

app.get '/', (req, res) ->
  res.render 'index', { "images": images }

app.post '/', (req, res) ->
  name = req.files.image.path.substring(15)
  images.unshift(name)
  sockets.emit 'new image', name
  console.log 'sent event ' + name
  res.end()
  
server.listen(app.get('port'), () ->
  console.log('Express server listening on port ' + app.get('port'))
)


sockets.on 'connection', (socket) ->
  socket.on 'new image', (name) ->
    socket.broadcast.emit 'new image', name

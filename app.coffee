express = require 'express'
routes = require './routes'
http = require 'http'
path = require 'path'
fs = require 'fs'

app = express()

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
  res.render 'index'

app.post '/', (req, res) ->
  res.end()
  
http.createServer(app).listen(app.get('port'), () ->
  console.log('Express server listening on port ' + app.get('port'))
)

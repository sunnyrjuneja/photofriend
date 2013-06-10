express = require 'express'
app = express()
server = require('http').Server(app)

flash = require 'connect-flash'
io = require('socket.io').listen(server)

passport = require 'passport'
PersonaStrategy = require('passport-persona').Strategy

passport.serializeUser (user, done) ->
  done null, user.email

passport.deserializeUser (email, done) ->
  done null, email: email

passport.use new PersonaStrategy { audience: 'http://127.0.0.1:3000' }, (email, done) ->
  process.nextTick () ->
    done null, { email: email }

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
  app.use express.cookieParser()
  app.use express.session secret: 'keyboard cat'
  app.use flash()
  app.use passport.initialize()
  app.use passport.session()
  app.use app.router
  app.use express.static path.join __dirname, 'public'
 
if 'development' == app.get 'env'
  app.use express.errorHandler()

app.get '/', (req, res) ->
  res.render 'index', user: req.user

app.get '/login', (req, res) ->
  res.render('login', { user: req.user })

app.post '/auth/browserid', passport.authenticate('persona', { successRedirect: '/', failureRedirect: '/login', failureFlash: true }), (req, res) ->
  res.redirect('/')

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

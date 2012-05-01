express = require 'express'

app = express.createServer()
io = require('socket.io').listen app

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.logger()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static __dirname + '/public'


app.get '/', (req, res) ->
  res.render 'index', title: 'index'


app.listen 8000

io.sockets.on 'connection', (socket) ->
  socket.emit 'msg', 'Welcome to real-time chat'
  socket.on 'msg', (m) ->
    io.sockets.emit 'msg', m


console.log 'Ready'



express = require 'express'

app = express.createServer()
io = require('socket.io').listen app
redis = require 'redis'
redis_client = redis.createClient()

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

generate_url = (fn) ->
  usable_chars = "0123456789abcdefghijklmnopqrstuvwxyz"
  url = ""
  url += usable_chars[Math.floor(Math.random() * 10)]
  url += usable_chars[Math.floor(Math.random() * usable_chars.length)] for i in [2..5]

  redis_client.exists ('room_'+url), (err, retval) ->
    if retval == 0
      redis_client.hset ('room_'+url), 'createdate', new Date().getTime(), (err) ->
        fn url
    else
      generate_url fn

app.get '/create', (req, res) ->
  generate_url (url) ->
    res.redirect ('/' + url)

app.get /^\/([^\/]+)\/?$/, (req, res) ->
  id = req.params[0]
  res.render 'chat', title: id

app.listen 8000

io.sockets.on 'connection', (socket) ->
  socket.on 'set room', (r) ->
    socket.set 'room', r, () ->
    socket.join r
    redis_client.zrevrange ('room_'+r+'_history'), 0, 100, (err, docs) ->
      socket.emit 'msg', m for m in docs
  
  socket.on 'msg', (m) ->
    socket.get 'room', (err, room) ->
      redis_client.zadd ('room_'+room+'_history'), new Date().getTime(), m, (err, retval) ->
      io.sockets.in(room).emit 'msg', m


console.log 'Ready'



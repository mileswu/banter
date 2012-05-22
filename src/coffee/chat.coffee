socket = io.connect 'http://ryou.w00.eu:8000'

socket.on 'connect', () ->
  roomid = $('title').text()
  socket.emit('set room', roomid)
  console.log 'Connected'

socket.on 'msg', (data) ->
  $('#chat').append ("<p>" + data + "</p>")

$('#msginputform').submit (e) ->
  socket.emit 'msg', $('#msginput').val()
  $('#msginput').val ''
  return false


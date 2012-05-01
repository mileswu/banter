socket = io.connect 'http://ryou.w00.eu:8000'

socket.on 'msg', (data) ->
  $('#chat').append ("<p>" + data + "</p>")

$('#msginputform').submit (e) ->
  socket.emit 'msg', $('#msginput').val()
  $('#msginput').val ''
  return false


browserijade = require 'browserijade'

$(window).ready () ->
  socket = io.connect 'http://ryou.w00.eu:8000'

  socket.on 'connect', () ->
    roomid = $('title').text()
    socket.emit 'set room', roomid
  socket.on 'msg', (data) ->
    $("#chatwindow").append browserijade("message", {text: data})

  $('#msginput').focus (e) ->
    $('#msginput').val ''
    $('#msginputdiv').removeClass 'placeholderentry'
    $('#msginput').focus (e) ->

    

  $('#msginputform').submit (e) ->
    socket.emit 'msg', $('#msginput').val()
    $('#msginput').val ''
    return false



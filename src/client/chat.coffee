browserijade = require 'browserijade'

$(window).ready () ->
  socket = io.connect 'http://ryou.w00.eu:8000'

  socket.on 'connect', () ->
    roomid = $('title').text()
    socket.emit 'set room', roomid
  socket.on 'msg', (m) ->
    message = JSON.parse m
    $("#chatwindow").append browserijade("message", {
      text: message['text'],
      date: new Date(message['date']),
      name: message['name']
    })

  $('#msginput').focus (e) ->
    $('#msginput').val ''
    $('#msginputdiv').removeClass 'placeholderentry'
    $('#msginput').focus (e) ->

    

  $('#msginputform').submit (e) ->
    message = {
      text: $('#msginput').val(),
      name: 'delamoo'
    }
    socket.emit 'msg', JSON.stringify(message)
    $('#msginput').val ''
    return false



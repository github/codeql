// example adapted from test cases found in github projects
// new portal exit node (i.e. caught with typetracking) annotated below

var express = require('express');
var app = express();
var server = require('http').createServer(app);
var io = require('socket.io')(server);

io.on('connection', (socket) => {
  var addedUser = false;

  // when the client emits 'new message', this listens and executes
  socket.on('new message', (data) => {
    // we tell the client to execute 'new message'
    socket.broadcast.emit('new message', {
      username: socket.username, // socket.username is a new portal exit node (since socket is a portal,
      message: data				 // this is a case of MemberPortal)
    });
  });

  // when the client emits 'typing', we broadcast it to others
  socket.on('typing', () => {
    socket.broadcast.emit('typing', {
      username: socket.heresAField // like socket.username, socket.heresAField is a new portal exit node
    });
  });

});

const io = require('socket.io')();      // SocketIO::ServerNode

const Server = require('socket.io');
const io2 = new Server();               // SocketIO::ServerNode

const io3 = Server.listen();            // SocketIO::ServerNode

// more SocketIO::ServerNodes:
io.serveClient(false);
io.set('origins', []);
io.path('/myownpath');
io.adapter(foo);
io.origins([]);
io.listen(http);
io.attach(http);
io.bind(engine);
io.onconnection(socket);

// not SocketIO::ServerNodes:
io.path();
io.adapter();
io.origins();

// SocketIO::NamespaceNodes:
var ns = io.sockets;
var ns2 = io.of("/foo/bar");
ns.use(auth);
ns.to(room);
ns.in(room);
ns.emit('event', 'an event');
ns.send('a message');
ns2.write('a message');
ns.clients(cb);
ns.compress(true);
ns.binary(false);
io.use(auth);
io.to(room);
io.in(room);
io.emit('message', 'a message');
io.send('a message');
io.write('a message');
io.clients(cb);
io.compress(true);
io.binary(false);
ns.json;
ns.volatile;
ns.local;

// SocketIO::SocketNodes:
io.on('connect', (socket) => {
  socket.emit('event');
  socket.to(room);
  socket.in(room);
  socket.send('a', 'message', (data) => {});
  socket.write('a message');
  socket.join(room);
  socket.leave(room);
  socket.use(cb);
  socket.compress(true);
  socket.binary(false);
  socket.disconnect(true);
  socket.json;
  socket.volatile;
  socket.broadcast;
  socket.local;
  socket.broadcast.emit('broadcast');
});
io.on('connection', (socket) => {});
ns.on('connect', (socket) => {});
ns.on('connection', (socket) => {
  socket.on('message', (msg) => {});
  socket.once('message', (data1, data2) => {});
  socket.addListener(eventName(), () => {});
});

var obj = {
  server: io,
  serveClient: function() { return null; }
};
obj.server;                    // SocketIO::ServerNode
obj.serveClient(false);        // not a SocketIO::ServerNode
obj.serveClient(false).server; // not a SocketIO::ServerNode

function foo(x,socket) {}
io.on('connect', foo.bind(null, "x"));
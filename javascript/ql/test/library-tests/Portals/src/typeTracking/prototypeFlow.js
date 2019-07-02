// example adapted from test cases found in github projects

const net = require('net');
const PORT = 88;

function main({ dur, len, type }) {
  
  const reader = new Reader();
  
  const server = net.createServer((socket) => {
    socket.pipe(socket);
  });

  server.listen(PORT, () => {
    const socket = net.connect(PORT);
    socket.on('connect', () => {
      
      reader.pipe(socket);
      socket.pipe(writer);

    });
  });
}

function Writer() {
  this.received = 0;
  this.writable = true;
}

function flow() {
  const dest = this.dest;
}

function Reader() {
  this.flow = flow.bind(this);
  this.readable = true;
}

Reader.prototype.pipe = function(dest) {
  this.dest = dest;
  this.flow();
  return dest;
};

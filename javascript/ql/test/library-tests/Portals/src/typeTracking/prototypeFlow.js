// example adapted from test cases found in github projects
// new portal exit node (i.e. caught with typetracking) annotated below

const net = require('net');
const PORT = 88;

function main({ dur, len, type }) {
  
  const reader = new Reader();
  const writer = new Writer();
  
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

// here "dest" is a portal exit node
// this is because "socket" is passed in as an argument to this pipe function when it
// is called in main, and "socket" is a portal 
Reader.prototype.pipe = function(dest) { 
  this.dest = dest;
  this.flow();
  return dest;
};

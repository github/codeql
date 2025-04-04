const { MyWebSocketServer, myWebSocketServerInstance } = require('./server.js');

(function () {
	const wss = new MyWebSocketServer({ port: 8080 });

	wss.on('connection', function connection(ws) { // $ serverSocket
		ws.on('message', function incoming(message) { // $ remoteFlow
			console.log('received: %s', message);
		}); // $ serverReceive

		ws.send('Hi from server!'); // $ serverSend
	});
})();

(function () {
	myWebSocketServerInstance.on('connection', function connection(ws) { // $ serverSocket
		ws.on('message', function incoming(message) { // $ remoteFlow
			console.log('received: %s', message);
		}); // $ serverReceive

		ws.send('Hi from server!'); // $ serverSend
	});
})();

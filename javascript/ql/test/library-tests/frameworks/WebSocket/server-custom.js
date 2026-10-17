const { MyWebSocketServer, myWebSocketServerInstance } = require('./server.js');

(function () {
	const wss = new MyWebSocketServer({ port: 8080 });

	wss.on('connection', function connection(ws) { // $ serverSocket
		ws.on('message', function incoming(message) { // $ remoteFlow serverReceive
			console.log('received: %s', message);
		});

		ws.send('Hi from server!'); // $ serverSend
	});
})();

(function () {
	myWebSocketServerInstance.on('connection', function connection(ws) { // $ serverSocket
		ws.on('message', function incoming(message) { // $ remoteFlow serverReceive
			console.log('received: %s', message);
		});

		ws.send('Hi from server!'); // $ serverSend
	});
})();

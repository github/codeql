const { MyWebSocketServer } = require('./client.js');

(function () {
	const wss = new MyWebSocketServer({ port: 8080 });

	wss.on('connection', function connection(ws) { // $ MISSING: serverSocket
		ws.on('message', function incoming(message) { // $ MISSING: remoteFlow
			console.log('received: %s', message);
		}); // $ MISSING: serverReceive

		ws.send('Hi from server!'); // $ MISSING: serverSend
	});
})();

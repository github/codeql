(function () {
	const WebSocket = require('ws');

	const wss = new WebSocket.Server({ port: 8080 });

	wss.on('connection', function connection(ws) { // $serverSocket
		ws.on('message', function incoming(message) { // $remoteFlow
			console.log('received: %s', message);
		}); // $serverReceive

		ws.send('Hi from server!'); // $serverSend
	});
})();

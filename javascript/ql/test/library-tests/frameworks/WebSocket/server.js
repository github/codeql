const WebSocket = require('ws');

(function () {
	const wss = new WebSocket.Server({ port: 8080 });

	wss.on('connection', function connection(ws) { // $serverSocket
		ws.on('message', function incoming(message) { // $remoteFlow
			console.log('received: %s', message);
		}); // $serverReceive

		ws.send('Hi from server!'); // $serverSend
	});
})();

module.exports.MyWebSocketServer = require('ws').Server;
module.exports.myWebSocketServerInstance = new WebSocket.Server({ port: 8080 });

const WebSocket = require('ws');

(function () {
	const ws = new WebSocket('ws://example.org'); // $clientSocket

	ws.on('open', function open() {
		ws.send('Hi from client!'); // $clientSend
	});

	ws.on('message', function incoming(data) { // $ remoteFlow
		console.log(data);
	}); // $clientReceive
})();

module.exports.MyWebSocketWS = require('ws');
module.exports.myWebSocketWSInstance = new WebSocket('ws://example.org'); // $ clientSocket

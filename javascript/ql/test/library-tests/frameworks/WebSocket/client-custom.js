const { MyWebSocketWS } = require('./client.js');

(function () {
	const ws = new MyWebSocketWS('ws://example.org'); // $ clientSocket

	ws.on('open', function open() {
		ws.send('Hi from client!'); // $ clientSend
	});

	ws.on('message', function incoming(data) {
		console.log(data);
	}); // $ clientReceive
})();

const { MyWebSocketWS } = require('./client.js');

(function () {
	const ws = new MyWebSocketWS('ws://example.org'); // $ MISSING: clientSocket

	ws.on('open', function open() {
		ws.send('Hi from client!'); // $ MISSING: clientSend
	});

	ws.on('message', function incoming(data) {
		console.log(data);
	}); // $ MISSING: clientReceive
})();

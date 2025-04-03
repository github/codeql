(function () {
	const WebSocket = require('ws');

	const ws = new WebSocket('ws://example.org'); // $clientSocket

	ws.on('open', function open() {
		ws.send('Hi from client!'); // $clientSend
	});

	ws.on('message', function incoming(data) {
		console.log(data);
	}); // $clientReceive
})();

(function () {
	const WebSocket = require('ws');

	const ws = new WebSocket('ws://example.org');

	ws.on('open', function open() {
		ws.send('Hi from client!');
	});

	ws.on('message', function incoming(data) {
		console.log(data);
	});
})();
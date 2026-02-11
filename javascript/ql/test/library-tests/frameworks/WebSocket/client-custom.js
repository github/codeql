const { MyWebSocketWS, myWebSocketWSInstance } = require('./client.js');

(function () {
	const ws = new MyWebSocketWS('ws://example.org'); // $ clientSocket

	ws.on('open', function open() {
		ws.send('Hi from client!'); // $ clientSend
	});

	ws.on('message', function incoming(data) { // $ remoteFlow
		console.log(data);
	}); // $ clientReceive
})();

(function () {
	myWebSocketWSInstance.on('open', function open() {
		myWebSocketWSInstance.send('Hi from client!'); // $ clientSend
	});

	myWebSocketWSInstance.on('message', function incoming(data) { // $ remoteFlow
		console.log(data);
	}); // $ clientReceive
})();

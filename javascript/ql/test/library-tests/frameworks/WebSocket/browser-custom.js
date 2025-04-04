import { MyWebSocket, MySockJS } from './browser.js';

(function () {
	const socket = new MyWebSocket('ws://localhost:9080'); // $ MISSING: clientSocket

	socket.addEventListener('open', function (event) {
		socket.send('Hi from browser!'); // $ MISSING: clientSend
	});

	socket.addEventListener('message', function (event) {
		console.log('Message from server ', event.data);
	}); // $ MISSING: clientReceive

	socket.onmessage = function (event) {
		console.log("Message from server 2", event.data)
	}; // $ MISSING: clientReceive
})();


(function () {
	var sock = new MySockJS('http://0.0.0.0:9999/echo'); // $ MISSING: clientSocket
	sock.onopen = function () {
		sock.send('test'); // $ MISSING: clientSend
	};
	
	sock.onmessage = function (e) {
		console.log('message', e.data);
		sock.close();
	}; // $ MISSING: clientReceive
	
	sock.addEventListener('message', function (event) {
		console.log('Using addEventListener ', event.data);
	}); // $ MISSING: clientReceive
})();

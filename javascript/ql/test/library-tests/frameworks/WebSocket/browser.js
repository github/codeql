(function () {
	const socket = new WebSocket('ws://localhost:8080'); // $ clientSocket

	socket.addEventListener('open', function (event) {
		socket.send('Hi from browser!'); // $ clientSend
	});

	socket.addEventListener('message', function (event) { // $ clientReceive
		console.log('Message from server ', event.data); // $ remoteFlow
	});

	socket.onmessage = function (event) { // $ clientReceive
		console.log("Message from server 2", event.data); // $ remoteFlow
	};
})();


(function () {
	var sock = new SockJS('http://0.0.0.0:9999/echo'); // $ clientSocket
	sock.onopen = function () {
		sock.send('test'); // $ clientSend
	};

	sock.onmessage = function (e) { // $ clientReceive
		console.log('message', e.data); // $ remoteFlow
		sock.close();
	};

	sock.addEventListener('message', function (event) { // $ clientReceive
		console.log('Using addEventListener ', event.data); // $ remoteFlow
	});
})();

export const MyWebSocket = WebSocket;
export const MySockJS = SockJS;
export const myWebSocketInstance = new WebSocket('ws://localhost:8080'); // $ clientSocket
export const mySockJSInstance = new SockJS('http://0.0.0.0:9999/echo'); // $ clientSocket

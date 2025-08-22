(function () {
	const socket = new WebSocket('ws://localhost:8080'); // $clientSocket

	socket.addEventListener('open', function (event) {
		socket.send('Hi from browser!'); // $clientSend
	});

	socket.addEventListener('message', function (event) {
		console.log('Message from server ', event.data); // $ remoteFlow
	}); // $clientReceive

	socket.onmessage = function (event) {
		console.log("Message from server 2", event.data); // $ remoteFlow
	}; // $clientReceive
})();


(function () {
	var sock = new SockJS('http://0.0.0.0:9999/echo'); // $clientSocket
	sock.onopen = function () {
		sock.send('test'); // $clientSend
	};
	
	sock.onmessage = function (e) {
		console.log('message', e.data); // $ remoteFlow
		sock.close();
	}; // $clientReceive
	
	sock.addEventListener('message', function (event) {
		console.log('Using addEventListener ', event.data); // $ remoteFlow
	}); // $clientReceive
})();

export const MyWebSocket = WebSocket;
export const MySockJS = SockJS;
export const myWebSocketInstance = new WebSocket('ws://localhost:8080'); // $ clientSocket
export const mySockJSInstance = new SockJS('http://0.0.0.0:9999/echo'); // $ clientSocket

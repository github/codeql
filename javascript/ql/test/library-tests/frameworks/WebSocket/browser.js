(function () {
	const socket = new WebSocket('ws://localhost:8080');

	socket.addEventListener('open', function (event) {
		socket.send('Hi from browser!');
	});

	socket.addEventListener('message', function (event) {
		console.log('Message from server ', event.data);
	});

	socket.onmessage = function (event) {
		console.log("Message from server 2", event.data)
	};
})();


(function () {
	var sock = new SockJS('http://0.0.0.0:9999/echo');
	sock.onopen = function () {
		sock.send('test');
	};
	
	sock.onmessage = function (e) {
		console.log('message', e.data);
		sock.close();
	};
	
	sock.addEventListener('message', function (event) {
		console.log('Using addEventListener ', event.data);
	});
})
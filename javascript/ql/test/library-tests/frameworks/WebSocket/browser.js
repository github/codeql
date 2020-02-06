(function () {
	const socket = new WebSocket('ws://localhost:8080');

	socket.addEventListener('open', function (event) {
    	socket.send('Hi from browser!');
	});

	socket.addEventListener('message', function (event) {
	    console.log('Message from server ', event.data);
	});
	
	socket.onmessage = function(event) {
      console.log("Message from server 2", event.data)
    };
})();
import { MyWebSocket, MySockJS, myWebSocketInstance, mySockJSInstance } from './browser.js';

(function () {
	const socket = new MyWebSocket('ws://localhost:9080'); // $ clientSocket

	socket.addEventListener('open', function (event) {
		socket.send('Hi from browser!'); // $ clientSend
	});

	socket.addEventListener('message', function (event) {
		console.log('Message from server ', event.data);
	}); // $ clientReceive

	socket.onmessage = function (event) {
		console.log("Message from server 2", event.data)
	}; // $ clientReceive
})();


(function () {
	var sock = new MySockJS('http://0.0.0.0:9999/echo'); // $ clientSocket
	sock.onopen = function () {
		sock.send('test'); // $ clientSend
	};
	
	sock.onmessage = function (e) {
		console.log('message', e.data);
		sock.close();
	}; // $ clientReceive
	
	sock.addEventListener('message', function (event) {
		console.log('Using addEventListener ', event.data);
	}); // $ clientReceive
})();


(function () {
    myWebSocketInstance.addEventListener('open', function (event) {
        myWebSocketInstance.send('Hi from browser!'); // $ clientSend
    });

    myWebSocketInstance.addEventListener('message', function (event) {
        console.log('Message from server ', event.data);
    }); // $ clientReceive

    myWebSocketInstance.onmessage = function (event) {
        console.log("Message from server 2", event.data)
    }; // $ clientReceive
})();


(function () {
    mySockJSInstance.onopen = function () {
        mySockJSInstance.send('test'); // $ clientSend
    };
    
    mySockJSInstance.onmessage = function (e) {
        console.log('message', e.data);
        mySockJSInstance.close();
    }; // $ clientReceive
    
    mySockJSInstance.addEventListener('message', function (event) {
        console.log('Using addEventListener ', event.data);
    }); // $ clientReceive
})();


const recv_message = function (e) {
    console.log('Received message:', e.data);
}; // $ MISSING: clientReceive

(function () {
    myWebSocketInstance.onmessage = recv_message.bind(this);
})();

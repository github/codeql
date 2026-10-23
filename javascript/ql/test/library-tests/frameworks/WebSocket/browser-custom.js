import { MyWebSocket, MySockJS, myWebSocketInstance, mySockJSInstance } from './browser.js';

(function () {
	const socket = new MyWebSocket('ws://localhost:9080'); // $ clientSocket

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
	var sock = new MySockJS('http://0.0.0.0:9999/echo'); // $ clientSocket
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


(function () {
    myWebSocketInstance.addEventListener('open', function (event) {
        myWebSocketInstance.send('Hi from browser!'); // $ clientSend
    });

    myWebSocketInstance.addEventListener('message', function (event) { // $ clientReceive
        console.log('Message from server ', event.data); // $ remoteFlow
    });

    myWebSocketInstance.onmessage = function (event) { // $ clientReceive
        console.log("Message from server 2", event.data); // $ remoteFlow
    };
})();


(function () {
    mySockJSInstance.onopen = function () {
        mySockJSInstance.send('test'); // $ clientSend
    };
    
    mySockJSInstance.onmessage = function (e) { // $ clientReceive
        console.log('message', e.data); // $ remoteFlow
        mySockJSInstance.close();
    };
    
    mySockJSInstance.addEventListener('message', function (event) { // $ clientReceive
        console.log('Using addEventListener ', event.data); // $ remoteFlow
    });
})();


const recv_message = function (e) { // $ clientReceive
    console.log('Received message:', e.data); // $ remoteFlow
};

(function () {
    myWebSocketInstance.onmessage = recv_message.bind(this);
})();

function controller(msg) {
	if (msg == 'start')
		start();
	else if (msg == 'start')
		stop();
	else
		throw new Error("Message not understood.");
}

if (f({x: true}))
	foo();
else if (f({y: false}))
	bar();
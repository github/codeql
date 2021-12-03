function controller(msg) {
	if (msg == 'start')
		start();
	else if (msg == 'stop')
		stop();
	else
		throw new Error("Message not understood.");
}
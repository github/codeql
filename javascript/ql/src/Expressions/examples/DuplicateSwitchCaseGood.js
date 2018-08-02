function controller(msg) {
	switch (msg) {
	case 'start':
		start();
		break;
	case 'stop':
		stop();
		break;
	default:
		throw new Error("Message not understood.");
	}
}
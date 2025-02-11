function controller(msg) {
	switch (msg) {
	case 'start':
		start();
		break;
	case 'start': // $ Alert
		stop();
		break;
	default:
		throw new Error("Message not understood.");
	}
}
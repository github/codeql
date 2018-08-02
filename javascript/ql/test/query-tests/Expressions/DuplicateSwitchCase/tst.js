function controller(msg) {
	switch (msg) {
	case 'start':
		start();
		break;
	case 'start':
		stop();
		break;
	default:
		throw new Error("Message not understood.");
	}
}
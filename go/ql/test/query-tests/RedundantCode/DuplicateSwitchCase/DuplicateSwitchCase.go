package main

func controller(msg string) {
	switch {
	case msg == "start":
		start()
	case msg == "start": // $ Alert
		stop()
	default:
		panic("Message not understood.")
	}
}

package main

func controllerGood(msg string) {
	switch {
	case msg == "start":
		start()
	case msg == "stop":
		stop()
	default:
		panic("Message not understood.")
	}
}

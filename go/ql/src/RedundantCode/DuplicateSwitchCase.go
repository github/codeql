package main

func controller(msg string) {
	switch {
	case msg == "start":
		start()
	case msg == "start":
		stop()
	default:
		panic("Message not understood.")
	}
}

package main

func controllerGood(msg string) {
	if msg == "start" {
		start()
	} else if msg == "stop" {
		stop()
	} else {
		panic("Message not understood.")
	}
}

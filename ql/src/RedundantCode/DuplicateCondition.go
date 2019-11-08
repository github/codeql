package main

func controller(msg string) {
	if msg == "start" {
		start()
	} else if msg == "start" {
		stop()
	} else {
		panic("Message not understood.")
	}
}

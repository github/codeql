package main

func controller(msg string) {
	if msg == "start" {
		start()
	} else if msg == "start" { // NOT OK
		stop()
	} else {
		panic("Message not understood.")
	}
}

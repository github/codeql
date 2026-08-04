package main

func controller(msg string) {
	if msg == "start" { // $ Source
		start()
	} else if msg == "start" { // $ Alert // NOT OK
		stop()
	} else {
		panic("Message not understood.")
	}
}

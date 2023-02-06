package main

type counter struct {
	val int
}

func (w counter) reset() {
	w.val = 0 // NOT OK
}

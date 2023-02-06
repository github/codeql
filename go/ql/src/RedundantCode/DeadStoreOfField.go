package main

type counter struct {
	val int
}

func (c counter) reset() {
	c.val = 0
}

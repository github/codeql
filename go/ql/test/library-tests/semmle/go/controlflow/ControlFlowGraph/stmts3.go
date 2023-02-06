package main

import "flag"

func test15() int {
	const (
		red = iota
		green
		blue
	)
	return red + green - blue
}

func test16(x *int) {
	*x = 42
}

func test17() {
	flag.Usage = func() {}
}

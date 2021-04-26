package main

import (
	"github.com/github/nonexistent"
)

func test0() {
	var v nonexistent.T
	nonexistent.F()

	w := nonexistent.K

	use(v, w)
}

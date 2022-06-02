package main

import (
	"errors"
)

func unreachable() {}

func reachable() {}

func test1() {
	return
	unreachable() // NOT OK
}

func test2() {
	select {}
	unreachable() // NOT OK
}

func test3() {
	for i := 0; i < 10; unreachable() { // NOT OK
		return
	}
}

func test4() {
	for true {
	}
	unreachable() // NOT OK
}

func test5(cond bool) {
	for true {
		if cond {
			break
		}
	}
	reachable()
}

func test6(cond bool) {
	for true {
		if cond {
			continue
		}
		reachable()
	}
	unreachable() // NOT OK
}

func test7(cond bool) {
	for true {
		continue
		unreachable() // NOT OK
	}
	unreachable() // NOT OK
}

func test8() {
	if true {
		return
	}
	unreachable() // OK: deliberately unreachable
}

func test9(x int) int {
	switch x {
	case 0:
		return 1
	case 2:
		return 3
	default:
		return -1
	}
	panic("How did we get here?") // OK
}

func test10(x int) int {
	switch x {
	case 0:
		return 1
	case 2:
		return 3
	default:
		return 4
	}
	return -1 // OK
}

const debug = false

var counter int

func count() {
	if debug {
		counter++ // OK
	}
}

func test11() {
	if false || true {
	}
	if true && !false {
	}
}

func test12() bool {
	select {}
	// Not flagged as this is a primitive return
	return true
}

func test13() bool {
	select {}
	// Not flagged as this is a primitive return
	return false
}

type mystruct struct {
	x int
	y bool
}

func test14() mystruct {
	select {}
	// Not flagged as this is a struct literal composed of primitives
	return mystruct{0, true}
}

func test15() error {
	select {}
	// Not flagged as any expression is acceptable for type `error`
	return errors.New("unreachable")
}

func test16() *mystruct {
	select {}
	// Flagged, as `return nil` is possible and preferable when the
	// return site is unreachable.
	return &mystruct{0, true}
}

func test17() int {
	select {}
	// Flagged, as a nontrivial unreachable return
	return test10(1)
}

func test18() bool {
	select {}
	// Flagged, as a nontrivial unreachable return
	return test10(1) == 1
}

func test19() mystruct {
	select {}
	// Flagged, as a nontrivial unreachable return
	return mystruct{test10(1), test10(2) == 2}
}

func main() {}

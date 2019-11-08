package main

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

func main() {}

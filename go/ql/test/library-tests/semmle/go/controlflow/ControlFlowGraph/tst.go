package main

func check(x int) {
	switch {
	case x < 23:

	case x < 42:

	case x < 23: // NOT OK

	}
}

func check2(value int64) {
	switch {
	case value < 1024*1024*1024*1024:

	case value < 1024*1024*1024*1024*1024:

	}
}

func check3() {
	switch {
	}
}

func check4() {
	switch {
	default:
	}
}

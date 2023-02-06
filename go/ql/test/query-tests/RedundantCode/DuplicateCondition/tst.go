package main

func check(x int) bool {
	return true
}

func main() {
	if ok := check(42); ok {
	} else if ok { // NOT OK
	} else if ok := check(23); ok { // OK
	}
}

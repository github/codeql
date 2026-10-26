package main

func check(x int) bool {
	return true
}

func main() {
	if ok := check(42); ok { // $ Source
	} else if ok { // $ Alert // NOT OK
	} else if ok := check(23); ok { // OK
	}
}

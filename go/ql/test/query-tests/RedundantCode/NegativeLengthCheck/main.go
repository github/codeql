package main

import "os"

func main() {
	if len(os.Args) < 0 { // $ Alert // NOT OK
		println("No arguments provided.")
	}

	if len(os.Args) <= 0 { // OK
		println("No arguments provided.")
	}

	if cap(os.Args) < 0 { // $ Alert // NOT OK
		println("Out of space!")
	}

	if len(os.Args) <= -1 { // $ Alert // NOT OK
		println("No arguments provided.")
	}

	if len(os.Args) == -1 { // $ Alert // NOT OK
		println("No arguments provided.")
	}
}

func checkNegative(x uint) bool {
	return x < 0 // $ Alert // NOT OK
}

func checkNonPositive(x uint) bool {
	return x <= 0 // OK
}

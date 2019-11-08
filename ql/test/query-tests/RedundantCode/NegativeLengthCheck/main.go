package main

import "os"

func main() {
	if len(os.Args) < 0 { // NOT OK
		println("No arguments provided.")
	}

	if len(os.Args) <= 0 { // OK
		println("No arguments provided.")
	}

	if cap(os.Args) < 0 { // NOT OK
		println("Out of space!")
	}

	if len(os.Args) <= -1 { // NOT OK
		println("No arguments provided.")
	}

	if len(os.Args) == -1 { // NOT OK
		println("No arguments provided.")
	}
}

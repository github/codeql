package main

import (
	"fmt"
	"os"
)

func user(input string) {

	ptr, err := os.Open(input)
	// BAD: ptr is dereferenced before either it or `err` has been checked.
	fmt.Printf("Opened %v\n", *ptr)
	if err != nil {
		fmt.Printf("Bad input: %s\n", input)
	}

}

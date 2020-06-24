package main

import (
	"fmt"
	"os"
)

func user(input string) {

	ptr, err := os.Open(input)
	if err != nil {
		fmt.Printf("Bad input: %s\n", input)
		return
	}
	// GOOD: `err` has been checked before `ptr` is used
	fmt.Printf("Result was %v\n", *ptr)

}

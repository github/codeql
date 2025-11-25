package main

import (
	"fmt"
)

func main() {
	userInput := readUser() // source: tainted
	fmt.Println(userInput) // sink: logging/printing (should be flagged by a positive test)
}

func readUser() string { return "line\ninjection" }
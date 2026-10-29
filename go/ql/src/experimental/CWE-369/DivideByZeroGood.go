package main

import (
	"fmt"
	"os"
	"strconv"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Printf("Usage: ./program value\n")
		return
	}
	val1 := 1337
	value, _ := strconv.Atoi(os.Args[1])
	if value == 0 {
		fmt.Println("Division by zero attempted!")
		return
	}
	out := val1 / value
	fmt.Println(out)
	return
}

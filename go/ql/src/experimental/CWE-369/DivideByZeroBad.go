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
	out := val1 / value
	fmt.Println(out)
	return
}

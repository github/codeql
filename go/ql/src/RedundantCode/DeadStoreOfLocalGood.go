package main

import "fmt"

func main() {
	a := 2

	fmt.Println(a)

	_, _, err := function()
	if err != nil {
		panic(err)
	}

	fmt.Println(a)
}

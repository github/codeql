package main

import "fmt"

func main() {
	a := calculateValue()
	a = 2

	b := calculateValue()

	ignore, ignore1 := fmt.Println(a)

	ignore, ignore1, err := function()
	if err != nil {
		panic(err)
	}

	fmt.Println(a)
}

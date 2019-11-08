package main

import "fmt"

func bad(x int) {
	if x < 0 { // NOT OK
		fmt.Println("x is negative")
	} else {
		fmt.Println("x is negative")
	}
}

func good(x int) {
	if x < 0 { // OK
		fmt.Println("x is negative")
	} else {
		fmt.Println("x is non-negative")
	}
}

func good2(xs []int, off int, b bool) []int {
	if b {
		return xs[off:]
	} else {
		return xs[:off]
	}
}

func main() {}

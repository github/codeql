package main

import "fmt"

func f1(i int) int {
	return i
}

func f2(i int) int {
	fmt.Println("hi")
	return i
}

func abs(i int) int {
	if i < 0 {
		return -i
	}
	return i
}

func div(x int, y int) int {
	return x / y
}

func main() {
	f1(42)     // NOT OK
	f2(42)     // OK
	f1(f2(42)) // NOT OK
	abs(-2)    // NOT OK
	div(1, 0)  // OK
	dostuff()  // OK
	cleanup()  // OK
}

func cleanup() {
	// nothing to clean up
}

package main

import "fmt"

func foo(x int) bool {
	return x == x // NOT OK
}

func isNaN(x float32) bool {
	return x != x // OK
}

func main() {
	foo(42)
}

const mode = "Debug"

func log(msg string) {
	if mode == "Debug" {
		fmt.Println(msg)
	}
}

func bar() {
	if ptrsize == 8 { // OK
		fmt.Println()
	}
}

func bump(x *int) {
	*x++
}

func baz() bool {
	var x = 0
	bump(&x)
	return x == 0
}

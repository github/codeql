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

type counter int

func (x *counter) bump() {
	*x++
}

func (x counter) bimp() {
	x++
}

func baz2() bool {
	var x counter
	x.bump()
	return x == 0 // OK
}

func baz3() bool {
	var y counter
	y.bimp()
	return y == 0 // NOT OK
}

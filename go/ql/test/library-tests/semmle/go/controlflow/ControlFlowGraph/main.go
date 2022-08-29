package main

import (
	"fmt"
	"math/rand"
)

func cond() bool {
	return rand.Float64() >= 0.5
}

func main() {
	var x int
	y := 23
	fmt.Print(x, y)
	if cond() {
		y += 19
	}
	fmt.Print(x, y)
	if cond() {
		x = y
	}
	fmt.Print(x, y)
}

func foo(x int) (int, int) {
	a, b := x, 0
	if cond() {
		a, b = b, a
	}
	return a, b
}

func bump(x *int) {
	*x += 19
}

func bar() {
	x := 23
	ptr := &x
	if cond() {
		bump(ptr)
	}
	fmt.Print(x)
}

func baz() (result int) {
	result = 42
	return
}

func baz2() (result int) {
	return
}

func loops() {
	var x int
	for cond() {
		x = 2
	}
	fmt.Print(x)

	y := 1
	for i := 0; ; i++ {
		if cond() {
			break
		}
		y = 2
	}
	fmt.Print(y)

	z := 1
	for i := 0; ; i++ {
		z = 2
		if cond() {
			break
		}
	}
	fmt.Print(z)
}

func multiRes() (a int, b float32) {
	x := 23
	x, a = x+19, x
	return
}

func fooWithUnderscores(x int) (int, int) {
	a, b := x, 0
	if cond() {
		a, _ = b, a
	} else {
		_, b = b, a
	}
	return a, b
}

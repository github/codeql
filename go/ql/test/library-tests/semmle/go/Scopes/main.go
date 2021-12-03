package main

import "fmt"

type t struct {
	x int
}

func main() {
	fmt.Println("hi")
}

func (recv *t) meth() int {
	return recv.x
}

func foo(x iHaveAMethod, y *t) {
	x.meth()
	y.meth()
	(*t).meth(y)
}

func (recv *t) bump() {
	recv.x++
}

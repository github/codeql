package main

import "fmt"

func recoverPanic() {
	blah := recover()
	fmt.Println("recovered: ", blah)
}

func canRecover() {
	defer recoverPanic()
	panic("")
}

type Callback struct {
	fn func() bool
}

func (methods *Callback) run() {
	methods.fn()
}

func defertest(callback Callback) bool {
	defer callback.fn()
	defer (&callback).fn()
	fmt.Println("print something")
	return false
}

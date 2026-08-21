package main

import (
	"fmt"
	"os"
)

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

func deferBeforeExit() {
	defer recoverPanic()
	os.Exit(1)
}

func deferredPanic() {
	defer recoverPanic()
	defer panic("deferred panic")
}

func finalDeferredPanic() {
	defer panic("final deferred panic")
}

func deferredExitStopsRemaining() {
	defer recoverPanic()
	defer os.Exit(1)
}

func deferBeforePossiblePanic(values []int, index int) {
	defer recoverPanic()
	_ = values[index]
}

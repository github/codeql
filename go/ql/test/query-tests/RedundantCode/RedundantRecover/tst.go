package main

import "fmt"

func callRecover3() {
	// This will have no effect because panics do not propagate down the stack,
	// only back up the stack
	if recover() != nil {
		fmt.Printf("recovered")
	}
}

func fun3() {
	panic("3")
	callRecover3()
}

func callRecover4() {
	// This is not flagged because callRecover4 is called in a defer statement
	// at least once
	if recover() != nil {
		fmt.Printf("recovered")
	}
}

func fun4a() {
	panic("4")
	callRecover4()
}

func fun4b() {
	defer callRecover4()
	panic("4")
}

func neverCalled() {
	// This will not be flagged because it is not called from anywhere
	if recover() != nil {
		fmt.Printf("recovered")
	}
}

func main() {
	fun1()
	fun2()
	fun3()
	fun4a()
	fun4b()
}

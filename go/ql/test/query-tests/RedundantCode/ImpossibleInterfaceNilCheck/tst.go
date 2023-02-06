package main

import "fmt"

func test1() {
	var x *int = nil
	var y interface{} = x
	fmt.Println(x == nil)
	fmt.Println(x == y)
	fmt.Println(y == nil) // NOT OK
}

func test2() {
	var x *int = nil
	test3(x)
}

func test3(y interface{}) {
	// we don't want to flag this one, even though we might be able to
	// inter-procedurally establish that y cannot be nil
	fmt.Println(y == nil) // OK
}

func test4() {
	var y interface{}
	fmt.Println(y == nil) // OK
}

package main

import "fmt"

// codeql test: expect frontend errors

func errtest() {
	x := unknownFunction()
	var y interface{} = x
	fmt.Println(y == nil) // OK since we don't know the return type of unknownFunction
}

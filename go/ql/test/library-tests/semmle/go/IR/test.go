package test

import (
	"fmt"
)

func testChannel() {
	var ch chan bool
	got, ok := <-ch
	fmt.Printf("%v %v", got, ok)
}

func testMap() {
	var m map[string]string
	got, ok := m["key"]
	fmt.Printf("%v %v", got, ok)
}

func testTypeAssert() {
	var i interface{}
	got, ok := i.(string)
	fmt.Printf("%v %v", got, ok)
}

func f(x, y int)    {}
func g() (int, int) { return 0, 0 }

func testNestedFunctionCalls() {
	f(g())

	// Edge case: when we call a function from a variable, `getTarget()` is not defined
	v := g
	f(v())
}

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

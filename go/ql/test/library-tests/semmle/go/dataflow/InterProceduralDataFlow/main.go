package main

import "fmt"

func id(x string) string {
	return x
}

func test1(x string) {
	var sink1 = x
	fmt.Println(sink1)
}

func test2() string {
	var source1 = "source1"
	return source1
}

func test3(x string) {
	var sink2 = x
	fmt.Println(sink2)
}

func test4() {
	sink3 := id(test2())
	test3(sink3)
}

var v string

func test5(x string) {
	v = x
}

func test6() {
	test1(v)
}

const source4 = "source4"

func test7() {
	test3(source4) // flow through constants
}

func main() {
	var source2 = "source2"
	test1(source2) // flow into function
	test1(test2()) // flow out of, and then into function
	id(source2)
	test1(id("not a source")) // no flow

	// flow through package variables
	var source3 = "source3"
	test5(source3)
	test6()
}

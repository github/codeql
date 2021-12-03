package main

import "fmt"

func test12() *string {
	source6 := "source6"
	return &source6
}

func test13() {
	test1(*test12())
}

func test14(x *string) {
	sink5 := *x
	fmt.Println(sink5)
}

func test15() {
	test14(test12())
}

func test3a(x string) *string {
	var sink2 = x
	fmt.Println(sink2)
	return &x
}

func test4a() {
	test3a(test2())
}

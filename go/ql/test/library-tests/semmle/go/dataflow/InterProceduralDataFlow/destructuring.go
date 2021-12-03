package main

import "fmt"

func test17() (string, string) {
	source1 := "tainted"
	return source1, "not tainted"
}

func test17b() (string, string) {
	source2 := "also tainted"
	return source2, "also not tainted"
}

func test17c() (string, string) {
	return test17b()
}

func test18(s1, s2 string) {
	sink1 := s1 // source1 flows here
	sink2 := s2
	fmt.Println(sink1, sink2)
}

func test19() {
	s1, s2 := test17()
	sink1 := s1 // source1 flows here
	sink2 := s2
	fmt.Println(sink1, sink2)

	test18(test17())

	s3, s4 := test17c()
	sink3 := s3 // source2 flows here
	sink4 := s4
	fmt.Println(sink3, sink4)
}

package main

import "fmt"

type s struct {
	f, g string
}

func test8() s {
	source5 := "source5"
	return s{f: source5, g: "not a source"}
}

func test8a() s {
	source5a := "source5a"
	var s s
	s.f = source5a
	return s
}

func test9() {
	test1(test8().f)
	test1(test8().g)
	test1(test8a().f)
	test1(test8a().g)
}

func test10(x s) {
	sink4 := x.f
	fmt.Println(sink4)
}

func test11() {
	test10(test8())
	test10(test8a())
}

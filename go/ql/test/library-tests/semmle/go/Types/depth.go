package main

import "fmt"

type a struct {
	b // we get f from here
	c // but not from here because it is nested more deeply
}

type b struct {
	f int
}

type c struct {
	d
}

type d struct {
	f string
}

func test2() {
	x := a{b{0}, c{d{"hi"}}}
	fmt.Printf("%v", x.f) // prints `0`, not `"hi"`
}

package main

import "fmt"

type t interface {
	m(arg string)
	n(arg string)
}

// implements t
type strct struct{}

func (strct) m(arg string) {
	sink6 := arg
	fmt.Println(sink6)
}

func (*strct) n(arg string) {
	sink7 := arg
	fmt.Println(sink7)
}

// does not implement t
type strct2 struct{}

func (strct2) m(arg string) {
	sink8 := arg
	fmt.Println(sink8)
}

func test16(arg t) {
	source7 := "source7"
	arg.m(source7)
	arg.n(source7)
}

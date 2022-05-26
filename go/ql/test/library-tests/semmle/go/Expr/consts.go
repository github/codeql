package main

import (
	"fmt"
	"unsafe"
)

var i = 0

const (
	a = "a"
	b
	c = 4
	d = iota
	e
	f = unsafe.Sizeof(one())
	g = f + 1
)

func one() int {
	return 1
}

func inc() int {
	i += 1
	return i
}

func main() {
	fmt.Println(a, b, c, d, e, f, g)
	fmt.Println("value", "split"+"string",
		20, 3+2, 2i, 0.24i, 1+1i, 2.3-9.7i,
		'a', '\x8b', 3.141592653589793238462*8)
	fmt.Println(h, j, k, l, m)
}

type mybool bool
type mycomplex complex128
type myint int
type myfloat float64
type mystring string

const (
	h mybool    = true
	j mycomplex = 3i
	k myint     = 2
	l myfloat   = 1.0
	m mystring  = "hi"
)

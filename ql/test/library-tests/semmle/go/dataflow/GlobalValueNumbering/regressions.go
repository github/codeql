package main

import "unsafe"

const c = unsafe.Sizeof(test())

const d = false

const e = !d

const f = true

type cell struct {
	payload int
	next *cell
}

func test4(x, y cell) int {
	return x.payload +
		y.payload +
		x.next.payload +
		y.next.payload
}
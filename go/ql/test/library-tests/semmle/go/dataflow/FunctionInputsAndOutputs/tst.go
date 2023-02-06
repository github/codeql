package main

import (
	"bytes"
	"io"
)

func test4(reader io.Reader) {
	bytesBuffer := new(bytes.Buffer)
	bytesBuffer.ReadFrom(reader)
}

func test5(xs ...*int) {}

func test6(x, y *int) {
	test5(x, y)
	s := []*int{x, y}
	test5(s...)
}

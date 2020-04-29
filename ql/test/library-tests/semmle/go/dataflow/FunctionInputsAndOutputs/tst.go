package main

import (
	"bytes"
	"io"
)

func test4(reader io.Reader) {
	bytesBuffer := new(bytes.Buffer)
	bytesBuffer.ReadFrom(reader)
}

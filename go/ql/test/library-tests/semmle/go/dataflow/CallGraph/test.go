package main

import (
	"fmt"
	"hash"
	"io"
)

type Resetter struct{}

func (_ Resetter) Reset() {} // name: Resetter.Reset

type MockHash struct {
	Resetter
}

func (_ MockHash) Write(p []byte) (n int, err error) { // name: MockHash.Write
	fmt.Println("MockHash.Write")
	return 0, nil
}

func (_ MockHash) Sum(b []byte) []byte {
	return nil
}

func (_ MockHash) Size() int {
	return 0
}

func (_ MockHash) BlockSize() int {
	return 0
}

type MockWriter struct{}

func (_ MockWriter) Write(p []byte) (n int, err error) { // name: MockWriter.Write
	fmt.Println("MockWriter.Write")
	return 0, nil
}

func test5(h hash.Hash, w io.Writer) { // name: test5
	h.Write(nil) // callee: MockHash.Write
	f1 := h.Write
	f1(nil) // callee: MockHash.Write

	w.Write(nil) // callee: MockWriter.Write callee: MockHash.Write
	f2 := w.Write
	f2(nil) // callee: MockWriter.Write callee: MockHash.Write

	h.Reset() // callee: Resetter.Reset
	f3 := h.Reset
	f3() // callee: Resetter.Reset
}

func test6(h MockHash, w MockWriter) {
	test5(h, w) // callee: test5
	f := test5
	f(h, w) // callee: test5
}

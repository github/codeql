package main

type baseT struct {
	length int
}

func (x *baseT) GetLength() int {
	return x.length
}

type t struct {
	baseT
}

func (x *t) foo(other t) bool {
	return x.GetLength() != x.GetLength()
}

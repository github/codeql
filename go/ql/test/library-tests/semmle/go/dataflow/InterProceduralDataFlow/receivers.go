package main

type mystring string

func (recv mystring) sink() mystring {
	sink := recv
	return sink
}

func test20() {
	source := mystring("source")
	source.sink()
}

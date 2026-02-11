package main

func main() {}

func f() {}
func g() {}

func hasNested[U int]() {

	myNested := func() int { return 1 }
	myNested()

}

var x int = 0

type myType[T ~string] []T

func (m myType[U]) f() {}

package main

func main() {}

func f() {}
func g() {}

func hasNested() {

	myNested := func() int { return 1 }
	myNested()

}

var x int = 0

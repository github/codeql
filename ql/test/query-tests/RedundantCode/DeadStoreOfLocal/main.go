package p

import "fmt"

func test() {
	if false {
		x := deadStore() // OK
		fmt.Println(x)
		x++ // NOT OK, but in dead code, so not flagged
	}
}

func deref(p *int) {
	fmt.Println(*p)
}

func main() {
	var x int
	p := &x
	x = deadStore()
	deref(p)
}

func deadParameter(x int) bool { // we don't want to flag x here
	x = deadStore() // but we do want to flag this
	return true
}

func test2(x int) (int, int) {
	y := x >> 5
	z := x % (1)
	return z, y % 13
}

func test3() (x int, y int) {
	return unknownFunction()
}

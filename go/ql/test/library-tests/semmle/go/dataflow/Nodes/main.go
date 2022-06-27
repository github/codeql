package main

import "fmt"

func main() {
	x, y, z := 1, 2, 3
	fmt.Println(x + (y + z))
	go f()
	x, y = test()
	fmt.Println(x + y)
}

func f() {
	ss := make([]string, 1)
	ss[0] = "hi"
	fmt.Println(ss, 0, ss[0])
	ss[0] += "!"
}

func test() (int, int) {
	return 23, 42
}

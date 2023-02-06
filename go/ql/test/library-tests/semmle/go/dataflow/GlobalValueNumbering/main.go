package main

import "fmt"

func bump(x *int) {
	*x++
}

func main() {
	x := 0
	var y int
	fmt.Println(x, y)

	z := 1
	bump(&z)
	fmt.Println(x, y, z)

	ss := make([]string, 3)
	ss[2] = "Hello, world!"
	fmt.Println(ss)
}

func test() (res int) {
	res = 4
	return
}

func test2() (res int) {
	res = 5
	return 6
}

func test3() (res int) {
	res = 7
	defer func() {
		res = 8
	}()
	return 9
}

package main

import "fmt"

func op(op string, x int, y int) int {
	if op == "+" {
		return x + y
	} else {
		return x - y
	}
}

func op2(op string, x int, y int) (res int) {
	if op == "+" {
		res = x + y
	} else {
		return x - y
	}
	return
}

type counter struct {
	count int
}

func (c *counter) bump() int {
	c.count++
	return c.count
}

func test() (int, int) {
	return 23, 42
}

func test2() (x int, y int) {
	y, x = 42, 23
	return
}

func test3(b bool) (int, y int) {
	defer func() {
		y++
	}()
	if b {
		return 0, 1
	}
	return 0, 4
}

func main() {
	op("+", 1, 1)
	c := counter{}
	op2("-", 2, c.bump())
	x, y := test()
	fmt.Printf("%d, %d", x, y)
	x, y = test2()
	fmt.Printf("%d, %d", x, y)
}

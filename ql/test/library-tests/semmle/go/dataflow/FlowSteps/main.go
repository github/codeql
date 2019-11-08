package main

func test1(x int, fn func() int) bool {
	var y int
	if x >= 0 {
		y = x
	} else {
		y = -x
	}
	z := x <= y && y >= x+fn()
	return bool(z)
}

func test2() func() int {
	acc := 0
	return func() int {
		acc++
		return acc
	}
}

func test3(b bool, x interface{}) string {
	if b {
		return x.(string)
	}
	n, ok := x.(int)
	if ok && n > 10 {
		return "yes"
	}
	return "no"
}

func main() {
	test1(test2()(), test2())
}

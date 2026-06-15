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

func test9() []int {
	s := []int{1, 2, 3}
	s1 := append(s, 4, 5, 6)
	s2 := append(s, s1...)
	s4 := make([]int, 4)
	copy(s, s4)
	return s2
}

func test10(xs []int) (keys int, vals int) {
	for k, v := range xs {
		vals += v // taint from `xs`
		keys += k // no taint from `xs`
	}
	return
}

func testch() {
	var ch chan bool
	ch <- true
	<-ch
}

func testMinMax() (int, int) {
	x := 1
	y := 2
	z := 3
	a := min(x, y, z)
	b := max(x, y, z)
	return a, b
}

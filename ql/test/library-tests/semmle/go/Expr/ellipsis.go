package main

func f(x int, ys ...int) {
}

func ellipsisTest() {
	f(1)
	f(1, 2)
	f(1, 2, 3)
	f(1, []int{2, 3}...)
}

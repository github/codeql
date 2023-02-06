package main

func fn(x int, ys ...int) {
}

func ellipsisTest() {
	fn(1)
	fn(1, 2)
	fn(1, 2, 3)
	fn(1, []int{2, 3}...)
}

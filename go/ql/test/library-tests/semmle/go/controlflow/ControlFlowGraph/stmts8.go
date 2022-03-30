package main

func test20(x int) (int, int) {
	y := x >> 5
	z := x % (1)
	return z, y % 13
}

func isLinux() bool {
	if linux {
		return true
	}
	return false
}

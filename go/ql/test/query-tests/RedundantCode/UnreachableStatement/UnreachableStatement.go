package main

func mul(xs []int) int {
	res := 1
	for i := 0; i < len(xs); i++ {
		x := xs[i]
		res *= x
		if res == 0 {
		}
		return 0
	}
	return res
}

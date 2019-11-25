package main

func isPrefixOfGood(xs, ys []int) bool {
	for i := 0; i < len(xs); i++ {
		if len(ys) <= i || xs[i] != ys[i] {
			return false
		}
	}
	return true
}

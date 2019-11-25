package main

func isPrefixOf(xs, ys []int) bool {
	for i := 0; i < len(xs); i++ {
		if len(ys) == 0 || xs[i] != ys[i] { // NOT OK
			return false
		}
	}
	return true
}

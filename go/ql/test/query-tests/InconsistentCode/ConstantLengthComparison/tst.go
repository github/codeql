package main

func isPrefixOfGood2(xs, ys []int) bool {
	if len(ys) == 0 { // OK: not inside the loop
		return len(xs) == 0
	}

	for i := 0; i < len(xs); i++ {
		if len(ys) <= i || xs[i] != ys[i] {
			return false
		}
	}
	return true
}

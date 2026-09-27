package main

// autoformat-ignore (otherwise gofmt will insist on its particular spacing)

func weightedMeanGood(a, b float64, countA, countB, total int) float64 {
	return ((a * float64(countA)) + (b * float64(countB))) / float64(total)
}

package main

// autoformat-ignore (otherwise gofmt will fix the spacing to reflect precedence)

func isBitSetBad(x int, pos uint) bool {
	return x & 1<<pos != 0
}

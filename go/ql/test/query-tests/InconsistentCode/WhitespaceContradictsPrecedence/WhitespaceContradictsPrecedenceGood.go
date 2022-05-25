package main

// autoformat-ignore (otherwise gofmt will insist on its particular spacing)

func isBitSetGood(x int, pos uint) bool {
	return x & (1<<pos) != 0
}

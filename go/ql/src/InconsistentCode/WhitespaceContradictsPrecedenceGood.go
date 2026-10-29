package main

func isBitSetGood(x int, pos uint) bool {
	return x&(1<<pos) != 0
}

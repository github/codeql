package main

func shiftGood(base int64) int64 {
	return base << 40
}

var x2 = shiftGood(1)

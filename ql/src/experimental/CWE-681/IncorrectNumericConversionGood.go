package main

import (
	"math"
	"strconv"
)

func main() {

}

const DefaultAllocate int32 = 256

func parseAllocateGood1(desired string) int32 {
	parsed, err := strconv.Atoi(desired)
	if err != nil {
		return DefaultAllocate
	}
	// GOOD: check for lower and uppper bounds
	if parsed > 0 && parsed <= math.MaxInt32 {
		return int32(parsed)
	}
	return DefaultAllocate
}
func parseAllocateGood2(desired string) int32 {
	// GOOD: parse specifying the bit size
	parsed, err := strconv.ParseInt(desired, 10, 32)
	if err != nil {
		return DefaultAllocate
	}
	return int32(parsed)
}

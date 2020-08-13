package main

import (
	"strconv"
)

func parseAllocateBad1(wanted string) int32 {
	parsed, err := strconv.Atoi(wanted)
	if err != nil {
		panic(err)
	}
	return int32(parsed)
}
func parseAllocateBad2(wanted string) int32 {
	parsed, err := strconv.ParseInt(wanted, 10, 64)
	if err != nil {
		panic(err)
	}
	return int32(parsed)
}

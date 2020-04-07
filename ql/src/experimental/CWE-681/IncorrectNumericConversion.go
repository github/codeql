package main

import (
	"strconv"
)

func parseAllocate(wanted string) int32 {
	parsed, err := strconv.Atoi(wanted)
	if err != nil {
		panic(err)
	}
	return int32(parsed)
}

//go:build gc && go1.4
// +build gc,go1.4

package main

import (
	"strconv"
)

func testIntSizeIsArchicturallyDependent1() {
	{
		parsed, err := strconv.ParseInt("3456", 10, 0)
		if err != nil {
			panic(err)
		}
		_ = int32(parsed)  // $ hasValueFlow="parsed"
		_ = uint32(parsed) // $ hasValueFlow="parsed"
	}
	{
		parsed, err := strconv.ParseInt("3456", 10, 64)
		if err != nil {
			panic(err)
		}
		_ = int(parsed)  // $ hasValueFlow="parsed"
		_ = uint(parsed) // $ hasValueFlow="parsed"
	}
}

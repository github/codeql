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
		_ = int32(parsed)  // $ hasValueFlow="type conversion"
		_ = uint32(parsed) // $ hasValueFlow="type conversion"
	}
	{
		parsed, err := strconv.ParseInt("3456", 10, 64)
		if err != nil {
			panic(err)
		}
		_ = int(parsed)  // $ hasValueFlow="type conversion"
		_ = uint(parsed) // $ hasValueFlow="type conversion"
	}
}

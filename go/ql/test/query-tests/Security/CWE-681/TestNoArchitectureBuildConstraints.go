//go:build gc && go1.4
// +build gc,go1.4

package main

import (
	"strconv"
)

func testIntSizeIsArchicturallyDependent1() {
	{
		parsed, err := strconv.ParseInt("3456", 10, 0) // $ Source
		if err != nil {
			panic(err)
		}
		_ = int32(parsed)  // $ Alert
		_ = uint32(parsed) // $ Alert
	}
	{
		parsed, err := strconv.ParseInt("3456", 10, 64) // $ Source
		if err != nil {
			panic(err)
		}
		_ = int(parsed)  // $ Alert
		_ = uint(parsed) // $ Alert
	}
}

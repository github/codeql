// +build gc
// +build go1.4

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
		_ = int32(parsed)  // NOT OK
		_ = uint32(parsed) // NOT OK
	}
	{
		parsed, err := strconv.ParseInt("3456", 10, 64)
		if err != nil {
			panic(err)
		}
		_ = int(parsed)  // NOT OK
		_ = uint(parsed) // NOT OK
	}
}

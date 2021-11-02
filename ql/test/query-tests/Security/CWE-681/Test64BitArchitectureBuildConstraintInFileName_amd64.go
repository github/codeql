// Note that the filename acts as an implicit build constraint

package main

import (
	"strconv"
)

func testIntSinkAmd64() {
	{
		parsed, err := strconv.ParseInt("3456", 10, 64)
		if err != nil {
			panic(err)
		}
		_ = int(parsed)
		_ = uint(parsed)
	}
	{
		parsed, err := strconv.ParseUint("3456", 10, 64)
		if err != nil {
			panic(err)
		}
		_ = int(parsed)
		_ = uint(parsed)
	}
}

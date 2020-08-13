// Note that the filename acts as an implicit build constraint

package main

import (
	"strconv"
)

func testIntSource386() {
	{
		parsed, err := strconv.ParseInt("3456", 10, 0)
		if err != nil {
			panic(err)
		}
		_ = int32(parsed)  // OK
		_ = uint32(parsed) // OK
	}
	{
		parsed, err := strconv.ParseUint("3456", 10, 0)
		if err != nil {
			panic(err)
		}
		_ = int32(parsed)  // OK
		_ = uint32(parsed) // OK
	}
	{
		parsed, err := strconv.Atoi("3456")
		if err != nil {
			panic(err)
		}
		_ = int32(parsed)  // OK
		_ = uint32(parsed) // OK
	}
}

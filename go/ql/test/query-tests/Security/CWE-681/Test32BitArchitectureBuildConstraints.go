//go:build (386 || amd64p32 || arm || armbe || mips || mipsle || mips64p32 || mips64p32le || ppc || s390 || sparc) && gc && go1.4
// +build 386 amd64p32 arm armbe mips mipsle mips64p32 mips64p32le ppc s390 sparc
// +build gc
// +build go1.4

package main

import (
	"strconv"
)

func testIntSource32() {
	{
		parsed, err := strconv.ParseInt("3456", 10, 0)
		if err != nil {
			panic(err)
		}
		_ = int32(parsed)
		_ = uint32(parsed)
	}
	{
		parsed, err := strconv.ParseUint("3456", 10, 0)
		if err != nil {
			panic(err)
		}
		_ = int32(parsed)
		_ = uint32(parsed)
	}
	{
		parsed, err := strconv.Atoi("3456")
		if err != nil {
			panic(err)
		}
		_ = int32(parsed)
		_ = uint32(parsed)
	}
}

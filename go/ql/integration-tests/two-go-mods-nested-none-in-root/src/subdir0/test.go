package test

import (
	"test/subdir2"

	"golang.org/x/net/ipv4"
)

func test() {

	header := ipv4.Header{}
	header.Version = subdir2.Add(2, 2)

}

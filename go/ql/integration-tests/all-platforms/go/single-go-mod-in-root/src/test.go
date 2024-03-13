package test

import (
	"test/subdir"

	"golang.org/x/net/ipv4"
)

func test() {

	header := ipv4.Header{}
	header.Version = subdir.Add(2, 2)

}

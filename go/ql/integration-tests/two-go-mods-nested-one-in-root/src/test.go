package main

import (
	"main/subdir2"

	"golang.org/x/net/ipv4"
)

func main() {

	header := ipv4.Header{}
	header.Version = subdir2.Add(2, 2)

}

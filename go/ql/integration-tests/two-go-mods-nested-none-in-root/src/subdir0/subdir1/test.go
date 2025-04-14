package subdir1

import (
	"subdir1/subsubdir1"

	"golang.org/x/net/ipv4"
)

func test() {

	header := ipv4.Header{}
	header.Version = subsubdir1.Add(2, 2)

}

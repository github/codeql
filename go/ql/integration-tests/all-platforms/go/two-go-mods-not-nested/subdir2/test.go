package subdir

import (
	"subdir2/subsubdir2"

	"golang.org/x/net/ipv4"
)

func test() {

	header := ipv4.Header{}
	header.Version = subsubdir2.Add(2, 2)

}

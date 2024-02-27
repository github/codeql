package subdir

import (
	"subdir/subsubdir"

	"golang.org/x/net/ipv4"
)

func test() {

	header := ipv4.Header{}
	header.Version = subsubdir.Add(2, 2)

}

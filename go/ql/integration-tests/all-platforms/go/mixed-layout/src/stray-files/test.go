package subdir

import (
	"fmt"

	"golang.org/x/net/ipv4"
)

func test() {

	header := ipv4.Header{}
	fmt.Print(header.String())
}

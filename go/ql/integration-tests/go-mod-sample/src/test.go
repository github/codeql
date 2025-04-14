package makesample

import (
	"golang.org/x/net/ipv4"
)

func test() {

	header := ipv4.Header{}
	header.Version = 4

}

func PublicFunction() int {
	return 1
}

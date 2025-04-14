package glidetest

import (
	"golang.org/x/time/rate"
)

func test() {

	x := rate.Limit(1)
	_ = x

}

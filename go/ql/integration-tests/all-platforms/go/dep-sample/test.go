package deptest

import (
	"golang.org/x/time/rate"
)

func test() {

	r := rate.Limit(1)
	_ = r

}

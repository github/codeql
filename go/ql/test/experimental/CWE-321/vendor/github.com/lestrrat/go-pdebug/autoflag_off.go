// +build debug

package pdebug

import (
	"os"
	"strconv"
)

var Trace = false
func init() {
	if b, err := strconv.ParseBool(os.Getenv("PDEBUG_TRACE")); err == nil && b {
		Trace = true
	}
}
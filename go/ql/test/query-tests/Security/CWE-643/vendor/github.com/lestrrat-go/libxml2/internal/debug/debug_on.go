//+build debug

package debug

import (
	"log"
	"os"
)

const Enabled = true

var logger = log.New(os.Stdout, "|DEBUG| ", 0)

// Printf prints debug messages. Only available if compiled with "debug" tag
func Printf(f string, args ...interface{}) {
	logger.Printf(f, args...)
}

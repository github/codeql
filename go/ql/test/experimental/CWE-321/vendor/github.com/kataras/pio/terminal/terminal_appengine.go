//go:build appengine
// +build appengine

package terminal

import "io"

// IsTerminal returns true if stderr's file descriptor is a terminal.
func IsTerminal(f io.Writer) bool {
	return true
}

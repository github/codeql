//go:build !debug
// +build !debug

package debug

const Enabled = false

// Printf is no op unless you compile with the `debug` tag
func Printf(_ string, _ ...interface{}) {}

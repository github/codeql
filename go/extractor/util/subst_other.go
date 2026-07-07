//go:build !windows

package util

// ResolvePath is a no-op on non-Windows platforms.
func ResolvePath(path string) string { return path }

//go:build !windows

package canonicalize

func CanonicalizePath(path string) string { return path }

//go:build safe
// +build safe

package jwt

// BytesToString converts a slice of bytes to string by wrapping.
func BytesToString(b []byte) string {
	return string(b)
}

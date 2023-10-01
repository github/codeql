package jwt

import "unsafe"

// BytesToString converts a slice of bytes to string without memory allocation.
func BytesToString(b []byte) string {
	return *(*string)(unsafe.Pointer(&b))
}

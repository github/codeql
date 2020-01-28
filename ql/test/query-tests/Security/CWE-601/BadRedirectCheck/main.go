package main

import "strings"

func isValidRedir(redirect string) bool {
	switch {
	// Not OK: does not check for '/\'
	case strings.HasPrefix(redirect, "/") && !strings.HasPrefix(redirect, "//"):
		return true
	default:
		return false
	}
}

func isValidRedir1(redirect string) bool {
	switch {
	// OK
	case strings.HasPrefix(redirect, "/") && !strings.HasPrefix(redirect, "//") && !strings.HasPrefix(redirect, "/\\"):
		return true
	default:
		return false
	}
}

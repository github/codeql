package main

import "regexp"

func broken(hostNames []byte) string {
	var htmlRe = regexp.MustCompile("\bforbidden.host.org")
	if htmlRe.Match(hostNames) {
		return "Must not target forbidden.host.org"
	} else {
		// This will be reached even if hostNames is exactly "forbidden.host.org",
		// because the literal backspace is not matched
	}
}

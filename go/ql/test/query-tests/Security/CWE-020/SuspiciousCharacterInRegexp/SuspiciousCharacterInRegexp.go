package main

import "regexp"

func broken(hostNames []byte) string {
	var hostRe = regexp.MustCompile("\bforbidden.host.org")
	if hostRe.Match(hostNames) {
		return "Must not target forbidden.host.org"
	} else {
		// This will be reached even if hostNames is exactly "forbidden.host.org",
		// because the literal backspace is not matched
		return ""
	}
}

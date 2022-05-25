package main

import "regexp"

func fixed(hostNames []byte) string {
	var hostRe = regexp.MustCompile(`\bforbidden.host.org`)
	if hostRe.Match(hostNames) {
		return "Must not target forbidden.host.org"
	} else {
		// hostNames definitely doesn't contain a word "forbidden.host.org", as "\\b"
		// is the start-of-word anchor, not a literal backspace.
		return ""
	}
}

package main

import "regexp"

func fixed(hostNames []byte) string {
	var htmlRe = regexp.MustCompile("\\bforbidden.host.org")
	if htmlRe.Match(hostNames) {
		return "Must not target forbidden.host.org"
	} else {
		// hostNames definitely doesn't contain a word "forbidden.host.org", as "\\b"
		// is the start-of-word anchor, not a literal backspace.
	}
}

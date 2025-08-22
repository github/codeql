package main

import (
	"regexp"
)

func checkSubdomain(domain String) {
	// Checking strictly that the domain is `example.com`.
	re := "^example\\.com$"
	if matched, _ := regexp.MatchString(re, domain); matched {
		// domain is good.
	}

	// GOOD: Alternatively, check the domain is `example.com` or a subdomain of `example.com`.
	re2 := "(^|\\.)example\\.com$"

	if matched, _ := regexp.MatchString(re2, domain); matched {
		// domain is good.
	}
}

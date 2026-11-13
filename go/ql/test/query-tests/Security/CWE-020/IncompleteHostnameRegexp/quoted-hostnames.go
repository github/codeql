package main

import "regexp"

func quotedHostnames() {
	// The hostname in the original issue is literal text.
	regexp.MustCompile(`^// TODO (\Qhttps://github.com/FerretDB/\E([-\w]+)/issues/(\d+))$`)

	// An ordinary wildcard dot remains unsafe.
	regexp.MustCompile(`^https://github.com/$`) // $ Alert

	// An explicitly escaped dot is literal.
	regexp.MustCompile(`^https://github\.com/$`)

	// A dot after the quoted region remains a wildcard.
	regexp.MustCompile(`^https://\Qgithub\E.com/$`) // $ Alert

	// A quoted hostname must not hide a later unsafe alternative.
	regexp.MustCompile(`^(?:\Qhttps://github.com/\E|https://example.org/)$`) // $ Alert

	// Both alternatives are literal, in separate quoted regions.
	regexp.MustCompile(`^(?:\Qhttps://github.com/\E|\Qhttps://example.org/\E)$`)

	// An unterminated quoted region extends to the end of the pattern.
	regexp.MustCompile(`^\Qhttps://github.com/`)

	// Two backslashes escape the opener, leaving the dot as a wildcard.
	regexp.MustCompile(`^\\Qhttps://github.com/$`) // $ Alert

	// Three backslashes leave a real opener after a literal backslash.
	regexp.MustCompile(`^\\\Qhttps://github.com/\E$`)

	// Another opener is literal text; the first closing marker still ends quoting.
	regexp.MustCompile(`^(?:\Qhttps://github\Q.com/\E|https://example.org/)$`) // $ Alert

	// The first literal closing marker ends quoting even after another backslash.
	regexp.MustCompile(`^\Qhttps://github\\E.com/$`) // $ Alert

	// A lowercase closing marker is literal and leaves the region open.
	regexp.MustCompile(`^\Qhttps://github.com/\ehttps://example.org/`)

	// Interpreted Go strings decode to the same quoted pattern.
	regexp.MustCompile("^\\Qhttps://github.com/\\E$")

	// Decoding an interpreted string does not quote the following wildcard.
	regexp.MustCompile("^https://\\Qgithub\\E.com/$") // $ Alert

	// Adjacent quoted sections remain literal.
	regexp.MustCompile(`^\Qhttps://github.com/\E\Qexample.org/\E$`)
}

const quotedHostname = `^\Qhttps://github.com/\E$`
const wildcardAfterQuote = `^https://\Qgithub\E.com/$` // $ Alert

func constantQuotePatterns() {
	// Constant aliases supply complete patterns to compilation and matching APIs.
	regexp.MustCompile(quotedHostname)
	regexp.Compile(quotedHostname)
	regexp.MatchString(quotedHostname, "https://github.com/")

	regexp.MustCompile(wildcardAfterQuote)                        // $ Sink
	regexp.Compile(wildcardAfterQuote)                            // $ Sink
	regexp.MatchString(wildcardAfterQuote, "https://github.com/") // $ Sink
}

func concatenatedQuoteOpeners() {
	// The prefix escapes the suffix's opener, leaving its hostname dot unsafe.
	prefix := `^(?:\`
	suffix := `\Q)?https://github.com/$` // $ Alert
	regexp.MustCompile(prefix + suffix)  // $ Sink

	// The same context matters when the suffix is inline.
	regexp.MustCompile(prefix + `\Q)?https://github.com/$`) // $ Alert

	// A constant concatenation supplies the complete pattern.
	regexp.MustCompile(`^(?:\` + `\Q)?https://github.com/$`) // $ Alert
}

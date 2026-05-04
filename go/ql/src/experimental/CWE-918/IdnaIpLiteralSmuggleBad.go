package main

import (
	"net"
	"net/http"
	"net/url"

	"golang.org/x/net/idna"
)

// VulnerableLookup mirrors the shape of the anti-pattern as it appears in
// real Go code: an attacker-controlled host string is canonicalised through
// idna.Lookup.ToASCII, the result is consumed by a network sink, and there
// is no post-IDNA recheck against IP-literal parsers. UTS-46 NFKC mapping
// folds 100 non-ASCII digit codepoints (e.g. fullwidth, mathematical
// superscripts, circled, segmented) to their ASCII equivalents, so an input
// like "0.¹.0.0" emerges from ToASCII as "0.1.0.0" and reaches the sink
// as a routable IPv4 literal.
func VulnerableLookup(host string) (*http.Response, error) {
	ace, err := idna.Lookup.ToASCII(host)
	if err != nil {
		return nil, err
	}
	return http.Get("https://" + ace + "/")
}

// VulnerableProxyRoute mirrors the canonicalAddr shape used in callers that
// canonicalise a URL host before applying network policy. The host is read
// from an attacker-controlled URL, mapped through an idna.Lookup.ToASCII
// wrapper, and passed to net.JoinHostPort without an IP-literal recheck.
func VulnerableProxyRoute(rawURL string) (string, error) {
	u, err := url.Parse(rawURL)
	if err != nil {
		return "", err
	}
	addr := u.Hostname()
	if v, err := idna.Lookup.ToASCII(addr); err == nil {
		addr = v
	}
	return net.JoinHostPort(addr, "443"), nil
}

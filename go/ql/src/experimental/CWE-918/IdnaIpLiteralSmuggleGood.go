package main

import (
	"net"
	"net/http"
	"strings"

	"golang.org/x/net/idna"
)

// SafeLookup applies the safe pattern: a post-IDNA trailing-dot trim
// followed by net.ParseIP. The trim is required because "0.¹.0.0." maps
// to "0.1.0.0." which net.ParseIP rejects on its own yet is still
// routable as 0.1.0.0 in the rest of the stack.
func SafeLookup(host string) (*http.Response, error) {
	ace, err := idna.Lookup.ToASCII(host)
	if err != nil {
		return nil, err
	}

	// Post-IDNA trailing-dot trim, then re-check. TrimRight (not
	// TrimSuffix) handles multiple trailing dots that UTS-46 mapping can
	// produce when fullwidth/ideographic dots compose with ASCII dots.
	candidate := strings.TrimRight(ace, ".")
	if ip := net.ParseIP(candidate); ip != nil {
		return nil, errBadHost
	}

	return http.Get("https://" + ace + "/")
}

var errBadHost = errIPLiteral{}

type errIPLiteral struct{}

func (errIPLiteral) Error() string { return "ip literals not allowed" }

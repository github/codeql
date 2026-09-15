// Negative test cases: compliant callers that must NOT trigger the alert.
// No `// $ Alert` annotations on the sink lines.

package main

import (
	"context"
	"net"
	"net/http"
	"net/netip"
	"net/url"
	"strings"

	"golang.org/x/net/idna"
)

// Compliant: post-IDNA TrimSuffix(".") followed by net.ParseIP recheck.
// This is the safe pattern.
func compliantTrimAndRecheck(req *http.Request) {
	host := req.Header.Get("X-HOST-OK-1")
	ace, err := idna.Lookup.ToASCII(host)
	if err != nil {
		return
	}
	candidate := strings.TrimSuffix(ace, ".")
	if ip := net.ParseIP(candidate); ip != nil {
		return
	}
	http.Get("https://" + ace + "/") // OK: post-IDNA recheck barrier
}

// Compliant variant: TrimRight(".") variant of the trim.
func compliantTrimRight(req *http.Request) {
	host := req.Header.Get("X-HOST-OK-2")
	ace, _ := idna.Lookup.ToASCII(host)
	candidate := strings.TrimRight(ace, ".")
	if ip := net.ParseIP(candidate); ip != nil {
		return
	}
	net.JoinHostPort(ace, "443") // OK
}

// True-negative: caller uses idna.Punycode, which does NOT apply the
// UTS-46 NFKC mapping. Even without a recheck, no digit-fold occurs.
func purePunycode(req *http.Request) {
	host := req.Header.Get("X-HOST-PUNYCODE")
	ace, _ := idna.Punycode.ToASCII(host)
	http.Get("https://" + ace + "/") // OK: no digit-fold profile
}

// True-negative: package-level idna.ToASCII is intentionally excluded
// from the model (it dispatches to Punycode.process and so cannot
// produce the digit-fold smuggle). Pinning the documented exclusion
// against future broadening of the call matcher.
func packageLevelToASCII(req *http.Request) {
	host := req.Header.Get("X-HOST-PKG-TOASCII")
	ace, _ := idna.ToASCII(host)
	http.Get("https://" + ace + "/") // OK: package-level helper excluded
}

// True-negative: caller uses idna.Display for human rendering only; the
// output never reaches a network sink in this function.
func displayOnly(req *http.Request) {
	host := req.Header.Get("X-HOST-DISPLAY")
	disp, _ := idna.Display.ToUnicode(host)
	_ = disp // OK: never reaches a sink
}

// True-negative: pure URL-parser pipeline. net/url.Parse is not the
// IDNA mapper; URL.Host is consumed without idna.ToASCII having run.
func urlParseOnly(req *http.Request) {
	raw := req.Header.Get("X-URL-RAW")
	u, err := url.Parse(raw)
	if err != nil {
		return
	}
	http.Get(u.String()) // OK: no IDNA mapping in the path
}

// True-negative: idna.ToASCII output is immediately discarded; nothing
// reaches a sink.
func idnaDiscard(req *http.Request) {
	host := req.Header.Get("X-HOST-DISCARD")
	_, _ = idna.Lookup.ToASCII(host) // OK: result discarded
}

// Compliant: post-IDNA TrimSuffix + net.ParseIP recheck before net.LookupHost.
func compliantLookupHost(req *http.Request) {
	host := req.Header.Get("X-HOST-LOOKUP-OK")
	ace, err := idna.Lookup.ToASCII(host)
	if err != nil {
		return
	}
	candidate := strings.TrimSuffix(ace, ".")
	if ip := net.ParseIP(candidate); ip != nil {
		return
	}
	net.LookupHost(ace) // OK: post-IDNA recheck barrier
}

// Compliant: post-IDNA TrimRight + net.ParseIP recheck before (*Resolver).LookupHost.
func compliantResolverLookupHost(req *http.Request) {
	host := req.Header.Get("X-HOST-RESOLVER-OK")
	ace, err := idna.Lookup.ToASCII(host)
	if err != nil {
		return
	}
	candidate := strings.TrimRight(ace, ".")
	if ip := net.ParseIP(candidate); ip != nil {
		return
	}
	r := &net.Resolver{}
	r.LookupHost(context.Background(), ace) // OK: post-IDNA recheck barrier
}

// Compliant: post-IDNA TrimSuffix + netip.ParseAddr recheck before (*Resolver).LookupIPAddr.
func compliantResolverLookupIPAddr(req *http.Request) {
	host := req.Header.Get("X-HOST-IPADDR-OK")
	ace, err := idna.Lookup.ToASCII(host)
	if err != nil {
		return
	}
	candidate := strings.TrimSuffix(ace, ".")
	if _, parseErr := netip.ParseAddr(candidate); parseErr == nil {
		return
	}
	r := &net.Resolver{}
	r.LookupIPAddr(context.Background(), ace) // OK: post-IDNA recheck barrier
}

// Compliant: post-IDNA TrimRight + netip.ParseAddr recheck. The canonical
// strict pattern combining the multi-trailing-dot trim with the modern
// netip parser. This must NOT alert.
func compliantTrimRightNetipParseAddr(req *http.Request) {
	host := req.Header.Get("X-HOST-TRIMRIGHT-NETIP-OK")
	ace, err := idna.Lookup.ToASCII(host)
	if err != nil {
		return
	}
	candidate := strings.TrimRight(ace, ".")
	if _, parseErr := netip.ParseAddr(candidate); parseErr == nil {
		return
	}
	http.Get("https://" + ace + "/") // OK: post-IDNA recheck barrier
}

// Compliant: post-IDNA TrimSuffix + netip.ParseAddr. The lenient
// single-trailing-dot pattern, accepted by the rule per shape (b) in the
// module docstring. This must NOT alert.
func compliantTrimSuffixNetipParseAddr(req *http.Request) {
	host := req.Header.Get("X-HOST-TRIMSUFFIX-NETIP-OK")
	ace, err := idna.Lookup.ToASCII(host)
	if err != nil {
		return
	}
	candidate := strings.TrimSuffix(ace, ".")
	if _, parseErr := netip.ParseAddr(candidate); parseErr == nil {
		return
	}
	net.JoinHostPort(ace, "443") // OK: post-IDNA recheck barrier
}

// Compliant: manual slice form of the trim per shape (c) in the module
// docstring: `if strings.HasSuffix(out, ".") { out = out[:len(out)-1] }`
// followed by net.ParseIP. This must NOT alert.
func compliantManualSliceParseIP(req *http.Request) {
	host := req.Header.Get("X-HOST-MANUAL-SLICE-OK")
	ace, err := idna.Lookup.ToASCII(host)
	if err != nil {
		return
	}
	out := ace
	if strings.HasSuffix(out, ".") {
		out = out[:len(out)-1]
	}
	if ip := net.ParseIP(out); ip != nil {
		return
	}
	net.JoinHostPort(ace, "443") // OK: post-IDNA recheck barrier
}

// Compliant: post-IDNA TrimRight + net.ParseCIDR recheck. Pins the
// ParseCIDR branch of ipLiteralRecheckInput against regressions that
// would only break for callers using the CIDR parser.
func compliantTrimRightParseCIDR(req *http.Request) {
	host := req.Header.Get("X-HOST-PARSECIDR-OK")
	ace, err := idna.Lookup.ToASCII(host)
	if err != nil {
		return
	}
	candidate := strings.TrimRight(ace, ".")
	if _, _, parseErr := net.ParseCIDR(candidate); parseErr == nil {
		return
	}
	http.Get("https://" + ace + "/") // OK: post-IDNA recheck barrier
}

// Compliant: post-IDNA TrimSuffix + netip.ParsePrefix recheck. Pins the
// ParsePrefix branch of ipLiteralRecheckInput.
func compliantTrimSuffixNetipParsePrefix(req *http.Request) {
	host := req.Header.Get("X-HOST-PARSEPREFIX-OK")
	ace, err := idna.Lookup.ToASCII(host)
	if err != nil {
		return
	}
	candidate := strings.TrimSuffix(ace, ".")
	if _, parseErr := netip.ParsePrefix(candidate); parseErr == nil {
		return
	}
	net.JoinHostPort(ace, "443") // OK: post-IDNA recheck barrier
}

// AdversarialWitnessBinding mixes an unrelated TrimRight + ParseIP
// construct in the same scope as an IDNA-tainted path. The pre-fix
// predicate would silently sanitize the IDNA path because some-trim
// flowed-to-some-ParseIP existed in scope. The post-fix predicate ties
// the trim source to the post-IDNA tainted predecessor and correctly
// fires the alert.
//
// Expected: this function SHOULD trigger an alert on the JoinHostPort
// line. The negatives-fixture name is misleading; this is technically a
// positive test for the witness-binding fix. Placed here for proximity
// to the bug shape it regresses against.
//
// This is the canonical regression test for the v0.1.0 witness-binding
// fix: pre-fix predicate would NOT alert; post-fix predicate WILL alert.
func AdversarialWitnessBinding(req *http.Request, otherInput string) string {
	host := req.Header.Get("X-HOST-ADVERSARIAL") // $ Source

	// Unrelated trim + ParseIP elsewhere in the same scope. The pre-fix
	// predicate matched any-trim-to-any-ParseIP and treated this as a
	// sanitizer on the IDNA path below. It is not.
	unrelated := strings.TrimRight(otherInput, ".")
	if ip := net.ParseIP(unrelated); ip != nil {
		return "rejected unrelated"
	}

	// IDNA-tainted path with no post-IDNA recheck. Must alert.
	ace, err := idna.Lookup.ToASCII(host)
	if err != nil {
		return ""
	}
	return net.JoinHostPort(ace, "443") // $ Alert
}

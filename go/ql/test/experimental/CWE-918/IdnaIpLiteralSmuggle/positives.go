// Positive test cases for the IDNA digit-fold IP-literal smuggle query.
// Each `// $ Source` and `// $ Alert` annotation is consumed by the
// CodeQL InlineExpectationsTestQuery harness.
//
// Sources are *http.Request fields (Header, URL.Hostname, FormValue,
// URL.Query().Get) so the default RemoteFlowSource threat model in
// codeql test run picks them up without extra configuration.

package main

import (
	"context"
	"crypto/tls"
	"net"
	"net/http"
	"net/url"
	"time"

	"golang.org/x/net/idna"
)

// --- Class 1: Latin-1 superscripts (U+00B9 SUPERSCRIPT ONE) ---
// "0.¹.0.0" -> "0.1.0.0"
func smuggleLatin1Superscript(req *http.Request) {
	host := req.Header.Get("X-HOST-LATIN1") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	http.Get("https://" + ace + "/") // $ Alert
}

// --- Class 1 second positive: Latin-1 superscript U+00B2 -> "2", net.DialTimeout sink ---
// "0.0.².0" -> "0.0.2.0"
func smuggleLatin1SuperscriptDialTimeout(req *http.Request) {
	host := req.Header.Get("X-HOST-LATIN1-TWO") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	addr := ace + ":443"
	net.DialTimeout("tcp", addr, 5*time.Second) // $ Alert
}

// --- Class 2: Mathematical superscripts (U+2074 SUPERSCRIPT FOUR) ---
// "10.⁴.0.1" -> "10.4.0.1"
func smuggleMathSuperscript(req *http.Request) {
	host := req.Header.Get("X-HOST-MATHSUP") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	net.JoinHostPort(ace, "443") // $ Alert
}

// --- Class 2 second positive: Math superscript U+2079 -> "9", url.URL.Host sink ---
// Uses idna.Display.ToASCII to exercise an alternate UTS-46 mapping profile.
// "10.0.⁹.1" -> "10.0.9.1"
func smuggleMathSuperscriptURLHost(req *http.Request) {
	host := req.Header.Get("X-Forward-Host") // $ Source
	ace, _ := idna.Display.ToASCII(host)
	u := &url.URL{Scheme: "https"}
	u.Host = ace // $ Alert
	_ = u
}

// --- Class 3: Mathematical subscripts (U+2081 SUBSCRIPT ONE) ---
// "127.0.0.₁" -> "127.0.0.1"
func smuggleMathSubscript(req *http.Request) {
	host := req.Header.Get("X-HOST-SUBSCRIPT") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	cfg := &tls.Config{}
	cfg.ServerName = ace // $ Alert
	_ = cfg
}

// --- Class 3 second positive: Math subscript U+2087 -> "7", net.LookupHost sink ---
// "10.₇.0.1" -> "10.7.0.1"
func smuggleMathSubscriptLookupHost(req *http.Request) {
	host := req.Header.Get("X-HOST-SUBSCRIPT-TWO") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	net.LookupHost(ace) // $ Alert
}

// --- Class 4: Circled digits (U+2460 CIRCLED DIGIT ONE) ---
// "192.168.①.1" -> "192.168.1.1"
func smuggleCircledDigit(req *http.Request) {
	host := req.Header.Get("X-HOST-CIRCLED") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	net.Dial("tcp", net.JoinHostPort(ace, "80")) // $ Alert
}

// --- Class 4 second positive: Circled digit U+2463 -> "4", (*net.Dialer).DialContext sink ---
// Uses idna.Registration.ToASCII to exercise the registration profile.
// "10.0.0.④" -> "10.0.0.4"
func smuggleCircledDigitDialerContext(req *http.Request) {
	host := req.Header.Get("X-HOST-CIRCLED-TWO") // $ Source
	ace, _ := idna.Registration.ToASCII(host)
	addr := ace + ":443"
	d := &net.Dialer{}
	d.DialContext(context.Background(), "tcp", addr) // $ Alert
}

// --- Class 5: Fullwidth digits (U+FF11 FULLWIDTH DIGIT ONE) ---
// "１９２.１６８.１.１" -> "192.168.1.1"
func smuggleFullwidth(req *http.Request) {
	host := req.Header.Get("X-HOST-FULLWIDTH") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	c := &http.Cookie{}
	c.Domain = ace // $ Alert
	_ = c
}

// --- Class 5 second positive: Fullwidth U+FF10 -> "0", net.LookupIP sink ---
// Uses an idna.New(idna.MapForLookup(), ...) constructed profile.
// "０.0.0.1" -> "0.0.0.1"
func smuggleFullwidthLookupIP(req *http.Request) {
	host := req.Header.Get("X-HOST-FULLWIDTH-TWO") // $ Source
	profile := idna.New(idna.MapForLookup())
	ace, _ := profile.ToASCII(host)
	net.LookupIP(ace) // $ Alert
}

// --- Class 6: Mathematical bold/sans/double-struck/mono (U+1D7CE MATH BOLD ZERO) ---
// "\U0001D7CE.\U0001D7CF.\U0001D7CE.\U0001D7CF" -> "0.1.0.1"
func smuggleMathBold(req *http.Request) {
	host := req.Header.Get("X-HOST-MATHBOLD") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	u := &url.URL{Scheme: "https"}
	u.Host = ace // $ Alert
	_ = u
}

// --- Class 6 second positive: Math sans-serif digit U+1D7E2 -> "0",
// (*net.Resolver).LookupHost sink ---
// "\U0001D7E2.\U0001D7E3.\U0001D7E2.\U0001D7E3" -> "0.1.0.1"
func smuggleMathSansResolverLookupHost(req *http.Request) {
	host := req.Header.Get("X-HOST-MATHSANS") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	r := &net.Resolver{}
	r.LookupHost(context.Background(), ace) // $ Alert
}

// --- Class 7: Segmented digits (U+1FBF1 SEGMENTED DIGIT ONE) ---
// "\U0001FBF1.0.0.0" -> "1.0.0.0"
func smuggleSegmented(req *http.Request) {
	host := req.Header.Get("X-HOST-SEGMENTED") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	http.Get("https://" + ace + "/") // $ Alert
}

// --- Class 7 second positive: Segmented digit U+1FBF7 -> "7",
// (*net.Dialer).Dial sink ---
// "\U0001FBF7.0.0.1" -> "7.0.0.1"
func smuggleSegmentedDialerDial(req *http.Request) {
	host := req.Header.Get("X-HOST-SEGMENTED-TWO") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	addr := ace + ":80"
	d := &net.Dialer{}
	d.Dial("tcp", addr) // $ Alert
}

// --- Class 4 third positive: U+24EA CIRCLED DIGIT ZERO (zero-only
// codepoint in the circled family; U+2460 starts at one). ---
// "⓪.0.0.1" -> "0.0.0.1"
func smuggleCircledZero(req *http.Request) {
	host := req.Header.Get("X-HOST-CIRCLED-ZERO") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	http.Get("https://" + ace + "/") // $ Alert
}

// --- Class 8: Devanagari digits (U+0966..U+096F) ---
// UTS-46 NFKC folds Devanagari digits to ASCII equivalents.
// "१.0.0.0" (U+0967 DEVANAGARI ONE) -> "1.0.0.0"
func smuggleDevanagariDigit(req *http.Request) {
	host := req.Header.Get("X-HOST-DEVANAGARI") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	http.Get("https://" + ace + "/") // $ Alert
}

// --- Class 8 second positive: Devanagari digit U+0969 -> "3",
// (*net.Resolver).LookupIPAddr sink ---
// "१.0.0.३" -> "1.0.0.3"
func smuggleDevanagariResolverLookupIPAddr(req *http.Request) {
	host := req.Header.Get("X-HOST-DEVANAGARI-TWO") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	r := &net.Resolver{}
	r.LookupIPAddr(context.Background(), ace) // $ Alert
}

// --- Trailing-dot variant: "0.¹.0.0." -> "0.1.0.0." ---
// A bare `net.ParseIP("0.1.0.0.")` returns nil, so a post-IDNA recheck
// WITHOUT a trailing-dot trim does NOT sanitize. The query must still
// alert here.
func smuggleTrailingDot(req *http.Request) {
	host := req.Header.Get("X-HOST-TRAILING-DOT") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	if ip := net.ParseIP(ace); ip != nil { // wrong: no TrimSuffix
		return
	}
	http.Get("https://" + ace + "/") // $ Alert
}

// --- DNS resolver sinks ---

// net.LookupHost: smuggled IP literal triggers DNS query for the literal form.
// "0.¹.0.0" -> "0.1.0.0"; LookupHost("0.1.0.0") issues a PTR-style query that
// some resolvers answer with the IP directly.
func smuggleLookupHost(req *http.Request) {
	host := req.Header.Get("X-HOST-LOOKUP") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	net.LookupHost(ace) // $ Alert
}

// net.LookupIP: same digit-fold as above; argument 0 is the host.
func smuggleLookupIP(req *http.Request) {
	host := req.Header.Get("X-HOST-LOOKUP-IP") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	net.LookupIP(ace) // $ Alert
}

// (*net.Resolver).LookupHost: custom resolver; host is argument 1, ctx is argument 0.
func smuggleResolverLookupHost(req *http.Request) {
	host := req.Header.Get("X-HOST-RESOLVER-LOOKUP") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	r := &net.Resolver{}
	r.LookupHost(context.Background(), ace) // $ Alert
}

// (*net.Resolver).LookupIPAddr: custom resolver; host is argument 1.
func smuggleResolverLookupIPAddr(req *http.Request) {
	host := req.Header.Get("X-HOST-RESOLVER-IPADDR") // $ Source
	ace, _ := idna.Lookup.ToASCII(host)
	r := &net.Resolver{}
	r.LookupIPAddr(context.Background(), ace) // $ Alert
}

// --- Caller-pattern reproduction: pre-IDNA ParseIP guard, no post-IDNA
// recheck. Mirrors `golang.org/x/net/http/httpproxy/proxy.go::canonicalAddr`. ---
func smuggleCanonicalAddrShape(req *http.Request) {
	addr := req.Header.Get("X-HOST-CANONICAL") // $ Source
	if ip := net.ParseIP(addr); ip != nil {
		// pretend we reject IP-literal inputs early
		return
	}
	if v, err := idna.Lookup.ToASCII(addr); err == nil {
		addr = v
	}
	net.JoinHostPort(addr, "443") // $ Alert
}

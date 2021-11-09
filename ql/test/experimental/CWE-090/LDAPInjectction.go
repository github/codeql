package main

import (
	"net/http"

	goldap "github.com/go-ldap/ldap"
	goldapv3 "github.com/go-ldap/ldap/v3"
	ldapclient "github.com/jtblin/go-ldap-client"
	gopkgldapv2 "gopkg.in/ldap.v2"
)

func main() {}

// bad is an example of a bad implementation
func bad(req *http.Request) {
	// ...
	untrusted := req.UserAgent()
	goldap.NewSearchRequest(
		"dc=example,dc=com", // The base dn to search
		goldap.ScopeWholeSubtree, goldap.NeverDerefAliases, 0, 0, false,
		"(&(objectClass=organizationalPerson))"+untrusted, // BAD: untrusted filter
		[]string{"dn", "cn", untrusted},                   // BAD: untrusted attribute
		nil,
	)
	goldapv3.NewSearchRequest(
		"dc=example,dc=com", // The base dn to search
		goldap.ScopeWholeSubtree, goldap.NeverDerefAliases, 0, 0, false,
		"(&(objectClass=organizationalPerson))"+untrusted, // BAD: untrusted filter
		[]string{"dn", "cn", untrusted},                   // BAD: untrusted attribute
		nil,
	)
	gopkgldapv2.NewSearchRequest(
		"dc=example,dc=com", // The base dn to search
		goldap.ScopeWholeSubtree, goldap.NeverDerefAliases, 0, 0, false,
		"(&(objectClass=organizationalPerson))"+untrusted, // BAD: untrusted filter
		[]string{"dn", "cn", untrusted},                   // BAD: untrusted attribute
		nil,
	)
	ldapclient.Authenticate(untrusted, "123456") // BAD: untrusted filter
	ldapclient.GetGroupsOfUser(untrusted)        // BAD: untrusted filter
	// ...
}

// good is an example of a good implementation
func good(req *http.Request) {
	// ...
	untrusted := req.UserAgent()
	escapegoldap := goldap.EscapedFilter(untrusted)
	goldap.NewSearchRequest(
		"dc=example,dc=com", // The base dn to search
		goldap.ScopeWholeSubtree, goldap.NeverDerefAliases, 0, 0, false,
		"(&(objectClass=organizationalPerson))"+escapegoldap, // GOOD: sanitized filter
		[]string{"dn", "cn", escapegoldap},                   // GOOD: sanitized attribute
		nil,
	)
	escapegoldapv3 := goldapv3.EscapedFilter(untrusted)
	goldapv3.NewSearchRequest(
		"dc=example,dc=com", // The base dn to search
		goldap.ScopeWholeSubtree, goldap.NeverDerefAliases, 0, 0, false,
		"(&(objectClass=organizationalPerson))"+escapegoldapv3, // GOOD: sanitized filter
		[]string{"dn", "cn", escapegoldapv3},                   // GOOD: sanitized attribute
		nil,
	)
	escapegopkgv2 := gopkgldapv2.EscapedFilter(untrusted)
	gopkgldapv2.NewSearchRequest(
		"dc=example,dc=com", // The base dn to search
		goldap.ScopeWholeSubtree, goldap.NeverDerefAliases, 0, 0, false,
		"(&(objectClass=organizationalPerson))"+escapegopkgv2, // GOOD: sanitized filter
		[]string{"dn", "cn", escapegopkgv2},                   // GOOD: sanitized attribute
		nil,
	)
	ldapclient.Authenticate(escapegoldapv3, "123456") // GOOD: sanitized filter
	ldapclient.GetGroupsOfUser(escapegoldapv3)        // GOOD: sanitized filter
	// ...
}

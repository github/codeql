package main

//go:generate depstubber -vendor github.com/go-ldap/ldap "" ScopeWholeSubtree,NeverDerefAliases,NewSearchRequest,EscapeFilter
//go:generate depstubber -vendor github.com/go-ldap/ldap/v3 "" ScopeWholeSubtree,NeverDerefAliases,NewSearchRequest,EscapeFilter
//go:generate depstubber -vendor github.com/jtblin/go-ldap-client LDAPClient
//go:generate depstubber -vendor gopkg.in/ldap.v2 "" ScopeWholeSubtree,NeverDerefAliases,NewSearchRequest,EscapeFilter

import (
	"net/http"
	"strings"

	goldap "github.com/go-ldap/ldap"
	goldapv3 "github.com/go-ldap/ldap/v3"
	ldapclient "github.com/jtblin/go-ldap-client"
	gopkgldapv2 "gopkg.in/ldap.v2"
)

type Ldap struct{}

func (*Ldap) sanitizedUserQuery(username string) (string, bool) {
	badCharacters := "\x00()*\\"
	if strings.ContainsAny(username, badCharacters) {
		return "", false
	}
	return username, true
}

func (*Ldap) sanitizedUserDN(username string) (string, bool) {
	badCharacters := "\x00()*\\"
	if strings.ContainsAny(username, badCharacters) {
		return "", false
	}
	return username, true
}

func (*Ldap) sanitizedGroupFilter(username string) (string, bool) {
	badCharacters := "\x00()*\\"
	if strings.ContainsAny(username, badCharacters) {
		return "", false
	}
	return username, true
}

func (*Ldap) sanitizedGroupDN(username string) (string, bool) {
	badCharacters := "\x00()*\\"
	if strings.ContainsAny(username, badCharacters) {
		return "", false
	}
	return username, true
}

func main() {}

// bad is an example of a bad implementation
func (ld *Ldap) bad(req *http.Request) {
	// ...
	untrusted := req.UserAgent()
	goldap.NewSearchRequest(
		untrusted, // BAD: untrusted dn
		goldap.ScopeWholeSubtree, goldap.NeverDerefAliases, 0, 0, false,
		"(&(objectClass=organizationalPerson))"+untrusted, // BAD: untrusted filter
		[]string{"dn", "cn", untrusted},                   // BAD: untrusted attribute
		nil,
	)
	goldapv3.NewSearchRequest(
		untrusted, // BAD: untrusted dn
		goldap.ScopeWholeSubtree, goldap.NeverDerefAliases, 0, 0, false,
		"(&(objectClass=organizationalPerson))"+untrusted, // BAD: untrusted filter
		[]string{"dn", "cn", untrusted},                   // BAD: untrusted attribute
		nil,
	)
	gopkgldapv2.NewSearchRequest(
		untrusted, // BAD: untrusted dn
		goldap.ScopeWholeSubtree, goldap.NeverDerefAliases, 0, 0, false,
		"(&(objectClass=organizationalPerson))"+untrusted, // BAD: untrusted filter
		[]string{"dn", "cn", untrusted},                   // BAD: untrusted attribute
		nil,
	)
	client := &ldapclient.LDAPClient{}
	client.Authenticate(untrusted, "123456") // BAD: untrusted filter
	client.GetGroupsOfUser(untrusted)        // BAD: untrusted filter
	// ...
}

// good is an example of a good implementation
func (ld *Ldap) good(req *http.Request) {
	// ...
	untrusted := req.UserAgent()
	escapegoldap := goldap.EscapeFilter(untrusted)
	goldap.NewSearchRequest(
		escapegoldap, // GOOD: sanitized dn
		goldap.ScopeWholeSubtree, goldap.NeverDerefAliases, 0, 0, false,
		"(&(objectClass=organizationalPerson))"+escapegoldap, // GOOD: sanitized filter
		[]string{"dn", "cn", escapegoldap},                   // GOOD: sanitized attribute
		nil,
	)
	escapegoldapv3 := goldapv3.EscapeFilter(untrusted)
	goldapv3.NewSearchRequest(
		escapegoldapv3, // GOOD: sanitized dn
		goldap.ScopeWholeSubtree, goldap.NeverDerefAliases, 0, 0, false,
		"(&(objectClass=organizationalPerson))"+escapegoldapv3, // GOOD: sanitized filter
		[]string{"dn", "cn", escapegoldapv3},                   // GOOD: sanitized attribute
		nil,
	)
	escapegopkgv2 := gopkgldapv2.EscapeFilter(untrusted)
	gopkgldapv2.NewSearchRequest(
		escapegopkgv2, // GOOD: sanitized dn
		goldap.ScopeWholeSubtree, goldap.NeverDerefAliases, 0, 0, false,
		"(&(objectClass=organizationalPerson))"+escapegopkgv2, // GOOD: sanitized filter
		[]string{"dn", "cn", escapegopkgv2},                   // GOOD: sanitized attribute
		nil,
	)
	escapedusercustom, _ := ld.sanitizedUserQuery(untrusted)    // GOOD: custom sanitized filter
	escapedgroupcustom, _ := ld.sanitizedGroupFilter(untrusted) // GOOD: custom sanitized filter
	escapeduserdncustom, _ := ld.sanitizedUserDN(untrusted)     // GOOD: custom sanitized filter
	escapedgroupdncustom, _ := ld.sanitizedGroupDN(untrusted)   // GOOD: custom sanitized filter
	client := &ldapclient.LDAPClient{}
	client.Authenticate(escapedusercustom, "123456") // GOOD: sanitized filter
	client.GetGroupsOfUser(escapedgroupcustom)       // GOOD: sanitized filter
	gopkgldapv2.NewSearchRequest(
		escapeduserdncustom, // GOOD: sanitized dn
		goldap.ScopeWholeSubtree, goldap.NeverDerefAliases, 0, 0, false,
		"(&(objectClass=organizationalPerson))"+"(uid=1)",
		[]string{"dn", "cn"},
		nil,
	)
	gopkgldapv2.NewSearchRequest(
		escapedgroupdncustom, // GOOD: sanitized dn
		goldap.ScopeWholeSubtree, goldap.NeverDerefAliases, 0, 0, false,
		"(&(objectClass=organizationalPerson))"+"(uid=1)",
		[]string{"dn", "cn"},
		nil,
	)
	// ...
}

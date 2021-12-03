package main

func LDAPInjectionVulnerable(untrusted string) {
	// ...
	searchRequest := ldap.NewSearchRequest(
		"dc=example,dc=com", // The base dn to search
		ldap.ScopeWholeSubtree, ldap.NeverDerefAliases, 0, 0, false,
		"(&(objectClass=organizationalPerson)) + untrusted", // BAD: untrusted filter
		[]string{"dn", "cn", untrusted},                     // BAD: untrusted attribute
		nil,
	)
	// ...
}

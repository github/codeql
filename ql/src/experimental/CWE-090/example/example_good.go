package main

func LDAPInjectionVulnerable(untrusted string) {
	// ...
	safe := ldap.EscapeFilter(untrusted)

	searchRequest := ldap.NewSearchRequest(
		"dc=example,dc=com", // The base dn to search
		ldap.ScopeWholeSubtree, ldap.NeverDerefAliases, 0, 0, false,
		"(&(objectClass=organizationalPerson))"+safe, // GOOD: sanitized filter
		[]string{"dn", "cn", safe},                   // GOOD: sanitized attribute
		nil,
	)
	// ...
}

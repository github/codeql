package main

import (
	"fmt"
	"log"
)

func bad() interface{} {
	bindPassword := req.URL.Query()["password"][0]

	// Connect to the LDAP server
	l, err := ldap.Dial("tcp", fmt.Sprintf("%s:%d", "ldap.example.com", 389))
	if err != nil {
		log.Fatalf("Failed to connect to LDAP server: %v", err)
	}
	defer l.Close()

	err = l.Bind("cn=admin,dc=example,dc=com", bindPassword)
	if err != nil {
		log.Fatalf("LDAP bind failed: %v", err)
	}
}

package main

import (
	"fmt"
	"log"

	"github.com/gin-gonic/gin"
	"github.com/go-ldap/ldap"
)

// ExampleConnSearch ldap demo
func ExampleConnSearchGood1(c *gin.Context) {
	filter := c.Query("name")
	l, err := ldap.DialURL("ldap://127.0.0.1:389")
	if err != nil {
		log.Fatal(err)
	}
	defer l.Close()

	searchRequest := ldap.NewSearchRequest(
		"dc=example,dc=com", // The base dn to search
		ldap.ScopeWholeSubtree, ldap.NeverDerefAliases, 0, 0, false,
		"(&(objectClass=organizationalPerson))",         // The filter to apply
		[]string{"dn", "cn", ldap.EscapeFilter(filter)}, // A list attributes to retrieve
		nil,
	)

	sr, err := l.Search(searchRequest)
	if err != nil {
		log.Fatal(err)
	}

	for _, entry := range sr.Entries {
		fmt.Printf("%s: %v\n", entry.DN, entry.GetAttributeValue("cn"))
	}
}

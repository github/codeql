package main

import (
	"fmt"

	"golang.org/x/oauth2"
)

func main() {}

var stateStringVar = "state"

func badWithStringLiteralState() {
	conf := &oauth2.Config{
		ClientID:     "YOUR_CLIENT_ID",
		ClientSecret: "YOUR_CLIENT_SECRET",
		Scopes:       []string{"SCOPE1", "SCOPE2"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://provider.com/o/oauth2/auth",
			TokenURL: "https://provider.com/o/oauth2/token",
		},
	}

	url := conf.AuthCodeURL(stateStringVar, oauth2.AccessTypeOffline)
	fmt.Printf("Visit the URL for the auth dialog: %v", url)
	// ...
}

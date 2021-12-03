package main

import (
	"crypto/rand"
	"encoding/base64"
	"net/http"

	"golang.org/x/oauth2"
)

func betterWithVariableStateReturned(w http.ResponseWriter) {
	conf := &oauth2.Config{
		ClientID:     "YOUR_CLIENT_ID",
		ClientSecret: "YOUR_CLIENT_SECRET",
		Scopes:       []string{"SCOPE1", "SCOPE2"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://provider.com/o/oauth2/auth",
			TokenURL: "https://provider.com/o/oauth2/token",
		},
	}

	state := generateStateOauthCookie(w)
	url := conf.AuthCodeURL(state)
	_ = url
	// ...
}
func generateStateOauthCookie(w http.ResponseWriter) string {
	b := make([]byte, 128)
	rand.Read(b)
	// TODO: save the state string to cookies or HTML storage,
	// and bind it to the authenticated status of the user.
	state := base64.URLEncoding.EncodeToString(b)

	return state
}

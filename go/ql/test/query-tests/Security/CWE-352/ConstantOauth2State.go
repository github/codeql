package main

//go:generate depstubber -vendor golang.org/x/oauth2 Config,Endpoint

import (
	"bufio"
	"crypto/rand"
	"encoding/base64"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"

	"golang.org/x/oauth2"
)

func main() {}

const stateStringConst = "state"

var stateStringVar = "state"

func badWithStringLiteralState(w http.ResponseWriter) {
	conf := &oauth2.Config{
		ClientID:     "YOUR_CLIENT_ID",
		ClientSecret: "YOUR_CLIENT_SECRET",
		Scopes:       []string{"SCOPE1", "SCOPE2"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://provider.com/o/oauth2/auth",
			TokenURL: "https://provider.com/o/oauth2/token",
		},
	}

	url := conf.AuthCodeURL("state") // BAD
	_ = url
	// ...
}
func badWithConstState(w http.ResponseWriter) {
	conf := &oauth2.Config{
		ClientID:     "YOUR_CLIENT_ID",
		ClientSecret: "YOUR_CLIENT_SECRET",
		Scopes:       []string{"SCOPE1", "SCOPE2"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://provider.com/o/oauth2/auth",
			TokenURL: "https://provider.com/o/oauth2/token",
		},
	}

	url := conf.AuthCodeURL(stateStringConst) // BAD
	_ = url
	// ...
}
func badWithFixedVarState(w http.ResponseWriter) {
	conf := &oauth2.Config{
		ClientID:     "YOUR_CLIENT_ID",
		ClientSecret: "YOUR_CLIENT_SECRET",
		Scopes:       []string{"SCOPE1", "SCOPE2"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://provider.com/o/oauth2/auth",
			TokenURL: "https://provider.com/o/oauth2/token",
		},
	}

	url := conf.AuthCodeURL(stateStringVar) // BAD
	_ = url
	// ...
}
func badWithFixedStateReturned(w http.ResponseWriter) {
	conf := &oauth2.Config{
		ClientID:     "YOUR_CLIENT_ID",
		ClientSecret: "YOUR_CLIENT_SECRET",
		Scopes:       []string{"SCOPE1", "SCOPE2"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://provider.com/o/oauth2/auth",
			TokenURL: "https://provider.com/o/oauth2/token",
		},
	}

	state := newFixedState()
	url := conf.AuthCodeURL(state) // BAD
	_ = url
	// ...
}
func newFixedState() string {
	return "state"
}

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
	url := conf.AuthCodeURL(state) // OK, because the state is not a constant.
	_ = url
	// ...
}
func generateStateOauthCookie(w http.ResponseWriter) string {
	b := make([]byte, 128)
	rand.Read(b)
	state := base64.URLEncoding.EncodeToString(b)
	// TODO: save the state string to cookies or HTML storage.
	return state
}
func okWithMixedVarState(w http.ResponseWriter) {
	conf := &oauth2.Config{
		ClientID:     "YOUR_CLIENT_ID",
		ClientSecret: "YOUR_CLIENT_SECRET",
		Scopes:       []string{"SCOPE1", "SCOPE2"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://provider.com/o/oauth2/auth",
			TokenURL: "https://provider.com/o/oauth2/token",
		},
	}

	state := fmt.Sprintf("%s-%s", stateStringVar, NewCSRFToken())

	url := conf.AuthCodeURL(state) // OK, because the state is not a constant.
	_ = url
	// ...
}

func NewCSRFToken() string {
	b := make([]byte, 128)
	rand.Read(b)
	randomToken := base64.URLEncoding.EncodeToString(b)
	return randomToken
}
func okWithConstStatePrinter(w http.ResponseWriter) {
	conf := &oauth2.Config{
		ClientID:     "YOUR_CLIENT_ID",
		ClientSecret: "YOUR_CLIENT_SECRET",
		Scopes:       []string{"SCOPE1", "SCOPE2"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://provider.com/o/oauth2/auth",
			TokenURL: "https://provider.com/o/oauth2/token",
		},
	}

	url := conf.AuthCodeURL(stateStringConst) // OK, because we're supposedly not exposed to the web, but within a terminal.
	fmt.Printf("Visit the URL for the auth dialog: %v", url)
	// ...

	var code string
	if _, err := fmt.Scan(&code); err != nil {
		log.Fatal(err)
	}
	_ = code
	// ...
}
func okWithConstStateFPrinter(w http.ResponseWriter) {
	conf := &oauth2.Config{
		ClientID:     "YOUR_CLIENT_ID",
		ClientSecret: "YOUR_CLIENT_SECRET",
		Scopes:       []string{"SCOPE1", "SCOPE2"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://provider.com/o/oauth2/auth",
			TokenURL: "https://provider.com/o/oauth2/token",
		},
	}

	url := conf.AuthCodeURL(stateStringConst) // OK, because we're supposedly not exposed to the web, but within a terminal.
	fmt.Printf("Visit the URL for the auth dialog: %v", url)
	// ...

	var code string
	if _, err := fmt.Fscan(os.Stdin, &code); err != nil {
		log.Fatal(err)
	}
	_ = code
	// ...
}
func okWithConstStateBufio(w http.ResponseWriter) {
	conf := &oauth2.Config{
		ClientID:     "YOUR_CLIENT_ID",
		ClientSecret: "YOUR_CLIENT_SECRET",
		Scopes:       []string{"SCOPE1", "SCOPE2"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://provider.com/o/oauth2/auth",
			TokenURL: "https://provider.com/o/oauth2/token",
		},
	}

	url := conf.AuthCodeURL(stateStringConst) // OK, because we're supposedly not exposed to the web, but within a terminal.
	fmt.Printf("Visit the URL for the auth dialog: %v", url)
	// ...

	scanner := bufio.NewScanner(os.Stdin)
	_ = scanner
	// ...
}
func okWithConstStateLogger(w http.ResponseWriter) {
	conf := &oauth2.Config{
		ClientID:     "YOUR_CLIENT_ID",
		ClientSecret: "YOUR_CLIENT_SECRET",
		Scopes:       []string{"SCOPE1", "SCOPE2"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://provider.com/o/oauth2/auth",
			TokenURL: "https://provider.com/o/oauth2/token",
		},
	}

	url := conf.AuthCodeURL(stateStringConst) // OK, because we're supposedly not exposed to the web, but within a terminal.
	log.Printf("Visit the URL for the auth dialog: %v", url)
	// ...

	var code string
	if _, err := fmt.Fscan(os.Stdin, &code); err != nil {
		log.Fatal(err)
	}
	_ = code
	// ...
}
func badWithConstStatePrinter(w http.ResponseWriter) {
	conf := &oauth2.Config{
		ClientID:     "YOUR_CLIENT_ID",
		ClientSecret: "YOUR_CLIENT_SECRET",
		Scopes:       []string{"SCOPE1", "SCOPE2"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://provider.com/o/oauth2/auth",
			TokenURL: "https://provider.com/o/oauth2/token",
		},
	}

	url := conf.AuthCodeURL(stateStringConst) // BAD
	fmt.Printf("LOG: URL %v", url)
	// ...
}

func okWithLocalUrl(w http.ResponseWriter) {
	conf := &oauth2.Config{
		RedirectURL:  "http://localhost:8080",
		ClientID:     "YOUR_CLIENT_ID",
		ClientSecret: "YOUR_CLIENT_SECRET",
		Scopes:       []string{"SCOPE1", "SCOPE2"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://provider.com/o/oauth2/auth",
			TokenURL: "https://provider.com/o/oauth2/token",
		},
	}

	url := conf.AuthCodeURL(stateStringConst) // OK because the config uses a local url
	_ = url
}

func okWithLocalUrlSprintf(w http.ResponseWriter) {
	port := 8080
	conf := &oauth2.Config{
		RedirectURL:  fmt.Sprintf("%s:%d", "http://localhost:8080", port),
		ClientID:     "YOUR_CLIENT_ID",
		ClientSecret: "YOUR_CLIENT_SECRET",
		Scopes:       []string{"SCOPE1", "SCOPE2"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://provider.com/o/oauth2/auth",
			TokenURL: "https://provider.com/o/oauth2/token",
		},
	}

	url := conf.AuthCodeURL(stateStringConst) // OK because the config uses a local url
	_ = url
}

func okWithOutOfBoundsToken(w http.ResponseWriter) {
	conf := &oauth2.Config{
		RedirectURL:  "oob",
		ClientID:     "YOUR_CLIENT_ID",
		ClientSecret: "YOUR_CLIENT_SECRET",
		Scopes:       []string{"SCOPE1", "SCOPE2"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://provider.com/o/oauth2/auth",
			TokenURL: "https://provider.com/o/oauth2/token",
		},
	}

	url := conf.AuthCodeURL(stateStringConst) // OK because the config uses a token indicating out-of-band communication
	_ = url
}

func tryGetState(success bool) (string, string, int, error) {
	if success {
		return NewCSRFToken(), "dummy", 0, nil
	} else {
		return "", "", 0, errors.New("success not set")
	}
}

func okConstantOnlySuppliedAlongsideError(w http.ResponseWriter) {
	conf := &oauth2.Config{
		ClientID:     "YOUR_CLIENT_ID",
		ClientSecret: "YOUR_CLIENT_SECRET",
		Scopes:       []string{"SCOPE1", "SCOPE2"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://provider.com/o/oauth2/auth",
			TokenURL: "https://provider.com/o/oauth2/token",
		},
	}

	token, _, _, err := tryGetState(len(os.Args)%3 == 1)
	if err != nil {
		url := conf.AuthCodeURL(token) // OK because constant states coming from tryGetState only occur with errors
		_ = url
	}
}

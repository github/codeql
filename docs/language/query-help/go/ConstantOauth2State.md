# Use of constant `state` value in OAuth 2.0 URL

```
ID: go/constant-oauth2-state
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-352

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-352/ConstantOauth2State.ql)

OAuth 2.0 clients must implement CSRF protection for the redirection URI, which is typically accomplished by including a "state" value that binds the request to the user's authenticated state. The Go OAuth 2.0 library allows you to specify a "state" value which is then included in the auth code URL. That state is then provided back by the remote authentication server in the redirect callback, from where it must be validated. Failure to do so makes the client susceptible to an CSRF attack.


## Recommendation
Always include a unique, non-guessable `state` value (provided to the call to `AuthCodeURL` function) that is also bound to the user's authenticated state with each authentication request, and then validated in the redirect callback.


## Example
The first example shows you the use of a constant state (bad).


```go
package main

import (
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

	url := conf.AuthCodeURL(stateStringVar)
	// ...
}

```
The second example shows a better implementation idea.


```go
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

```

## References
* IETF: [The OAuth 2.0 Authorization Framework](https://tools.ietf.org/html/rfc6749#section-10.12)
* IETF: [OAuth 2.0 Security Best Current Practice](https://tools.ietf.org/html/draft-ietf-oauth-security-topics-15#section-2.1)
* Common Weakness Enumeration: [CWE-352](https://cwe.mitre.org/data/definitions/352.html).
package main

import (
	"time"

	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwk"
	"github.com/lestrrat-go/jwx/v2/jwt"
)

func ExampleJWT_Parse() {
	jwkSymmetricKey, _ := jwk.FromRaw([]byte(`abracadabra`))
	tok, err := jwt.NewBuilder().
		Issuer(`github.com/lestrrat-go/jwx`).
		IssuedAt(time.Now().Add(-5 * time.Minute)).
		Expiration(time.Now().Add(time.Hour)).
		Build()
	v, err := jwt.Sign(tok, jwt.WithKey(jwa.HS256, jwkSymmetricKey))
	if err != nil {
		return
	}
	jwtSignedWithHS256 := v
	tok, err = jwt.Parse(jwtSignedWithHS256)
	if err != nil {
		return
	}
	tok, err = jwt.Parse(jwtSignedWithHS256, jwt.WithKey(jwa.HS256, jwkSymmetricKey))
	if err != nil {
		return
	}
	tok, err = jwt.ParseInsecure(jwtSignedWithHS256)
	if err != nil {
		return
	}
	_ = tok
	// OUTPUT:
}
func main() {
	ExampleJWT_Parse()
}

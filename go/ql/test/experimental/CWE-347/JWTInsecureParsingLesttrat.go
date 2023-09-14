package main

import (
	"fmt"
	"time"

	"github.com/lestrrat-go/jwx/jwa"
	"github.com/lestrrat-go/jwx/jwt"
)

func ExampleJWT_Parse() {
	jwkSymmetricKey := []byte(`abracadabra`)
	tok, err := jwt.NewBuilder().
		Issuer(`github.com/lestrrat-go/jwx`).
		IssuedAt(time.Now().Add(-5 * time.Minute)).
		Expiration(time.Now().Add(time.Hour)).
		Build()
	alg := jwa.HS256
	v, err := jwt.Sign(tok, alg, jwkSymmetricKey)
	if err != nil {
		fmt.Errorf(`failed to sign token with HS256: %w`, err)
		return
	}
	jwtSignedWithHS256 := v
	//Bad
	tok, err = jwt.Parse(jwtSignedWithHS256)
	if err != nil {
		fmt.Printf("%s\n", err)
		return
	}
	//Good
	tok, err = jwt.Parse(jwtSignedWithHS256, jwt.WithVerify(alg, jwkSymmetricKey))
	if err != nil {
		fmt.Printf("%s\n", err)
		return
	}
	_ = tok
	// OUTPUT:
}

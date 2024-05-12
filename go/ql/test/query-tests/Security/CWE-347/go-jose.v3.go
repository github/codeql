package jwt

//go:generate depstubber -vendor  github.com/go-jose/go-jose/v3/jwt JSONWebToken ParseSigned

import (
	"fmt"
	"github.com/go-jose/go-jose/v3/jwt"
	"net/http"
)

type CustomerInfo struct {
	Name string
	ID   int
}

var JwtKey = []byte("AllYourBase")

func jose(r *http.Request) {
	signedToken := r.URL.Query().Get("signedToken")
	// OK: first decode and then verify
	notVerifyJWT(signedToken)
	verifyJWT(signedToken)

	// NOT OK: no verification
	signedToken = r.URL.Query().Get("signedToken")
	notVerifyJWT(signedToken)
}

func notVerifyJWT(signedToken string) {
	fmt.Println("only decoding JWT")
	DecodedToken, _ := jwt.ParseSigned(signedToken)
	out := CustomerInfo{}
	if err := DecodedToken.UnsafeClaimsWithoutVerification(&out); err != nil {
		panic(err)
	}
	fmt.Printf("%v\n", out)
}
func verifyJWT(signedToken string) {
	fmt.Println("verifying JWT")
	DecodedToken, _ := jwt.ParseSigned(signedToken)
	out := CustomerInfo{}
	if err := DecodedToken.Claims(JwtKey, &out); err != nil {
		panic(err)
	}
	fmt.Printf("%v\n", out)
}

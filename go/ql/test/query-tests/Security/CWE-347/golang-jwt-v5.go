package jwt

//go:generate depstubber -vendor  github.com/golang-jwt/jwt/v5 RegisteredClaims,Parser,Token ParseWithClaims,NewParser

import (
	"fmt"
	"github.com/golang-jwt/jwt/v5"
	"log"
	"net/http"
)

type CustomerInfo1 struct {
	Name string
	ID   int
	jwt.RegisteredClaims
}

// BAD constant key
var JwtKey1 = []byte("AllYourBase")

func golangjwt(r *http.Request) {
	signedToken := r.URL.Query().Get("signedToken")
	// OK: first decode and then verify
	notVerifyJWT_golangjwt(signedToken)
	verifyJWT_golangjwt(signedToken)

	// NOT OK: only unverified parse
	signedToken = r.URL.Query().Get("signedToken")
	notVerifyJWT_golangjwt(signedToken)
}

func notVerifyJWT_golangjwt(signedToken string) {
	fmt.Println("only decoding JWT")
	DecodedToken, _, err := jwt.NewParser().ParseUnverified(signedToken, &CustomerInfo1{})
	if claims, ok := DecodedToken.Claims.(*CustomerInfo1); ok {
		fmt.Printf("DecodedToken:%v\n", claims)
	} else {
		log.Fatal("error", err)
	}
}

func LoadJwtKey(token *jwt.Token) (interface{}, error) {
	return JwtKey, nil
}

func verifyJWT_golangjwt(signedToken string) {
	fmt.Println("verifying JWT")
	DecodedToken, err := jwt.ParseWithClaims(signedToken, &CustomerInfo1{}, LoadJwtKey)
	if claims, ok := DecodedToken.Claims.(*CustomerInfo1); ok && DecodedToken.Valid {
		fmt.Printf("NAME:%v ,ID:%v\n", claims.Name, claims.ID)
	} else {
		log.Fatal(err)
	}
}

package jwt

//go:generate depstubber -vendor  github.com/go-jose/go-jose/v3/jwt JSONWebToken ParseSigned

import (
	"fmt"
	"net/http"

	"github.com/go-jose/go-jose/v3/jwt"
)

// NOT OK
var JwtKey = []byte("AllYourBase")

func main2(r *http.Request) {
	signedToken := r.URL.Query().Get("signedToken")
	verifyJWT(signedToken)
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

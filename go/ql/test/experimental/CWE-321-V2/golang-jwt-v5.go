package jwt

//go:generate depstubber -vendor  github.com/golang-jwt/jwt/v5 RegisteredClaims,Parser,Token Parse,ParseWithClaims

import (
	"fmt"
	"github.com/golang-jwt/jwt/v5"
	"log"
	"net/http"
)

type CustomerInfo struct {
	Name string
	ID   int
	jwt.RegisteredClaims
}

// BAD constant key
var JwtKey1 = []byte("AllYourBase")

func main1(r *http.Request) {
	signedToken := r.URL.Query().Get("signedToken")
	verifyJWT_golangjwt(signedToken)
}

func LoadJwtKey(token *jwt.Token) (interface{}, error) {
	return JwtKey1, nil
}

func verifyJWT_golangjwt(signedToken string) {
	fmt.Println("verifying JWT")
	DecodedToken, err := jwt.ParseWithClaims(signedToken, &CustomerInfo{}, LoadJwtKey)
	if claims, ok := DecodedToken.Claims.(*CustomerInfo); ok && DecodedToken.Valid {
		fmt.Printf("NAME:%v ,ID:%v\n", claims.Name, claims.ID)
	} else {
		log.Fatal(err)
	}
}

package main

import (
	"fmt"
	"log"

	"github.com/golang-jwt/jwt/v5"
)

func main() {
	// BAD: only decode jwt without verification
	notVerifyJWT(token)

	// GOOD: decode with verification or verify plus decode
	notVerifyJWT(token)
	VerifyJWT(token)
}

func notVerifyJWT(signedToken string) {
	fmt.Println("only decoding JWT")
	DecodedToken, _, err := jwt.NewParser().ParseUnverified(signedToken, &CustomerInfo{})
	if claims, ok := DecodedToken.Claims.(*CustomerInfo); ok {
		fmt.Printf("DecodedToken:%v\n", claims)
	} else {
		log.Fatal("error", err)
	}
}
func LoadJwtKey(token *jwt.Token) (interface{}, error) {
	return ARandomJwtKey, nil
}
func verifyJWT(signedToken string) {
	fmt.Println("verifying JWT")
	DecodedToken, err := jwt.ParseWithClaims(signedToken, &CustomerInfo{}, LoadJwtKey)
	if claims, ok := DecodedToken.Claims.(*CustomerInfo); ok && DecodedToken.Valid {
		fmt.Printf("NAME:%v ,ID:%v\n", claims.Name, claims.ID)
	} else {
		log.Fatal(err)
	}
}

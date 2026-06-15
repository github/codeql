package main

import (
	"fmt"
	"log"

	"github.com/golang-jwt/jwt/v5"
)

type User struct{}

func parseJwt(token string, jwtKey []byte) {
	// GOOD: JWT is parsed with signature verification using jwtKey
	DecodedToken, err := jwt.ParseWithClaims(token, &User{}, func(token *jwt.Token) (interface{}, error) {
		return jwtKey, nil
	})
	if claims, ok := DecodedToken.Claims.(*User); ok && DecodedToken.Valid && !err {
		fmt.Printf("DecodedToken:%v\n", claims)
	} else {
		log.Fatal(err)
	}
}

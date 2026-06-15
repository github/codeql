package main

import (
	"fmt"
	"log"

	"github.com/golang-jwt/jwt/v5"
)

type User struct{}

func decodeJwt(token string) {
	// BAD: JWT is only decoded without signature verification
	fmt.Println("only decoding JWT")
	DecodedToken, _, err := jwt.NewParser().ParseUnverified(token, &User{})
	if claims, ok := DecodedToken.Claims.(*User); ok {
		fmt.Printf("DecodedToken:%v\n", claims)
	} else {
		log.Fatal("error", err)
	}
}

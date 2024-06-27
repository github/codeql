package main

import (
	"time"

	jwt "github.com/golang-jwt/jwt/v4"
)

func bad() (interface{}, error) {

	mySigningKey := []byte("AllYourBase")

	claims := &jwt.RegisteredClaims{
		ExpiresAt: jwt.NewNumericDate(time.Unix(1516239022, 0)),
		Issuer:    "test",
	}

	token := jwt.NewWithClaims(nil, claims)
	return token.SignedString(mySigningKey)
}

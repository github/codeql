package main

import (
	crand "crypto/rand"
	"fmt"
	"math/big"
	"time"

	jwt "github.com/golang-jwt/jwt/v4"
)

func GenerateCryptoString(n int) (string, error) {
	const chars = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-"
	ret := make([]byte, n)
	for i := range ret {
		num, err := crand.Int(crand.Reader, big.NewInt(int64(len(chars))))
		if err != nil {
			return "", err
		}
		ret[i] = chars[num.Int64()]
	}
	return string(ret), nil
}

func good() (interface{}, error) {
	mySigningKey, err := GenerateCryptoString(64)
	if mySigningKey == "" {
		_ = fmt.Errorf("Error : %s", err)
	}

	claims := &jwt.RegisteredClaims{
		ExpiresAt: jwt.NewNumericDate(time.Unix(1516239022, 0)),
		Issuer:    "test",
	}

	token := jwt.NewWithClaims(nil, claims)
	return token.SignedString(mySigningKey)
}

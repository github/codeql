package main

import (
	"crypto/subtle"
	"fmt"
	"net/http"
)

func bad(w http.ResponseWriter, req *http.Request) (interface{}, error) {

	secret := "MySuperSecretPasscode"
	secretHeader := "X-Secret"

	headerSecret := req.Header.Get(secretHeader)
	secretStr := string(secret)
	if len(secret) != 0 && headerSecret != secretStr {
		return nil, fmt.Errorf("header %s=%s did not match expected secret", secretHeader, headerSecret)
	}
	return nil, nil
}

func good(w http.ResponseWriter, req *http.Request) (interface{}, error) {

	secret := []byte("MySuperSecretPasscode")
	secretHeader := "X-Secret"

	headerSecret := req.Header.Get(secretHeader)
	if len(secret) != 0 && subtle.ConstantTimeCompare(secret, []byte(headerSecret)) != 1 {
		return nil, fmt.Errorf("header %s=%s did not match expected secret", secretHeader, headerSecret)
	}
	return nil, nil
}

func main() {
	bad(nil, nil)
	good(nil, nil)
}

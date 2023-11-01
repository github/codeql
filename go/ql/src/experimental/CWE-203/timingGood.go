package main

import (
	"crypto/subtle"
	"fmt"
	"net/http"
)

func good(w http.ResponseWriter, req *http.Request, secret []byte) (interface{}, error) {

	secretHeader := "X-Secret"

	headerSecret := req.Header.Get(secretHeader)
	if len(secret) != 0 && subtle.ConstantTimeCompare(secret, []byte(headerSecret)) != 1 {
		return nil, fmt.Errorf("header %s=%s did not match expected secret", secretHeader, headerSecret)
	}
	return nil, nil
}

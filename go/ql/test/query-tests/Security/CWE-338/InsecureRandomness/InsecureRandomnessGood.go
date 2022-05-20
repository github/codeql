package main

import (
	"crypto/rand"
	"math/big"
)

func generatePasswordGood() string {
	s := make([]rune, 20)
	for i := range s {
		idx, err := rand.Int(rand.Reader, big.NewInt(int64(len(charset))))
		if err != nil {
			// handle err
		}
		s[i] = charset[idx.Int64()]
	}
	return string(s)
}

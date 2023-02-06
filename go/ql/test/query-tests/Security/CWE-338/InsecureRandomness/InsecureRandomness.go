package main

import (
	"math/rand"
)

var charset = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")

func generatePassword() string {
	s := make([]rune, 20)
	for i := range s {
		s[i] = charset[rand.Intn(len(charset))] // BAD: weak RNG used to generate password
	}
	return string(s)
}

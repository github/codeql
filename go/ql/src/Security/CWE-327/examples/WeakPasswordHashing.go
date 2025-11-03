package main

import (
	"crypto/pbkdf2"
	"crypto/rand"
	"crypto/sha256"
	"crypto/sha512"
)

func GetPasswordHashBad(password string) [32]byte {
	// BAD, SHA256 is a strong hashing algorithm but it is not computationally expensive
	return sha256.Sum256([]byte(password))
}

func GetPasswordHashGood(password string) []byte {
	// GOOD, PBKDF2 is a strong hashing algorithm and it is computationally expensive
	salt := make([]byte, 16)
	rand.Read(salt)
	key, _ := pbkdf2.Key(sha512.New, password, salt, 4096, 32)
	return key
}

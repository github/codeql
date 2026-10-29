package main

import (
	"crypto/sha1"
	"crypto/sha256"
	"slices"
)

func SecretMatchesKnownHashBad(secret []byte, known_hash []byte) bool {
	// BAD, SHA1 is a weak crypto algorithm and secret is sensitive data
	h := sha1.New()
	return slices.Equal(h.Sum(secret), known_hash)
}

func SecretMatchesKnownHashGood(secret []byte, known_hash []byte) bool {
	// GOOD, SHA256 is a strong hashing algorithm
	h := sha256.New()
	return slices.Equal(h.Sum(secret), known_hash)
}

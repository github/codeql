package main

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/ed25519"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"io"
	"math/rand"
)

func Guid() []byte {
	hash := sha256.Sum256([]byte(fmt.Sprintf("%n", rand.Uint32()))) // OK: may not be used in a cryptographic setting
	return hash[:]
}

func createHash(key string) string {
	hash := sha256.New()
	hash.Write([]byte(key))
	return hex.EncodeToString(hash.Sum(nil))
}

func ed25519FromGuid() {
	ed25519.NewKeyFromSeed(Guid()) // BAD: Guid internally uses rand
}

func encrypt(data []byte, password string) []byte {
	block, _ := aes.NewCipher([]byte(createHash(password)))
	gcm, _ := cipher.NewGCM(block)

	nonce := make([]byte, gcm.NonceSize())
	random := rand.New(rand.NewSource(999))
	io.ReadFull(random, nonce)

	ciphertext := gcm.Seal(nonce, nonce, data, nil) // BAD: use of an insecure rng to generate a nonce
	return ciphertext
}

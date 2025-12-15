package main

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/sha256"
	"encoding/hex"
	"io"
	"math/rand"
)

func createHash(key string) string {
	hash := sha256.New()
	hash.Write([]byte(key))
	return hex.EncodeToString(hash.Sum(nil))
}

func encrypt(data []byte, password string) []byte {

	block, _ := aes.NewCipher([]byte(createHash(password)))
	gcm, _ := cipher.NewGCM(block)

	nonce := make([]byte, gcm.NonceSize())
	random := rand.New(rand.NewSource(999))
	io.ReadFull(random, nonce)

	ciphertext := gcm.Seal(nonce, nonce, data, nil)
	return ciphertext
}

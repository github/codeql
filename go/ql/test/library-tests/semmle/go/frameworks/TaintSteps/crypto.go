package main

import (
	"crypto/aes"
	"crypto/cipher"
)

func cryptoTest(key []byte, nonce []byte, ciphertext []byte) []byte {
	block, _ := aes.NewCipher(key)
	aesgcm, _ := cipher.NewGCM(block)
	plaintext, _ := aesgcm.Open(nil, nonce, ciphertext, nil)
	return plaintext
}

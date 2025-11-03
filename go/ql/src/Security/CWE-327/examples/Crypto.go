package main

import (
	"crypto/aes"
	"crypto/des"
)

func EncryptMessageWeak(key []byte, message []byte) (dst []byte) {
	// BAD, DES is a weak crypto algorithm
	block, _ := des.NewCipher(key)
	block.Encrypt(dst, message)
	return
}

func EncryptMessageStrong(key []byte, message []byte) (dst []byte) {
	// GOOD, AES is a weak crypto algorithm
	block, _ := aes.NewCipher(key)
	block.Encrypt(dst, message)
	return
}

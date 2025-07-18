package main

import (
	"crypto/aes"
	"crypto/des"
	"crypto/md5"
	"crypto/rc4"
	"crypto/sha1"
	"crypto/sha256"
)

func crypto() {
	public := []byte("hello")

	password := []byte("123456")

	// testing dataflow by passing into different variable
	buf := password // $ Source

	// BAD, des is a weak crypto algorithm and password is sensitive data
	des.NewTripleDESCipher(buf) // $ Alert

	// BAD, md5 is a weak crypto algorithm and password is sensitive data
	md5.Sum(buf) // $ Alert

	// BAD, rc4 is a weak crypto algorithm and password is sensitive data
	rc4.NewCipher(buf) // $ Alert

	// BAD, sha1 is a weak crypto algorithm and password is sensitive data
	sha1.Sum(buf) // $ Alert

	// GOOD, password is sensitive data but aes is a strong crypto algorithm
	aes.NewCipher(buf)

	// GOOD, password is sensitive data but sha256 is a strong crypto algorithm
	sha256.Sum256(buf)

	// GOOD, des is a weak crypto algorithm but public is not sensitive data
	des.NewTripleDESCipher(public)

	// GOOD, md5 is a weak crypto algorithm but public is not sensitive data
	md5.Sum(public)

	// GOOD, rc4 is a weak crypto algorithm but public is not sensitive data
	rc4.NewCipher(public)

	// GOOD, sha1 is a weak crypto algorithm but public is not sensitive data
	sha1.Sum(public)

	// GOOD, aes is a strong crypto algorithm and public is not sensitive data
	aes.NewCipher(public)

	// GOOD, sha256 is a strong crypto algorithm and public is not sensitive data
	sha256.Sum256(public)
}

package main

import (
	"crypto/aes"
	"crypto/des"
	"crypto/md5"
	"crypto/rc4"
	"crypto/sha1"
	"crypto/sha256"
)

func main() {
	password := []byte("password")

	// BAD, des is a weak crypto algorithm
	des.NewTripleDESCipher(password)

	// BAD, md5 is a weak crypto algorithm
	md5.Sum(password)

	// BAD, rc4 is a weak crypto algorithm
	rc4.NewCipher(password)

	// BAD, sha1 is a weak crypto algorithm
	sha1.Sum(password)

	// GOOD, aes is a strong crypto algorithm
	aes.NewCipher(password)

	// GOOD, sha256 is a strong crypto algorithm
	sha256.Sum256(password)

}

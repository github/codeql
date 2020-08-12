package main

import (
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

	key := []byte{ 1, 2, 3, 4, 5, 6, 7 }
	// BAD, rc4 is a weak crypto algorithm
	rc4.NewCipher(key)

	data := []byte("this page intentionally left blank.")
	// BAD, sha1 is a weak crypto algorithm
	sha1.Sum(data)

	sha256key := []byte("hello world")
    // GOOD, sha256 is a strong crypto algorithm
    sha256.Sum256([]byte(sha256key))
}

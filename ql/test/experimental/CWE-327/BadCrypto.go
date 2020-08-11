package main

import (
	"crypto/des"
	"crypto/md5"
	"fmt"
)

func main() {

	password := []byte("password")

	var tripleDESKey []byte
	tripleDESKey = append(tripleDESKey, password[:16]...)
	tripleDESKey = append(tripleDESKey, password[:8]...)

	// BAD, des is a weak crypto algorithm
	_, err := des.NewTripleDESCipher(tripleDESKey)
	if err != nil {
		panic(err)
	}

	// BAD, md5 is a weak crypto algorithm
	fmt.Printf("%x", md5.Sum(password))

}

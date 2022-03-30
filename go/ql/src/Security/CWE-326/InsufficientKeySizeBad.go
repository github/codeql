package main

import (
	"crypto/rand"
	"crypto/rsa"
	"fmt"
)

func main() {
	//Generate Private Key
	pvk, err := rsa.GenerateKey(rand.Reader, 1024)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(pvk)
}

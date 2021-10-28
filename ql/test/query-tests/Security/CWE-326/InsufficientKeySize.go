package main

import (
	"crypto/rand"
	"crypto/rsa"
)

func foo1() {
	rsa.GenerateKey(rand.Reader, 1024) // BAD
}

func foo2() {
	size := 1024
	rsa.GenerateKey(rand.Reader, size) // BAD
}

func foo3() {
	foo5(1024) // BAD
}

func foo4() {
	foo5(2048) // GOOD
}

func foo5(size int) {
	rsa.GenerateKey(rand.Reader, size)
}

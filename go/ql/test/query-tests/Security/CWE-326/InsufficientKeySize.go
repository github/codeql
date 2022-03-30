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

func foo6() {
	keyBits := 1024
	if keyBits >= 2047 {
		rsa.GenerateKey(rand.Reader, keyBits) // BAD
	}
}

func foo7() {
	keyBits := 1024
	if keyBits >= 2048 {
		rsa.GenerateKey(rand.Reader, keyBits) // GOOD
	}
}

func foo8() {
	keyBits := 1024
	switch {
	case keyBits >= 2047:
		rsa.GenerateKey(rand.Reader, keyBits) // BAD
	}
}

func foo9() {
	keyBits := 1024
	switch {
	case keyBits >= 2048:
		rsa.GenerateKey(rand.Reader, keyBits) // GOOD
	}
}

func foo10(customOptionSupplied bool, nonConstantKeyBits int) {
	keyBits := 0
	constantKeyBits := 1024
	if customOptionSupplied {
		keyBits = constantKeyBits
	} else {
		keyBits = nonConstantKeyBits
	}
	rsa.GenerateKey(rand.Reader, keyBits) // BAD
}

func foo11(customOptionSupplied bool, nonConstantKeyBits int) {
	keyBits := 0
	constantKeyBits := 1024
	if customOptionSupplied {
		keyBits = constantKeyBits
	} else {
		keyBits = nonConstantKeyBits
	}
	if keyBits >= 2048 {
		rsa.GenerateKey(rand.Reader, keyBits) // GOOD
	}
}

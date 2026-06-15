package main

import (
	"crypto/rand"
	"crypto/rsa"
)

func foo1() {
	rsa.GenerateKey(rand.Reader, 1024) // $ Alert // BAD
}

func foo2() {
	size := 1024                       // $ Source
	rsa.GenerateKey(rand.Reader, size) // $ Alert // BAD
}

func foo3() {
	foo5(1024) // $ Source // BAD
}

func foo4() {
	foo5(2048) // GOOD
}

func foo5(size int) {
	rsa.GenerateKey(rand.Reader, size) // $ Alert
}

func foo6() {
	keyBits := 1024 // $ Source
	if keyBits >= 2047 {
		rsa.GenerateKey(rand.Reader, keyBits) // $ Alert // BAD
	}
}

func foo7() {
	keyBits := 1024
	if keyBits >= 2048 {
		rsa.GenerateKey(rand.Reader, keyBits) // GOOD
	}
}

func foo8() {
	keyBits := 1024 // $ Source
	switch {
	case keyBits >= 2047:
		rsa.GenerateKey(rand.Reader, keyBits) // $ Alert // BAD
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
	constantKeyBits := 1024 // $ Source
	if customOptionSupplied {
		keyBits = constantKeyBits
	} else {
		keyBits = nonConstantKeyBits
	}
	rsa.GenerateKey(rand.Reader, keyBits) // $ Alert // BAD
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

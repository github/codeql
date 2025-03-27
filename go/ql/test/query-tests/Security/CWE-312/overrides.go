package main

import "fmt"

type s struct{}

func (_ s) String() string {
	password := "horsebatterystaplecorrect"
	return password // $ Source
}

func overrideTest(x s, y fmt.Stringer) {
	fmt.Println(x.String()) // $ Alert
	fmt.Println(y.String()) // OK
}

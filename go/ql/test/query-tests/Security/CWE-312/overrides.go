package main

import "fmt"

type s struct{}

func (_ s) String() string {
	password := "horsebatterystaplecorrect"
	return password
}

func overrideTest(x s, y fmt.Stringer) {
	fmt.Println(x.String()) // NOT OK
	fmt.Println(y.String()) // OK
}

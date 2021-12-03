package main

import "fmt"

func callRecover1() {
	if recover() != nil {
		fmt.Printf("recovered")
	}
}

func fun1() {
	defer func() {
		callRecover1()
	}()
	panic("1")
}

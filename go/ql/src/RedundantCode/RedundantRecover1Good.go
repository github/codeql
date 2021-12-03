package main

import "fmt"

func callRecover1Good() {
	if recover() != nil {
		fmt.Printf("recovered")
	}
}

func fun1Good() {
	defer callRecover1Good()
	panic("1")
}

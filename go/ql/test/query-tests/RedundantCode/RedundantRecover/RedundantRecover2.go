package main

func fun2() {
	defer recover() // $ Alert
	panic("2")
}

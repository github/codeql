package main

func fun2() {
	defer recover()
	panic("2")
}

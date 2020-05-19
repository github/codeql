package main

func fun2Good() {
	defer func() { recover() }()
	panic("2")
}

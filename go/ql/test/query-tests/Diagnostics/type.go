package main

type T int

type V int

func takesT(t T) {}

func passesV() {
	var v V
	takesT(v)
}

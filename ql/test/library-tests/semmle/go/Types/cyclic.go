package main

type s struct {
	*s
}

type t struct {
	*u
	f int
}

type u struct {
	t
}

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

type v struct {
	s
}

// the below will cause the test to not terminate
// type w struct {
// 	v
// }

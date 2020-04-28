package main

import (
	"io"
	"net/http"
)

func use(xs ...interface{}) {}

var test = "localhost"

// bad both are from remote sources
func ex1(w http.ResponseWriter, r *http.Request) {
	if r.Header.Get("Origin") != test {
		authkey := "randomDatta"
		io.WriteString(w, authkey)
	}
}

func ex2(w http.ResponseWriter, r *http.Request) {
	test2 := "test"
	if r.Header.Get("Origin") != test2 {
		authkey := "randomDatta2"
		io.WriteString(w, authkey)
	}
}

func ex3(w http.ResponseWriter, r *http.Request) {
	test2 := "test"
	if r.Header.Get("Origin") != test2 {
		login()
	}
}

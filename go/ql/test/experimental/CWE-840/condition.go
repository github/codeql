package main

import (
	"net/http"
)

// BAD: taken from https://www.gorillatoolkit.org/pkg/websocket
func ex1(w http.ResponseWriter, r *http.Request) {
	if r.Header.Get("Origin") != "http://"+r.Host {
		//do something
	}
}

// BAD: both operands are from remote sources
func ex2(w http.ResponseWriter, r *http.Request) {
	if r.Header.Get("Origin") != "http://"+r.Header.Get("Header") {
		//do something
	}
}

// GOOD
func ex3(w http.ResponseWriter, r *http.Request) {
	if r.Header.Get("Origin") != "http://"+"test" {
		//do something
	}
}

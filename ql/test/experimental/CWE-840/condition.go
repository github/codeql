package main

import (
	"net/http"
)

// bad : taken from https://www.gorillatoolkit.org/pkg/websocket
func ex1(w http.ResponseWriter, r *http.Request) {
	if r.Header.Get("Origin") != "http://"+r.Host {
		//do something
	}
}

// bad both are from remote sources
func ex2(w http.ResponseWriter, r *http.Request) {
	if r.Header.Get("Origin") != "http://"+r.Header.Get("Header") {
		//do something
	}
}

// good
func ex3(w http.ResponseWriter, r *http.Request) {
	if r.Header.Get("Origin") != "http://"+"test" {
		//do something
	}
}

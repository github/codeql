package main

import (
	"net/http"
)

// bad the origin and the host headers are user controlled
func ex1(w http.ResponseWriter, r *http.Request) {
	if r.Header.Get("Origin") != "http://"+r.Host {
		//do something
	}
}

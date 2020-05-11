package main

import (
	"net/http"
)

func ex1(w http.ResponseWriter, r *http.Request) {
	// bad the origin and the host headers are user controlled
	if r.Header.Get("Origin") != "http://"+r.Host {
		//do something
	}
}

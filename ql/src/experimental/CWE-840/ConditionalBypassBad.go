package main

import (
	"net/http"
)

func exampleHandlerBad(w http.ResponseWriter, r *http.Request) {
	// BAD: the Origin and Host headers are user controlled
	if r.Header.Get("Origin") != "http://"+r.Host {
		//do something
	}
}

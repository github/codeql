package main

import (
	"net/http"
)

func ex1(w http.ResponseWriter, r *http.Request) {
	if r.Header.Get("Origin") != config.get("Host") {
		//do something
	}
}

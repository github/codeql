package main

import (
	"net/http"
)

func exampleHandlerGood(w http.ResponseWriter, r *http.Request) {
	// GOOD: the configuration is not user controlled
	if r.Header.Get("Origin") != config.get("Host") {
		//do something
	}
}

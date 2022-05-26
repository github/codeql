package main

import "net/http"

func example(w http.ResponseWriter, r *http.Request) {
	test2 := "test"
	if r.Header.Get("X-Password") != test2 {
		login()
	}
}

package main

import (
	"net/http"
)

func handlerBad(w http.ResponseWriter, r *http.Request) {
	c := http.Cookie{
		Name:  "session",
		Value: "secret",
	}
	http.SetCookie(w, &c) // BAD: The Secure flag is set to false by default.
}

func handlerGood(w http.ResponseWriter, r *http.Request) {
	c := http.Cookie{
		Name:   "session",
		Value:  "secret",
		Secure: true,
	}
	http.SetCookie(w, &c) // GOOD: The Secure flag is set to true.
}

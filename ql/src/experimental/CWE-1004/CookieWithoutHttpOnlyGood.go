package main

import (
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	c := http.Cookie{
		Name:     "session",
		Value:    "secret",
		HttpOnly: true,
	}
	http.SetCookie(w, &c)
}

func main() {
	http.HandleFunc("/", handler)
}

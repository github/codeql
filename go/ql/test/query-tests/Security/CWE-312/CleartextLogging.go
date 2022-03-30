package main

import (
	"log"
	"net/http"
)

func serve() {
	http.HandleFunc("/register", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		user := r.Form.Get("user")
		pw := r.Form.Get("password")

		log.Printf("Registering new user %s with password %s.\n", user, pw)
	})
	http.ListenAndServe(":80", nil)
}

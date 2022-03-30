package main

import (
	"log"
	"net/http"
)

func serve1() {
	http.HandleFunc("/register", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		user := r.Form.Get("user")
		pw := r.Form.Get("password")

		log.Printf("Registering new user %s.\n", user)

		// ...
		use(pw)
	})
	http.ListenAndServe(":80", nil)
}

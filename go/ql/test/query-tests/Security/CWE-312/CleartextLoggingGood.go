package main

import (
	"log"
	"net/http"
	"strings"
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

func serveauth() {
	http.HandleFunc("/register", func(w http.ResponseWriter, r *http.Request) {
		authhdr := r.Header.Get("authorization")
		fields := strings.Split(authhdr, " ")

		log.Printf("Auth method is %s.\n", fields[0])

		tokenparts := strings.Split(fields[1], ":")
		log.Printf("Username is %s.\n", tokenparts[0])

		// ...
		use(tokenparts[1])
	})
	http.ListenAndServe(":80", nil)
}

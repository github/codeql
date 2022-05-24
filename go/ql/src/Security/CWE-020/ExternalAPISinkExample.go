package main

import (
	"fmt"
	"net/http"
)

func serve() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		username := r.Form.Get("username")
		if !isValidUsername(username) {
			// BAD: a request parameter is incorporated without validation into the response
			fmt.Fprintf(w, "%q is an unknown user", username)
		} else {
			// TODO: Handle successful login
		}
	})
	http.ListenAndServe(":80", nil)
}

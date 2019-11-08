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
			fmt.Fprintf(w, "Unknown user: %q", username)
		} else {
			// TODO: do something exciting
		}
	})
	http.ListenAndServe(":80", nil)
}

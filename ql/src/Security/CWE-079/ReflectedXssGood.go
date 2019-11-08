package main

import (
	"fmt"
	"html"
	"net/http"
)

func serve1() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		username := r.Form.Get("username")
		if !isValidUsername(username) {
			// BAD: a request parameter is incorporated without validation into the response
			fmt.Fprintf(w, "Unknown user: %q", html.EscapeString(username))
		} else {
			// TODO: do something exciting
		}
	})
	http.ListenAndServe(":80", nil)
}

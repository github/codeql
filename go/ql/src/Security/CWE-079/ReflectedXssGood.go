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
			// GOOD: a request parameter is escaped before being put into the response
			fmt.Fprintf(w, "%q is an unknown user", html.EscapeString(username))
		} else {
			// TODO: do something exciting
		}
	})
	http.ListenAndServe(":80", nil)
}

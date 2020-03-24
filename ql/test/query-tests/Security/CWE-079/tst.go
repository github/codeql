package main

import (
	"net/http"
	"strings"
)

func serve6() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		username := r.Form.Get("username")
		if !isValidUsername(username) {
			// BAD: a request parameter is incorporated without validation into the response
			a := []string{username, "is", "an", "unknown", "user"}
			w.Write([]byte(strings.Join(a, " ")))
		} else {
			// TODO: do something exciting
		}
	})
	http.ListenAndServe(":80", nil)
}

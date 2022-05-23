package main

import (
	"net/http"
	"net/url"
)

func serve() {
	http.HandleFunc("/redir", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		target, err := url.Parse(r.Form.Get("target"))
		if err != nil {
			// ...
		}

		if target.Hostname() == "semmle.com" {
			// GOOD: checking hostname
			http.Redirect(w, r, target.String(), 302)
		} else {
			http.WriteHeader(400)
		}
	})
}

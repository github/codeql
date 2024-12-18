package main

import (
	"net/http"
	"net/url"
	"strings"
)

func serve1() {
	http.HandleFunc("/redir", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		targetUrl := r.Form.Get("target")
		// replace all backslashes with forward slashes before parsing the URL
		targetUrl = strings.ReplaceAll(targetUrl, "\\", "/")

		target, err := url.Parse(targetUrl)
		if err != nil {
			// ...
		}

		if target.Hostname() == "" {
			// GOOD: check that it is a local redirect
			http.Redirect(w, r, target.String(), 302)
		} else {
			w.WriteHeader(400)
		}
	})
}

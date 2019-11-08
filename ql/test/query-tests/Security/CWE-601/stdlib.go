package main

import (
	"net/http"
	"regexp"
)

func serveStdlib() {
	http.HandleFunc("/ex", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// BAD: a request parameter is incorporated without validation into a URL redirect
		w.Header().Set("Location", target)
		w.WriteHeader(302)
	})

	http.HandleFunc("/ex1", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// Probably OK because the status is set to 500, but we catch it anyway
		w.Header().Set("Location", target)
		w.WriteHeader(500)
	})

	http.HandleFunc("/ex2", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// GOOD: local redirects are unproblematic
		w.Header().Set("Location", "/local"+target)
		// BAD: this could be a non-local redirect
		w.Header().Set("Location", "/"+target)
		// GOOD: localhost redirects are unproblematic
		w.Header().Set("Location", "//localhost/"+target)
		w.WriteHeader(302)
	})

	http.HandleFunc("/ex3", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// BAD: using the utility function
		http.Redirect(w, r, target, 301)
	})

	http.HandleFunc("/ex4", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// GOOD: comparison against known URLs
		if target == "semmle.com" {
			http.Redirect(w, r, target, 301)
		} else {
			w.WriteHeader(400)
		}
	})

	http.HandleFunc("/ex5", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		me := "me"
		// BAD: may be a global redirection
		http.Redirect(w, r, target+"?from="+me, 301)
	})

	http.HandleFunc("/ex6", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// GOOD: request parameter is embedded in query string
		http.Redirect(w, r, someUrl()+"?target="+target, 301)
	})

	http.HandleFunc("/ex7", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// GOOD: request parameter is embedded in hash
		http.Redirect(w, r, someUrl()+(HASH+target), 302)
	})

	http.HandleFunc("/ex7", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		target += "/index.html"
		// BAD
		http.Redirect(w, r, target, 302)
	})

	http.HandleFunc("/ex7", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// GOOD: request parameter is checked against a regexp
		if ok, _ := regexp.MatchString("", target); ok {
			http.Redirect(w, r, target, 302)
		} else {
			w.WriteHeader(400)
		}
	})

	http.ListenAndServe(":80", nil)
}

package main

import (
	"net/http"
)

func serve2() {
	http.HandleFunc("/echo", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		data := r.Form.Get("data")

		// Not OK; direct flow from request body to output.
		// The response Content-Type header is derived from a call to
		// `http.DetectContentType`, which can be easily manipulated into returning
		// `text/html` for XSS.
		w.Write([]byte(data))
	})
	http.ListenAndServe(":80", nil)
}

func serve3() {
	http.HandleFunc("/echo", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		data := r.Form.Get("data")

		w.Header().Set("Content-Type", "text/plain")

		w.Write([]byte(data)) // OK; no script can be executed from a `text/plain` context.

		w.Header().Set("X-My-Custom-Header", data) // OK; injecting headers is not usually dangerous
	})
	http.ListenAndServe(":80", nil)
}

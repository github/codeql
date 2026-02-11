package main

import (
	"fmt"
	"net/http"
)

func serve2() {
	http.HandleFunc("/echo", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		data := r.Form.Get("data") // $ Source[go/reflected-xss]

		// Not OK; direct flow from request body to output.
		// The response Content-Type header is derived from a call to
		// `http.DetectContentType`, which can be easily manipulated into returning
		// `text/html` for XSS.
		w.Write([]byte(data)) // $ Alert[go/reflected-xss]
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

func serve4() {
	http.HandleFunc("/echo", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		data := r.Form.Get("data")

		fmt.Fprintf(w, "Constant: %s", data) // OK; the prefix causes the content type header to be text/plain
	})
	http.ListenAndServe(":80", nil)
}

func serve5() {
	http.HandleFunc("/echo", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		data := r.Form.Get("data") // $ Source[go/reflected-xss]

		w.Header().Set("Content-Type", "text/html")

		fmt.Fprintf(w, "Constant: %s", data) // $ Alert[go/reflected-xss] // The content-type header is explicitly set to html
	})
	http.ListenAndServe(":80", nil)
}

func serve10() {
	http.HandleFunc("/echo", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		data := r.Form.Get("data")

		data = r.FormValue("data")                             // $ Source[go/reflected-xss]
		fmt.Fprintf(w, "\t<html><body>%s</body></html>", data) // $ Alert[go/reflected-xss]
	})
}

func serve11() {
	http.HandleFunc("/echo", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		data := r.Form.Get("data")

		data = r.FormValue("data") // $ Source[go/reflected-xss]
		fmt.Fprintf(w, `
<html>
  <body>
    %s
  </body>
</html>`, data) // $ Alert[go/reflected-xss]
	})
}

func serve12() {
	http.HandleFunc("/echo", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		data := r.Form.Get("data")

		data = r.FormValue("data") // $ Source[go/reflected-xss]
		fmt.Fprintf(w, `
    %s
`, data) // $ Alert[go/reflected-xss]
	})
}

func serve13() {
	http.HandleFunc("/echo", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		data := r.Form.Get("data")

		data = r.FormValue("data")
		fmt.Fprintf(w, `
Echoed:
%s
`, data) // OK
	})
}

func serve14() {
	http.HandleFunc("/echo", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		data := r.Form.Get("data")

		data = r.FormValue("data")                           // $ Source[go/reflected-xss]
		fmt.Fprintf(w, "<html><body>%s</body></html>", data) // $ Alert[go/reflected-xss]
	})
}

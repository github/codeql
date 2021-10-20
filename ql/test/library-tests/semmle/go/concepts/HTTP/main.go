package main

import (
	"bytes"
	"fmt"
	"html"
	"io"
	"io/ioutil"
	"net/http"
)

const LOC_HEADER = "Location"

func use(xs ...interface{}) {}

func handler(w http.ResponseWriter, r *http.Request) {
	rfs1 := r.Body
	rfs2 := r.Form
	rfs3 := r.Header
	rfs4 := r.URL
	use(rfs1, rfs2, rfs3, rfs4)

	r2 := *r
	rfs5 := r2.Body
	rfs6 := r2.Form
	rfs7 := r2.Header
	rfs8 := r2.URL
	use(rfs5, rfs6, rfs7, rfs8)

	w.WriteHeader(418)
	head := w.Header()
	head.Set("Authorization", "Basic example:example")
	head.Add("Age", "342232")
	server := "Server"
	head.Add(server, fmt.Sprintf("Server: %s", "example"))
	head.Set(LOC_HEADER, rfs4.String()+"/redir")
	head["Unknown-Header"] = []string{"Some value!"}

	w.Write([]byte("Some more body text\n"))

	io.WriteString(w, "Body text")
}

func main() {
	body := bytes.NewBufferString("My request HTTP body")

	req, _ := http.NewRequest("GET", "https://semmle.com", nil)
	// These are currently flagged as user controlled
	req.Header.Add("Not-A-Response", "Header")
	req.Header.Set("Accept", "nota/response")
	req.Header["Accept-Charset"] = []string{"utf-8, iso-8859-1;q=0.5"}

	req.Body = ioutil.NopCloser(body)

	http.DefaultClient.Do(req)

	resp, _ := http.Get("https://example.com")
	resp.Header.Set("This-Makes", "No sense")

	http.HandleFunc("/foo", handler) // $ handler="/foo"

	http.HandleFunc("/bar", func(w http.ResponseWriter, r *http.Request) { // $ handler="/bar"
		fmt.Fprintf(w, "Hello, %q", html.EscapeString(r.URL.Path))
	})
}

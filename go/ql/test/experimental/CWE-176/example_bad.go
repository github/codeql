package main

import (
	"fmt"
	"html"
	"net/http"

	"golang.org/x/text/unicode/norm"
)

func main() {}

func bad() {
	http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {

		unicode_input := req.URL.Query().Get("unicode_input")
		escaped := html.EscapeString(unicode_input)
		unicode_norm := norm.NFKC.String(escaped) // $result=BAD
		fmt.Println(w, "Results: %q", unicode_norm)
	})
}

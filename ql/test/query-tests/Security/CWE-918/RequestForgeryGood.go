package main

import (
	"net/http"
)

func handler1(w http.ResponseWriter, req *http.Request) {
	target := req.FormValue("target")

	var subdomain string
	if target == "EU" {
		subdomain = "europe"
	} else {
		subdomain = "world"
	}

	// GOOD: `subdomain` is controlled by the server
	resp, err := http.Get("https://" + subdomain + ".example.com/data/")
	if err != nil {
		// error handling
	}

	// process request response
	use(resp)
}

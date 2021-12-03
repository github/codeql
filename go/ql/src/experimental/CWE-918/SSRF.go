package main

import (
	"net/http"
)

func handler(w http.ResponseWriter, req *http.Request) {
	target := req.FormValue("target")

	// BAD: `target` is controlled by the attacker
	resp, err := http.Get("https://example.com/current_api/" + target)
	if err != nil {
		// error handling
	}

	// process request response
	use(resp)
}

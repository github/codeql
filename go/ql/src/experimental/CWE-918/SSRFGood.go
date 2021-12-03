package main

import (
	"github.com/go-playground/validator"
	"net/http"
)

func goodHandler(w http.ResponseWriter, req *http.Request) {
	validate := validator.New()
	target := req.FormValue("target")
	if validate.Var(target, "alphanum") == nil {
		// GOOD: `target` is alphanumeric
		resp, err := http.Get("https://example.com/current_api/" + target)
		if err != nil {
			// error handling
		}
		// process request response
		use(resp)
	}
}

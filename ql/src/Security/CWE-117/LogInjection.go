package main

import (
	"log"
	"net/http"
)

// BAD: A user-provided value is written directly to a log.
func handler(req *http.Request) {
	username := req.URL.Query()["username"][0]
	log.Printf("user %s logged in.\n", username)
}

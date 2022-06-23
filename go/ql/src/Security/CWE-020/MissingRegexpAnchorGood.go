package main

import (
	"errors"
	"net/http"
	"regexp"
)

func checkRedirect2Good(req *http.Request, via []*http.Request) error {
	// GOOD: the host of `req.URL` cannot be controlled by an attacker
	re := "^https?://www\\.example\\.com/"
	if matched, _ := regexp.MatchString(re, req.URL.String()); matched {
		return nil
	}
	return errors.New("Invalid redirect")
}

package main

import (
	"errors"
	"net/http"
	"regexp"
)

func checkRedirect2(req *http.Request, via []*http.Request) error {
	// BAD: the host of `req.URL` may be controlled by an attacker
	re := "https?://www\\.example\\.com/"
	if matched, _ := regexp.MatchString(re, req.URL.String()); matched {
		return nil
	}
	return errors.New("Invalid redirect")
}

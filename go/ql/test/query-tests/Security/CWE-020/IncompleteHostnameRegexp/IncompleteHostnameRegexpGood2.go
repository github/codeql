package main

import (
	"errors"
	"net/http"
	"regexp"
)

func checkRedirectGood2(req *http.Request, via []*http.Request) error {
	// GOOD: the host of `req.URL` must be `example.com`, `www.example.com` or `beta.example.com`
	re := `^((www|beta)\.)?example\.com/`
	if matched, _ := regexp.MatchString(re, req.URL.Host); matched {
		return nil
	}
	return errors.New("Invalid redirect")
}

package main

import (
    "errors"
    "regexp"
    "net/http"
)

func checkRedirectGood(req *http.Request, via []*http.Request) error {
    // GOOD: the host of `url` must be `example.com`, `www.example.com` or `beta.example.com`
    re := "^((www|beta)\\.)?example.com/"
    if matched, _ := regexp.MatchString(re, req.URL.Host); matched {
        return nil
    }
    return errors.New("Invalid redirect")
}

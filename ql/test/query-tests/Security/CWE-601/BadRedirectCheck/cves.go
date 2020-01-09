package main

import (
	"net/http"
	"strings"
)

// CVE-2018-15178
// Code from github.com/gogs/gogs
func isValidRedirect(url string) bool {
	return len(url) >= 2 && url[0] == '/' && url[1] != '/' // NOT OK
}

func isValidRedirect1(url string) bool {
	return len(url) >= 2 && url[0] == '/' && url[1] != '/' && url[1] != '\\' // OK
}

// CVE-2017-1000070 (both vulnerable!)
// Code from github.com/bitly/oauth2_proxy
func OAuthCallback(rw http.ResponseWriter, req *http.Request) {
	redirect := req.Form.Get("state")
	if !strings.HasPrefix(redirect, "/") { // NOT OK
		redirect = "/"
	}
}

func OAuthCallback1(rw http.ResponseWriter, req *http.Request) {
	redirect := req.Form.Get("state")
	if !strings.HasPrefix(redirect, "/") || strings.HasPrefix(redirect, "//") { // NOT OK
		redirect = "/"
	}
}

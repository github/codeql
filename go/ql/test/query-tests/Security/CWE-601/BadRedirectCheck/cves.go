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

func alsoABadRedirect(url string, rw http.ResponseWriter, req *http.Request) {
	if isValidRedirect(url) {
		http.Redirect(rw, req, url, 302)
	}
}

func isValidRedirectGood(url string) bool {
	return len(url) >= 2 && url[0] == '/' && url[1] != '/' && url[1] != '\\' // OK
}

func alsoAGoodRedirect(url string, rw http.ResponseWriter, req *http.Request) {
	if isValidRedirectGood(url) {
		http.Redirect(rw, req, url, 302)
	}
}

// CVE-2017-1000070 (both vulnerable!)
// Code from github.com/bitly/oauth2_proxy
func OAuthCallback(rw http.ResponseWriter, req *http.Request) {
	redirect := req.Form.Get("state")
	if !strings.HasPrefix(redirect, "/") { // NOT OK
		redirect = "/"
	}
	http.Redirect(rw, req, redirect, 302)
}

func OAuthCallback1(rw http.ResponseWriter, req *http.Request) {
	redirect := req.Form.Get("state")
	if !strings.HasPrefix(redirect, "/") || strings.HasPrefix(redirect, "//") { // NOT OK
		redirect = "/"
	}
	http.Redirect(rw, req, redirect, 302)
}

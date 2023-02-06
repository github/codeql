package main

import (
	"net/http"
	"net/url"
	"path"
	"strings"
)

func badRedirect(redirect string, rw http.ResponseWriter, req *http.Request) {
	http.Redirect(rw, req, sanitizeUrl(redirect), 302)
}

func goodRedirect(redirect string, rw http.ResponseWriter, req *http.Request) {
	http.Redirect(rw, req, sanitizeUrlGood(redirect), 302)
}

func goodRedirect2(url string, rw http.ResponseWriter, req *http.Request) {
	http.Redirect(rw, req, path.Join("/", sanitizeUrl(url)), 302)
}

func isValidRedir(redirect string) bool {
	switch {
	// Not OK: does not check for '/\'
	case strings.HasPrefix(redirect, "/") && !strings.HasPrefix(redirect, "//"):
		return true
	default:
		return false
	}
}

func alsoABadRedirect1(url string, rw http.ResponseWriter, req *http.Request) {
	if isValidRedir(url) {
		http.Redirect(rw, req, url, 302)
	}
}

func isValidRedir1(redirect string) bool {
	switch {
	// OK
	case strings.HasPrefix(redirect, "/") && !strings.HasPrefix(redirect, "//") && !strings.HasPrefix(redirect, "/\\"):
		return true
	default:
		return false
	}
}

func goodRedirect3(url string, rw http.ResponseWriter, req *http.Request) {
	if isValidRedirectGood(url) {
		http.Redirect(rw, req, url, 302)
	}
}

func getTarget(redirect string) string {
	u, _ := url.Parse(redirect)

	if u.Path[0] != '/' {
		return "/"
	}

	return path.Clean(u.Path)
}

func goodRedirect4(url string, rw http.ResponseWriter, req *http.Request) {
	http.Redirect(rw, req, getTarget(url), 302)
}

func getTarget1(redirect string) string {
	if redirect[0] != '/' {
		return "/"
	}

	return path.Clean(redirect)
}

func badRedirect1(url string, rw http.ResponseWriter, req *http.Request) {
	http.Redirect(rw, req, getTarget1(url), 302)
}

func getTarget2(redirect string) string {
	u, _ := url.Parse(redirect)

	if u.Path[0] != '/' {
		return "/"
	}

	return u.Path
}

func badRedirect2(url string, rw http.ResponseWriter, req *http.Request) {
	http.Redirect(rw, req, getTarget2(url), 302)
}

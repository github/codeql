package main

import "net/url"

func sanitizeUrl(urlstr string) string {
	u, err := url.Parse(urlstr)
	if err != nil || u.Scheme == "javascript" { // $ Alert
		return "about:blank"
	}
	return urlstr
}

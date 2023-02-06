package main

import "net/url"

func sanitizeUrlGod(urlstr string) string {
	u, err := url.Parse(urlstr)
	if err != nil || u.Scheme == "javascript" || u.Scheme == "data" || u.Scheme == "vbscript" {
		return "about:blank"
	}
	return urlstr
}

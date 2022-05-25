package main

import (
	"net/url"
	"strings"
)

func test(urlstr string) {
	u, _ := url.Parse(urlstr)
	sch := u.Scheme
	if sch == "javascript" || u.Scheme == "data" || sch == "vbscript" { // OK
		return
	}

	urlstr = strings.NewReplacer("\n", "", "\r", "", "\t", "", "\u0000", "").Replace(urlstr)
	urlstr = strings.ToLower(urlstr)
	if strings.HasPrefix(urlstr, "javascript:") || strings.HasPrefix(urlstr, "data:") { // NOT OK
		return
	}
}

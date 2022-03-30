package main

import (
	"fmt"
	"net/url"
)

func func5(b bool, s string) string {
	var res string
	var err error
	if b {
		res, err = url.PathUnescape(url.PathEscape(s))
	} else {
		res, err = url.QueryUnescape(url.QueryEscape(s))
	}
	if err != nil {
		return ""
	}
	return res
}

func func6(i int, s string) *url.URL {
	u, _ := url.Parse(s)
	if i == 0 {
		return u
	}
	u, _ = url.ParseRequestURI(s)
	fmt.Println(u.EscapedPath())
	fmt.Println(u.Hostname())
	bs, _ := u.MarshalBinary()
	fmt.Println(bs)
	u, _ = u.Parse("/foo")
	fmt.Println(u.Port())
	fmt.Println(u.Query())
	fmt.Println(u.RequestURI())
	u = u.ResolveReference(u)
	return u
}

func func7() *url.Userinfo {
	ui := url.User("me")
	ui = url.UserPassword("me", "secret")
	pw, _ := ui.Password()
	fmt.Println(pw)
	fmt.Println(ui.Username())
	return ui
}

func func8(q string) url.Values {
	v, _ := url.ParseQuery(q)
	fmt.Println(v.Encode())
	fmt.Println(v.Get("page"))
	return v
}

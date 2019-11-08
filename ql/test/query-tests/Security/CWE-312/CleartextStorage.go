package main

import (
	"net/http"
)

func serve2() {
	http.HandleFunc("/register", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		user := r.Form.Get("user")
		pw := r.Form.Get("password")

		userdb.Store(user, pw)

		var pwCookie http.Cookie
		pwCookie.Name = "password"
		pwCookie.Value = pw
		http.SetCookie(w, &pwCookie)
	})
	http.ListenAndServe(":80", nil)
}

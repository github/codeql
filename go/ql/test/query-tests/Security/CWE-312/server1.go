package main

import (
	"log"
	"net/http"
)

func serve2() {
	http.HandleFunc("/some/path", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		logStrs(r.Form.Get("password"))

		vals := r.URL.Query()
		logStrs(vals["password"]...)

		var user3 = passStruct{
			password: encryptLib.encryptPassword(r.Form.Get("password")),
		}
		log.Println(user3) // OK

		temp := encryptedStruct{encryptedPassword: r.Form.Get("password")}
		log.Println(temp.encryptedPassword) // OK
	})
}

func logStrs(x ...string) {
	s := make([]interface{}, len(x))
	for i, v := range x {
		s[i] = v
	}
	log.Println(s...)
}

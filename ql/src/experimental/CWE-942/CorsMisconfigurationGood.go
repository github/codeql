package main

import "net/http"

func good1() {
	http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
		// OK-ish: the `Access-Control-Allow-Origin` header is set using a user-defined value,
		// BUT `Access-Control-Allow-Credentials` is set to 'false':
		origin := req.Header.Get("origin")
		w.Header().Set("Access-Control-Allow-Origin", origin)
		w.Header().Set("Access-Control-Allow-Credentials", "false")
	})
}

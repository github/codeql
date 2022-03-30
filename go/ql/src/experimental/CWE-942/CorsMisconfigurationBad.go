package main

import "net/http"

func main() {}

func bad1() {
	http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
		// BAD: 'null' origin is allowed,
		// and Access-Control-Allow-Credentials is set to 'true'.
		w.Header().Set("Access-Control-Allow-Origin", "null")
		w.Header().Set("Access-Control-Allow-Credentials", "true")
	})
}

func bad2() {
	http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
		// BAD: the `Access-Control-Allow-Origin` header is set using a user-defined value,
		// and `Access-Control-Allow-Credentials` is set to 'true':
		origin := req.Header.Get("origin")
		w.Header().Set("Access-Control-Allow-Origin", origin)
		w.Header().Set("Access-Control-Allow-Credentials", "true")
	})
}

package main

import "net/http"

// good1 is an example of a good implementation
func good1() {
	http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
		// OK-ish: all origins are allowed,
		// but Access-Control-Allow-Credentials is not set.
		w.Header().Set("Access-Control-Allow-Origin", "*")
	})
}

func good2() {
	http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
		// OK-ish: all origins are allowed,
		// and some write methods are allowed,
		// BUT `Access-Control-Allow-Credentials` is not set:
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET,POST,PUT")
	})
}

func good3() {
	http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
		// OK-ish: the `Access-Control-Allow-Origin` header is set using a user-defined value,
		// BUT `Access-Control-Allow-Credentials` is set to 'false':
		origin := req.Header.Get("origin")
		w.Header().Set("Access-Control-Allow-Origin", origin)
		w.Header().Set("Access-Control-Allow-Credentials", "false")
	})
}

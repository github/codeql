package main

import "net/http"

const (
	HeaderAllowOrigin      = "Access-Control-Allow-Origin"
	HeaderAllowCredentials = "Access-Control-Allow-Credentials"
)

func main() {
	{
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// BAD: all origins are allowed,
			// and Access-Control-Allow-Credentials is set to 'true'.
			w.Header().Set("Access-Control-Allow-Origin", "*")
			w.Header().Set("Access-Control-Allow-Credentials", "true")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// BAD: all origins are allowed,
			// and `Access-Control-Allow-Credentials` is set to 'true':
			w.Header().Set(HeaderAllowOrigin, "*")
			w.Header().Set("Access-Control-Allow-Credentials", "true")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK: all origins are allowed,
			// but Access-Control-Allow-Credentials is set to 'false'.
			w.Header().Set("Access-Control-Allow-Origin", "*")
			w.Header().Set("Access-Control-Allow-Credentials", "false")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK: all origins are allowed,
			// but Access-Control-Allow-Credentials is not set.
			w.Header().Set("Access-Control-Allow-Origin", "*")
		})
	}
	{
		const Null = "null"
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// BAD: 'null' origin is allowed,
			// and Access-Control-Allow-Credentials is set to 'true'.
			w.Header().Set("Access-Control-Allow-Origin", "null")
			w.Header().Set("Access-Control-Allow-Credentials", "true")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// BAD: 'null' origin is allowed,
			// and `Access-Control-Allow-Credentials` is set to 'true':
			w.Header().Set(HeaderAllowOrigin, Null)
			w.Header().Set("Access-Control-Allow-Credentials", "true")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK: 'null' origin is allowed,
			// but Access-Control-Allow-Credentials is set to 'false'.
			w.Header().Set("Access-Control-Allow-Origin", Null)
			w.Header().Set("Access-Control-Allow-Credentials", "false")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK: 'null' origin is allowed,
			// but Access-Control-Allow-Credentials is not set.
			w.Header().Set("Access-Control-Allow-Origin", Null)
		})
	}

	{
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// BAD: all origins are allowed,
			// and some write methods are allowed,
			// and `Access-Control-Allow-Credentials` is set to 'true':
			w.Header().Set("Access-Control-Allow-Origin", "*")
			w.Header().Set("Access-Control-Allow-Methods", "GET,POST,PUT")
			w.Header().Set("Access-Control-Allow-Credentials", "true")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK: all origins are allowed,
			// and some write methods are allowed,
			// BUT `Access-Control-Allow-Credentials` is not set:
			w.Header().Set("Access-Control-Allow-Origin", "*")
			w.Header().Set("Access-Control-Allow-Methods", "GET,POST,PUT")
		})
	}

	{
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// BAD: the `Access-Control-Allow-Origin` header is set using a user-defined value,
			// and `Access-Control-Allow-Credentials` is set to 'true':
			origin := req.Header.Get("origin")
			w.Header().Set(HeaderAllowOrigin, origin)
			w.Header().Set("Access-Control-Allow-Credentials", "true")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// BAD: the `Access-Control-Allow-Origin` header is set using a user-defined value,
			// and `Access-Control-Allow-Credentials` is set to 'true':
			origin := req.Header.Get("origin")
			w.Header().Set("Access-Control-Allow-Origin", origin)
			w.Header().Set(HeaderAllowCredentials, "true")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK-ish: the `Access-Control-Allow-Origin` header is set using a user-defined value,
			// BUT `Access-Control-Allow-Credentials` is set to 'false':
			origin := req.Header.Get("origin")
			w.Header().Set("Access-Control-Allow-Origin", origin)
			w.Header().Set("Access-Control-Allow-Credentials", "false")
		})
		http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
			// OK-ish: the `Access-Control-Allow-Origin` header is set using a user-defined value,
			// BUT `Access-Control-Allow-Credentials` is not set:
			origin := req.Header.Get("origin")
			w.Header().Set("Access-Control-Allow-Origin", origin)
		})
	}
}

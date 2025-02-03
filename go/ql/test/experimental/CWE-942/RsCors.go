package main

import (
	"net/http"

	"github.com/rs/cors"
)

func rs_vulnerable1() {
	c := cors.New(cors.Options{
		AllowedOrigins:   []string{"null", "http://foo.com:8080"}, // $ Alert
		AllowCredentials: true,
		// Enable Debugging for testing, consider disabling in production
		Debug: true,
	})

	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.Write([]byte("{\"hello\": \"world\"}"))
	})

	http.ListenAndServe(":8080", c.Handler(handler))
}

func rs_vulnerable2() {
	opt := cors.Options{
		AllowCredentials: true,
		// Enable Debugging for testing, consider disabling in production
		Debug: true,
	}
	opt.AllowedOrigins = []string{"null", "http://foo.com:8080"} // $ Alert
	c := cors.New(opt)

	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.Write([]byte("{\"hello\": \"world\"}"))
	})

	http.ListenAndServe(":8080", c.Handler(handler))
}

func rs_safe() {
	c := cors.New(cors.Options{
		AllowedOrigins:   []string{"http://foo.com:8080"}, // GOOD
		AllowCredentials: true,
		// Enable Debugging for testing, consider disabling in production
		Debug: true,
	})

	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.Write([]byte("{\"hello\": \"world\"}"))
	})

	http.ListenAndServe(":8080", c.Handler(handler))
}

var globalCorsOptions1 = cors.Options{
	AllowedOrigins:   []string{"null", "http://foo.com:8080"}, // $ Alert
	AllowCredentials: true,
	// Enable Debugging for testing, consider disabling in production
	Debug: true,
}

func rs_vulnerable_global1() {
	c := cors.New(globalCorsOptions1)

	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.Write([]byte("{\"hello\": \"world\"}"))
	})

	http.ListenAndServe(":8080", c.Handler(handler))

}

var globalCorsOptions2 cors.Options

func rs_vulnerable_global2() {
	globalCorsOptions2.AllowedOrigins = []string{"null", "http://foo.com:8080"} // $ MISSING: Alert
	globalCorsOptions2.AllowCredentials = true
	// Enable Debugging for testing, consider disabling in production
	globalCorsOptions2.Debug = true
	c := cors.New(globalCorsOptions1)

	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.Write([]byte("{\"hello\": \"world\"}"))
	})

	http.ListenAndServe(":8080", c.Handler(handler))

}

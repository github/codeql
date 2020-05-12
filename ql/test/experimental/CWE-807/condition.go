package main

import (
	"io"
	"net/http"
)

func use(xs ...interface{})      {}
func t(xs ...interface{}) string { return "sadsad" }
func login(xs ...interface{})    {}

const test = "localhost"

// Should alert as authkey is sensitive
func ex1(w http.ResponseWriter, r *http.Request) {
	if r.Header.Get("Origin") != test {
		authkey := "randomDatta"
		io.WriteString(w, authkey)
	}
}

// Should alert as authkey is sensitive
func ex2(w http.ResponseWriter, r *http.Request) {
	test2 := "test"
	if r.Header.Get("Origin") != test2 {
		authkey := "randomDatta2"
		io.WriteString(w, authkey)
	}
}

// Should alert as login() is sensitive
func ex3(w http.ResponseWriter, r *http.Request) {
	test2 := "test"
	if r.Header.Get("Origin") != test2 {
		login()
	}
}

// no alert as we can't say if the rhs resolves to a fixed pattern everytime.
func ex4(w http.ResponseWriter, r *http.Request) {
	if r.Header.Get("Origin") != t()+r.Header.Get("Origin") {
		login()
	}
}

// No alert as use is not sensitive
func ex5(w http.ResponseWriter, r *http.Request) {
	test2 := "test"
	if r.Header.Get("Origin") != test2 {
		use()
	}
}

// Should not alert as test is against empty string
func ex6(w http.ResponseWriter, r *http.Request) {
	if r.Header.Get("Origin") != "" {
		login()
	}
}

// Should not alert as test is against uri path
func ex7(w http.ResponseWriter, r *http.Request) {
	if r.Header.Get("Origin") != "/asd/" {
		login()
	}
}

// Should not alert as test is against uri path
func ex8(w http.ResponseWriter, r *http.Request) {
	if r.Header.Get("Origin") != "/asd/a" {
		login()
	}
}

// Should not alert as test is against uri path
func ex9(w http.ResponseWriter, r *http.Request) {
	if r.Header.Get("Origin") != "/asd" {
		login()
	}
}

// Should not alert as test is against uri path
func ex10(w http.ResponseWriter, r *http.Request) {
	if r.Header.Get("Origin") != "asd/" {
		login()
	}
}

func main() {}

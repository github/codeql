package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strings"
)

func serve6() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		username := r.Form.Get("username")
		if !isValidUsername(username) {
			// BAD: a request parameter is incorporated without validation into the response
			a := []string{username, "is", "an", "unknown", "user"}
			w.Write([]byte(strings.Join(a, " ")))
		} else {
			// TODO: do something exciting
		}
	})
	http.ListenAndServe(":80", nil)
}

type User struct {
	name string
}

func serve7() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		username := r.Form.Get("username")
		if !isValidUsername(username) {
			// OK: json data cannot cause an HTML content type to be detected
			a, _ := json.Marshal(User{username})
			w.Write(a)
		} else {
			// TODO: do something exciting
		}
	})
	http.ListenAndServe(":80", nil)
}

func serve8() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		service := r.Form.Get("service")
		if service != "service1" && service != "service2" {
			fmt.Fprintln(w, "Service not found")
		} else {
			// OK (service is known to be either "service1" or "service2" here), but currently flagged
			w.Write([]byte(service))
		}
	})
}

type mix struct {
	io.Writer
	http.ResponseWriter
}

func serve9(log io.Writer) {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		username := r.Form.Get("username")
		// OK: not a ResponseWriter
		log.Write([]byte(username))
	})
	http.ListenAndServe(":80", nil)
}

func main() {}

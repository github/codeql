package main

import (
	"encoding/json"
	"fmt"
	"net/http"
)

func serve() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		username := r.Form.Get("username")
		if !isValidUsername(username) {
			// BAD: a request parameter is incorporated without validation into the response
			fmt.Fprintf(w, "%q is an unknown user", username)
		} else {
			// TODO: do something exciting
		}
	})
	http.ListenAndServe(":80", nil)
}

func encode(s string) ([]byte, error) {

	return json.Marshal(s)

}

func ServeJsonIndirect(w http.ResponseWriter, r http.Request) {

	tainted := r.Header.Get("Origin")
	noLongerTainted, _ := encode(tainted)
	w.Write(noLongerTainted)

}

func ServeJsonDirect(w http.ResponseWriter, r http.Request) {

	tainted := r.Header.Get("Origin")
	noLongerTainted, _ := json.Marshal(tainted)
	w.Write(noLongerTainted)

}

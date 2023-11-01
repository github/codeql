package main

import (
	"fmt"
	"html"
	"html/template"
	"net/http"
)

func serve1() {
	var template template.Template

	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		username := r.Form.Get("username")
		if !isValidUsername(username) {
			// GOOD: a request parameter is escaped before being put into the response
			fmt.Fprintf(w, "%q is an unknown user", html.EscapeString(username))
			// GOOD: using html/template escapes values for us
			template.Execute(w, username)
			template.ExecuteTemplate(w, "test", username)
		} else {
			// TODO: do something exciting
		}
	})
	http.ListenAndServe(":80", nil)
}

package main

import (
	"html/template"
	"net/http"
)

func good(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()
	username := r.Form.Get("username")
	tmpl, _ := template.New("test").Parse(`<b>Hi {{.}}</b>`)
	tmpl.Execute(w, username)
}

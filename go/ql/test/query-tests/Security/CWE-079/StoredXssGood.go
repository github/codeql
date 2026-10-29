package main

import (
	"html"
	"html/template"
	"io"
	"net/http"
	"os"
)

func ListFiles1(w http.ResponseWriter, r *http.Request) {
	var template template.Template
	files, _ := os.ReadDir(".")

	for _, file := range files {
		io.WriteString(w, html.EscapeString(file.Name())+"\n")
		template.Execute(w, file.Name())
	}
}

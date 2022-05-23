package main

import (
	"html"
	"io"
	"io/ioutil"
	"net/http"
)

func ListFiles1(w http.ResponseWriter, r *http.Request) {
	files, _ := ioutil.ReadDir(".")

	for _, file := range files {
		io.WriteString(w, html.EscapeString(file.Name())+"\n")
	}
}

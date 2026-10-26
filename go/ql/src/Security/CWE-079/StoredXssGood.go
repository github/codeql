package main

import (
	"html"
	"io"
	"net/http"
	"os"
)

func ListFiles1(w http.ResponseWriter, r *http.Request) {
	files, _ := os.ReadDir(".")

	for _, file := range files {
		io.WriteString(w, html.EscapeString(file.Name())+"\n")
	}
}

package main

import (
	"io"
	"net/http"
	"os"
)

func ListFiles(w http.ResponseWriter, r *http.Request) {
	files, _ := os.ReadDir(".")

	for _, file := range files {
		io.WriteString(w, file.Name()+"\n")
	}
}

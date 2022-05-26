package main

import (
	"io"
	"io/ioutil"
	"net/http"
)

func ListFiles(w http.ResponseWriter, r *http.Request) {
	files, _ := ioutil.ReadDir(".")

	for _, file := range files {
		io.WriteString(w, file.Name()+"\n")
	}
}

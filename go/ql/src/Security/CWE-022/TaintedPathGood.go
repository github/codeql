package main

import (
	"io/ioutil"
	"net/http"
	"path/filepath"
	"strings"
)

func handler(w http.ResponseWriter, r *http.Request) {
	path := r.URL.Query()["path"][0]

	// GOOD: ensure that the filename has no path separators or parent directory references
	if strings.Contains(path, "/") || strings.Contains(path, "\\") || strings.Contains(path, "..") {
		http.Error(w, "Invalid file name", http.StatusBadRequest)
		return
	}
	data, _ := ioutil.ReadFile(filepath.Join("/home/user/", path))
	w.Write(data)
}

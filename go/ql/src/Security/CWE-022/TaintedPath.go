package main

import (
	"io/ioutil"
	"net/http"
	"path/filepath"
)

func handler(w http.ResponseWriter, r *http.Request) {
	path := r.URL.Query()["path"][0]

	// BAD: This could read any file on the file system
	data, _ := ioutil.ReadFile(path)
	w.Write(data)

	// BAD: This could still read any file on the file system
	data, _ = ioutil.ReadFile(filepath.Join("/home/user/", path))
	w.Write(data)
}

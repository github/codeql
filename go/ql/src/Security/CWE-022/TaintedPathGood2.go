package main

import (
	"io/ioutil"
	"net/http"
	"path/filepath"
	"strings"
)

const safeDir = "/home/user/"

func handler(w http.ResponseWriter, r *http.Request) {
	path := r.URL.Query()["path"][0]

	// GOOD: ensure that the resolved path is within the safe directory
	absPath, err := filepath.Abs(filepath.Join(safeDir, path))
	if err != nil || !strings.HasPrefix(absPath, safeDir) {
		http.Error(w, "Invalid file name", http.StatusBadRequest)
		return
	}
	data, _ := ioutil.ReadFile(absPath)
	w.Write(data)
}

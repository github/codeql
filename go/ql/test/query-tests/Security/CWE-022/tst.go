package main

import (
	"archive/zip"
	"io/ioutil"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

func uploadFile(w http.ResponseWriter, r *http.Request) {
	file, handler, _ := r.FormFile("file")
	// err handling
	defer file.Close()
	tempFile, _ := ioutil.TempFile("/tmp", handler.Filename) // NOT OK
	use(tempFile)
}

func unzip2(f string, root string) {
	r, _ := zip.OpenReader(f)
	for _, f := range r.File {
		path := f.Name
		relpath, err := filepath.Rel(root, path)
		if err == nil {
			ioutil.WriteFile(filepath.Join(root, relpath), []byte("present"), 0666) // OK
		}
		ioutil.WriteFile(path, []byte("present"), 0666) // NOT OK
		if containedIn(path, root) {
			ioutil.WriteFile(path, []byte("present"), 0666) // OK
		}
		if ok, _ := regexp.MatchString("^[a-z]*$", path); ok {
			ioutil.WriteFile(path, []byte("present"), 0666) // OK
		}
		if !strings.HasPrefix(path, filepath.Clean(root)+string(os.PathSeparator)) {
			panic("Invalid path!")
		}
		ioutil.WriteFile(path, []byte("present"), 0666) // OK
		if containedIn(f.Name, root) {
			ioutil.WriteFile(f.Name, []byte("present"), 0666) // OK
		}
	}
}

func containedIn(f string, root string) bool {
	_, err := filepath.Rel(root, f)
	if err == nil {
		return true
	}
	return false
}

func use(v interface{}) {}

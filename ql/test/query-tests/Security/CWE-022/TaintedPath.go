package main

import (
	"io/ioutil"
	"net/http"
	"path/filepath"
	"regexp"
	"strings"
)

func handler(w http.ResponseWriter, r *http.Request) {
	path := r.URL.Query()["path"][0]

	// BAD: This could read any file on the file system
	data, _ := ioutil.ReadFile(path)
	w.Write(data)

	// BAD: This could still read any file on the file system
	data, _ = ioutil.ReadFile(filepath.Join("/home/user/", path))
	w.Write(data)

	// GOOD: This can only read inside the provided safe path
	sanitized_filepath, _ := filepath.Rel("/home/user/safepath", path)
	data, _ = ioutil.ReadFile(sanitized_filepath)
	w.Write(data)

	// GOOD: This can only read inside the provided safe path
	if !strings.Contains(path, "..") {
		data, _ = ioutil.ReadFile(path)
		w.Write(data)
	}

	// GOOD: This can only read inside the provided safe path
	_, err := filepath.Rel("/home/user/safepath", path)
	if err == nil {
		data, _ = ioutil.ReadFile(path)
		w.Write(data)
	}

	// GOOD: An attempt has been made to ensure that this can only read inside
	// the provided safe path
	if strings.HasPrefix(path, "/home/user/safepath/") {
		data, _ = ioutil.ReadFile(path)
		w.Write(data)
	}

	// GOOD: An attempt has been made to ensure that this can only read inside
	// the provided safe path
	matched, _ := regexp.MatchString("\\.\\.", path)
	if !matched {
		data, _ = ioutil.ReadFile(filepath.Join("/home/user/", path))
		w.Write(data)
	}

	// GOOD: Sanitized by filepath.Clean with a prepended '/' forcing interpretation
	// as an absolute path, so that Clean will throw away any leading `..` components.
	data, _ = ioutil.ReadFile(filepath.Clean("/" + path))
	w.Write(data)
}

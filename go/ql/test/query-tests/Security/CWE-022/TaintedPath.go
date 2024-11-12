package main

import (
	"io/ioutil"
	"mime/multipart"
	"net/http"
	"path"
	"path/filepath"
	"regexp"
	"strings"
)

func handler(w http.ResponseWriter, r *http.Request) {
	tainted_path := r.URL.Query()["path"][0]

	// BAD: This could read any file on the file system
	data, _ := ioutil.ReadFile(tainted_path)
	w.Write(data)

	// BAD: This could still read any file on the file system
	data, _ = ioutil.ReadFile(filepath.Join("/home/user/", tainted_path))
	w.Write(data)

	// GOOD: This can only read inside the provided safe path
	sanitized_filepath, _ := filepath.Rel("/home/user/safepath", tainted_path)
	data, _ = ioutil.ReadFile(sanitized_filepath)
	w.Write(data)

	// GOOD: This can only read inside the provided safe path
	if !strings.Contains(tainted_path, "..") {
		data, _ = ioutil.ReadFile(tainted_path)
		w.Write(data)
	}

	// GOOD: Sanitized by strings.ReplaceAll and replaces all .. with empty string
	data, _ = ioutil.ReadFile(strings.ReplaceAll(tainted_path, "..", ""))
	w.Write(data)

	// GOOD: This can only read inside the provided safe path
	_, err := filepath.Rel("/home/user/safepath", tainted_path)
	if err == nil {
		data, _ = ioutil.ReadFile(tainted_path)
		w.Write(data)
	}

	// GOOD: An attempt has been made to ensure that this can only read inside
	// the provided safe path
	if strings.HasPrefix(tainted_path, "/home/user/safepath/") {
		data, _ = ioutil.ReadFile(tainted_path)
		w.Write(data)
	}

	// GOOD: An attempt has been made to ensure that this can only read inside
	// the provided safe path
	matched, _ := regexp.MatchString("\\.\\.", tainted_path)
	if !matched {
		data, _ = ioutil.ReadFile(filepath.Join("/home/user/", tainted_path))
		w.Write(data)
	}

	// GOOD: Sanitized by filepath.Clean with a prepended '/' forcing interpretation
	// as an absolute path, so that Clean will throw away any leading `..` components.
	data, _ = ioutil.ReadFile(filepath.Clean("/" + tainted_path))
	w.Write(data)

	// BAD: Sanitized by path.Clean with a prepended '/' forcing interpretation
	// as an absolute path, however is not sufficient for Windows paths.
	data, _ = ioutil.ReadFile(path.Clean("/" + tainted_path))
	w.Write(data)

	// GOOD: Multipart.Form.FileHeader.Filename sanitized by filepath.Base when calling ParseMultipartForm
	r.ParseMultipartForm(32 << 20)
	form := r.MultipartForm
	files, ok := form.File["files"]
	if !ok {
		return
	}
	data, _ = ioutil.ReadFile(files[0].Filename)
	w.Write(data)

	// GOOD: Part.FileName sanitized by filepath.Base
	r.ParseMultipartForm(32 << 20)
	file, _, err := r.FormFile("uploadfile")
	if err != nil {
		return
	}
	reader := multipart.NewReader(file, "foo")

	// Read the first part
	part, err := reader.NextPart()
	if err != nil {
		return
	}

	data, _ = ioutil.ReadFile(part.FileName())
}

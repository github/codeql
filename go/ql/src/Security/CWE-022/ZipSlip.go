package main

import (
	"archive/zip"
	"io/ioutil"
	"path/filepath"
)

func unzip(f string) {
	r, _ := zip.OpenReader(f)
	for _, f := range r.File {
		p, _ := filepath.Abs(f.Name)
		// BAD: This could overwrite any file on the file system
		ioutil.WriteFile(p, []byte("present"), 0666)
	}
}

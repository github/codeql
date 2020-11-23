package main

import (
	"archive/zip"
	"io/ioutil"
)

func unzipGood2(f string) {
	r, _ := zip.OpenReader(f)
	for _, f := range r.File {
		// GOOD: file contents should not be flagged for zip slip
		reader, _ := f.Open()
		buf := make([]byte, f.UncompressedSize64)
		reader.Read(buf)
		ioutil.WriteFile("somefile.txt", buf, 0644)
	}
}

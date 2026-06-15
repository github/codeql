package main

import (
	"archive/zip"
	"fmt"
	"io"
	"os"
)

func ZipOpenReader(filename string) {
	// Open the zip file
	r, _ := zip.OpenReader(filename)
	var totalBytes int64
	for _, f := range r.File {
		rc, _ := f.Open()
		totalBytes = 0
		for {
			result, _ := io.CopyN(os.Stdout, rc, 68)
			if result == 0 {
				break
			}
			totalBytes = totalBytes + result
			if totalBytes > 1024*1024 {
				fmt.Print(totalBytes)
				_ = rc.Close()
				break
			}
		}
	}
}

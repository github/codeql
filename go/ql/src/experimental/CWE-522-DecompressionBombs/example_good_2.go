package main

import (
	"compress/gzip"
	"io"
	"os"
)

func safeReader() {
	var src io.Reader
	src, _ = os.Open("filename")
	gzipR, _ := gzip.NewReader(src)
	dstF, _ := os.OpenFile("./test", os.O_RDWR|os.O_CREATE|os.O_TRUNC, 0755)
	defer dstF.Close()
	var newSrc io.Reader
	newSrc = io.LimitReader(gzipR, 1024*1024*1024*5)
	_, _ = io.Copy(dstF, newSrc)
}

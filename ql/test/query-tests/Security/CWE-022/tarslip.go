package main

import (
	"archive/tar"
	"io"
	"os"
	"path"
	"strings"
)

func untarBad(reader io.Reader, prefix string) {
	tarReader := tar.NewReader(reader)
	header, _ := tarReader.Next()
	os.MkdirAll(path.Dir(header.Name), 0755) // NOT OK
}

func untarGood(reader io.Reader, prefix string) {
	tarReader := tar.NewReader(reader)
	header, _ := tarReader.Next()
	if !strings.HasPrefix(header.Name, prefix) {
		panic("tar contents corrupted")
	}
	os.MkdirAll(path.Dir(header.Name), 0755) // OK
}

package main

import (
	"archive/tar"
	"archive/zip"
	"io"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
)

func isRelGood(candidate, target string) bool {
	// GOOD: resolves all symbolic links before checking
	// that `candidate` does not escape from `target`
	if filepath.IsAbs(candidate) {
		return false
	}
	realpath, err := filepath.EvalSymlinks(filepath.Join(target, candidate))
	if err != nil {
		return false
	}
	relpath, err := filepath.Rel(target, realpath)
	return err == nil && !strings.HasPrefix(filepath.Clean(relpath), "..")
}

func unzipSymlinkGood(f io.Reader, target string) {
	r := tar.NewReader(f)
	for {
		header, err := r.Next()
		if err != nil {
			break
		}
		if isRelGood(header.Linkname, target) && isRelGood(header.Name, target) {
			os.Symlink(header.Linkname, header.Name)
		}
	}
}

func unzipSymlinkGoodZip(f io.ReaderAt, target string) {
	r, _ := zip.NewReader(f, 100)
	for _, header := range r.File {
		linkData, _ := header.Open()
		linkNameBytes, _ := ioutil.ReadAll(linkData)
		linkName := string(linkNameBytes)
		if isRelGood(linkName, target) && isRelGood(header.Name, target) {
			os.Symlink(linkName, header.Name)
		}
	}
}

func isRelGoodReadlink(candidate, target string) bool {
	// GOOD: resolves symbolic links before checking
	// that `candidate` does not escape from `target`.
	// Note this is not actually safe (using Readlink
	// to resolve everything is not simple), so I just
	// make some token use of it here.
	if filepath.IsAbs(candidate) {
		return false
	}
	realpath, err := os.Readlink(filepath.Join(target, candidate))
	if err != nil {
		return false
	}
	relpath, err := filepath.Rel(target, realpath)
	return err == nil && !strings.HasPrefix(filepath.Clean(relpath), "..")
}

func unzipSymlinkGoodReadlink(f io.Reader, target string) {
	r := tar.NewReader(f)
	for {
		header, err := r.Next()
		if err != nil {
			break
		}
		if isRelGoodReadlink(header.Linkname, target) && isRelGoodReadlink(header.Name, target) {
			os.Symlink(header.Linkname, header.Name)
		}
	}
}

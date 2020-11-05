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

func isRel(candidate, target string) bool {
	// BAD: purely syntactic means are used to check
	// that `candidate` does not escape from `target`
	if filepath.IsAbs(candidate) {
		return false
	}
	relpath, err := filepath.Rel(target, filepath.Join(target, candidate))
	return err == nil && !strings.HasPrefix(filepath.Clean(relpath), "..")
}

func unzipSymlinkBad(f io.Reader, target string) {
	r := tar.NewReader(f)
	for {
		header, err := r.Next()
		if err != nil {
			break
		}
		if isRel(header.Linkname, target) && isRel(header.Name, target) {
			os.Symlink(header.Linkname, header.Name)
		}
	}
}

func unzipSymlinkBadZip(f io.ReaderAt, target string) {
	r, _ := zip.NewReader(f, 100)
	for _, header := range r.File {
		linkData, _ := header.Open()
		linkNameBytes, _ := ioutil.ReadAll(linkData)
		linkName := string(linkNameBytes)
		if isRel(linkName, target) && isRel(header.Name, target) {
			os.Symlink(linkName, header.Name)
		}
	}
}

// BAD (but not detected): some (notably Kubernetes) have solved the symlink
// problem with two loops: one that creates directory structure and resolves
// paths without creating links that could trip this process, then another
// that creates links. We approximate that by looking for the most intuitive
// implementation where `os.Symlink` is called directly from the same loop,
// and so mistake this for a safe implementation.
func unzipSymlinkOtherLoop(f io.Reader, target string) {
	r := tar.NewReader(f)
	links := map[string]string{}
	for {
		header, err := r.Next()
		if err != nil {
			break
		}
		links[header.Linkname] = header.Name
	}

	for linkName, name := range links {
		os.Symlink(linkName, name)
	}
}

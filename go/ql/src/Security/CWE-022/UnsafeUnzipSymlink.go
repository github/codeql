package main

import (
	"archive/tar"
	"io"
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

func unzipSymlink(f io.Reader, target string) {
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

package main

import (
	"archive/tar"
	"errors"
	"io"
	"os"
	"path"
	"path/filepath"
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

// GOOD: checks `header.Name` indirectly.
func untarGoodIndirect(reader io.Reader, prefix string) {
	tarReader := tar.NewReader(reader)
	header, _ := tarReader.Next()
	if !strings.HasPrefix(filepath.Join(prefix, header.Name), prefix) {
		panic("tar contents corrupted")
	}
	os.MkdirAll(path.Dir(header.Name), 0755) // OK
}

func checkPathTar(s, prefix string) error {
	if !strings.HasPrefix(filepath.Join(prefix, s), prefix) {
		return errors.New("tar contents corrupted")
	}
	return nil
}

// GOOD: uses a function that returns an error
// when the header is not safe to use. Flagged because we can't currently
// recognise that `errors.New` always returns non-nil.
func untarGoodIndirectUsingFunction(reader io.Reader, prefix string) {
	tarReader := tar.NewReader(reader)
	header, _ := tarReader.Next()
	if checkPathTar(header.Name, prefix) != nil {
		panic("tar contents corrupted")
	}
	os.MkdirAll(path.Dir(header.Name), 0755) // OK
}

func checkPathBoolTar(s, prefix string) bool {
	return strings.HasPrefix(filepath.Join(prefix, s), prefix)
}

// GOOD: uses a checker function returning a boolean
// to ensure `header` is safe to unpack. Currently flagged because the callee
// has no 'return true' or 'return false' statements, but rather directly
// returns a sanitizer guard function.
func untarGoodIndirectUsingBoolFunction(reader io.Reader, prefix string) {
	tarReader := tar.NewReader(reader)
	header, _ := tarReader.Next()
	if !checkPathBoolTar(header.Name, prefix) {
		panic("tar contents corrupted")
	}
	os.MkdirAll(path.Dir(header.Name), 0755) // OK
}

func checkPathBoolStmtTar(s, prefix string) bool {
	if strings.HasPrefix(filepath.Join(prefix, s), prefix) {
		return true
	}
	return false
}

// GOOD: uses a checker function returning a boolean to ensure `header`
// is safe to unpack.
func untarGoodIndirectUsingBoolStmtFunction(reader io.Reader, prefix string) {
	tarReader := tar.NewReader(reader)
	header, _ := tarReader.Next()
	if !checkPathBoolStmtTar(header.Name, prefix) {
		panic("tar contents corrupted")
	}
	os.MkdirAll(path.Dir(header.Name), 0755) // OK
}

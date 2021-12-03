package main

import (
	"archive/zip"
	"errors"
	"io/ioutil"
	"path/filepath"
	"strings"
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

// GOOD: checks `f.Name` indirectly.
func unzipGoodIndirect(f string) {
	r, _ := zip.OpenReader(f)
	for _, f := range r.File {
		p, _ := filepath.Abs(f.Name)
		// GOOD: Check that path does not contain ".." before using it
		if !strings.Contains(filepath.Clean(p), "..") {
			ioutil.WriteFile(p, []byte("present"), 0666)
		}
	}
}

func checkPath(p string) error {
	if strings.Contains(filepath.Clean(p), "..") {
		return errors.New("zip contents corrupted")
	}
	return nil
}

// GOOD: uses a function that returns an error
// when the header is not safe to use. Flagged because we can't currently
// recognise that `errors.New` always returns non-nil.
func unzipGoodIndirectUsingFunction(f string) {
	r, _ := zip.OpenReader(f)
	for _, f := range r.File {
		p, _ := filepath.Abs(f.Name)
		// GOOD: Check that path does not contain ".." before using it
		if checkPath(p) == nil {
			ioutil.WriteFile(p, []byte("present"), 0666)
		}
	}
}

func checkPathBool(p string) bool {
	return strings.Contains(filepath.Clean(p), "..")
}

// GOOD: uses a checker function returning a boolean
// to ensure `header` is safe to unpack. Currently flagged because the callee
// has no 'return true' or 'return false' statements, but rather directly
// returns a sanitizer guard function.
func unzipGoodIndirectUsingBoolFunction(f string) {
	r, _ := zip.OpenReader(f)
	for _, f := range r.File {
		p, _ := filepath.Abs(f.Name)
		// GOOD: Check that path does not contain ".." before using it
		if !checkPathBool(p) {
			ioutil.WriteFile(p, []byte("present"), 0666)
		}
	}
}

func checkPathBoolStmt(p string) bool {
	if strings.Contains(filepath.Clean(p), "..") {
		return true
	}
	return false
}

// GOOD: uses a checker function returning a boolean to ensure `header`
// is safe to unpack.
func unzipGoodIndirectUsingBoolStmtFunction(f string) {
	r, _ := zip.OpenReader(f)
	for _, f := range r.File {
		p, _ := filepath.Abs(f.Name)
		// GOOD: Check that path does not contain ".." before using it
		if !checkPathBoolStmt(p) {
			ioutil.WriteFile(p, []byte("present"), 0666)
		}
	}
}

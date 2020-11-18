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

// BAD (but not detected): a pair of variants of the above, where either the tar-read or
// symlink operation are wrapped in a dummy loop, tricking the analysis into thinking there
// isn't a simple loop relationship between the two.
func unzipSymlinkChildLoop1(f io.Reader, target string) {
	r := tar.NewReader(f)
	for {
		var header *tar.Header
		var err error
		for {
			header, err = r.Next()
			break
		}
		if err != nil {
			break
		}
		if isRel(header.Linkname, target) && isRel(header.Name, target) {
			os.Symlink(header.Linkname, header.Name)
		}
	}
}

func unzipSymlinkChildLoop2(f io.Reader, target string) {
	r := tar.NewReader(f)
	for {
		header, err := r.Next()
		if err != nil {
			break
		}
		if isRel(header.Linkname, target) && isRel(header.Name, target) {
			for {
				os.Symlink(header.Linkname, header.Name)
				break
			}
		}
	}
}

func getNextHeader(f *tar.Reader) (*tar.Header, error) {
	return f.Next()
}

func writeSymlink(linkName, fileName string) {
	os.Symlink(linkName, fileName)
}

// BAD: a variant of `unzipSymlinkBad` where the tar-read and symlink
// operations belong to different functions, so finding their closest
// enclosing loop involves looking across call-graph edges.
func unzipSymlinkBadFactored(f io.Reader, target string) {
	r := tar.NewReader(f)
	for {
		header, err := getNextHeader(r)
		if err != nil {
			break
		}
		if isRel(header.Linkname, target) && isRel(header.Name, target) {
			writeSymlink(header.Linkname, header.Name)
		}
	}
}

func writeSymlink2(linkName, fileName string) {
	os.Symlink(linkName, fileName)
}

// BAD (but not detected): a variant of `unzipSymlinkBadFactored` where
// the tar-read and symlink operations belong to different functions, so
// finding their closest enclosing loop involves looking across call-graph edges.
// However, by surrounding one of the calls with a dummy loop, they appear not
// to have a simple control-flow relationship and are ignored.
//
// This uses a duplicate of writeSymlink2, otherwise the two functions sharing
// a loop in the previous test is mistaken for this one.
func unzipSymlinkBadFactoredDummyLoop(f io.Reader, target string) {
	r := tar.NewReader(f)
	for {
		header, err := getNextHeader(r)
		if err != nil {
			break
		}
		if isRel(header.Linkname, target) && isRel(header.Name, target) {
			for {
				writeSymlink2(header.Linkname, header.Name)
				break
			}
		}
	}
}

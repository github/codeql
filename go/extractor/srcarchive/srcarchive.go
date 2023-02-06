package srcarchive

import (
	"errors"
	"io"
	"log"
	"os"
	"path/filepath"
	"strings"
)

var pathTransformer *ProjectLayout

func init() {
	pt := os.Getenv("SEMMLE_PATH_TRANSFORMER")
	if pt != "" {
		ptf, err := os.Open(pt)
		if err != nil {
			log.Fatalf("Unable to open path transformer %s: %s.\n", pt, err.Error())
		}
		pathTransformer, err = LoadProjectLayout(ptf)
		if err != nil {
			log.Fatalf("Unable to initialize path transformer: %s.\n", err.Error())
		}
	}
}

// Add inserts the file with the given `path` into the source archive, returning a non-nil
// error value if it fails
func Add(path string) error {
	srcArchive, err := srcArchive()
	if err != nil {
		return err
	}

	file, err := os.Open(path)
	if err != nil {
		return err
	}
	defer file.Close()

	archiveFilePath := filepath.Join(srcArchive, AppendablePath(path))
	err = os.MkdirAll(filepath.Dir(archiveFilePath), 0755)
	if err != nil {
		return err
	}
	archiveFile, err := os.Create(archiveFilePath)
	if err != nil {
		return err
	}
	defer archiveFile.Close()

	_, err = io.Copy(archiveFile, file)
	return err
}

func srcArchive() (string, error) {
	srcArchive := os.Getenv("CODEQL_EXTRACTOR_GO_SOURCE_ARCHIVE_DIR")
	if srcArchive == "" {
		srcArchive = os.Getenv("SOURCE_ARCHIVE")
	}
	if srcArchive == "" {
		return "", errors.New("environment variable CODEQL_EXTRACTOR_GO_SOURCE_ARCHIVE_DIR not set")
	}
	err := os.MkdirAll(srcArchive, 0755)
	if err != nil {
		return "", err
	}
	return srcArchive, nil
}

// TransformPath applies the transformations specified by `SEMMLE_PATH_TRANSFORMER` (if any) to the
// given path
func TransformPath(path string) string {
	if pathTransformer != nil {
		return filepath.FromSlash(pathTransformer.Transform(filepath.ToSlash(path)))
	}
	return path
}

// AppendablePath transforms the given path and also replaces colons with underscores to make it
// possible to append it to a base path on Windows
func AppendablePath(path string) string {
	return strings.ReplaceAll(TransformPath(path), ":", "_")
}

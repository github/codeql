package trap

import (
	"bufio"
	"compress/gzip"
	"errors"
	"fmt"
	"go/types"
	"io/ioutil"
	"os"
	"path/filepath"
	"unicode/utf8"

	"github.com/github/codeql-go/extractor/srcarchive"
	"golang.org/x/tools/go/packages"
)

// A Writer provides methods for writing data to a TRAP file
type Writer struct {
	zip          *gzip.Writer
	w            *bufio.Writer
	file         *os.File
	Labeler      *Labeler
	path         string
	trapFilePath string
	Package      *packages.Package
}

func FileFor(path string) (string, error) {
	trapFolder, err := trapFolder()
	if err != nil {
		return "", err
	}

	return filepath.Join(trapFolder, srcarchive.AppendablePath(path)+".trap.gz"), nil
}

// NewWriter creates a TRAP file for the given path and returns a writer for
// writing to it
func NewWriter(path string, pkg *packages.Package) (*Writer, error) {
	trapFilePath, err := FileFor(path)
	if err != nil {
		return nil, err
	}
	trapFileDir := filepath.Dir(trapFilePath)
	err = os.MkdirAll(trapFileDir, 0755)
	if err != nil {
		return nil, err
	}
	tmpFile, err := ioutil.TempFile(trapFileDir, filepath.Base(trapFilePath))
	if err != nil {
		return nil, err
	}
	bufioWriter := bufio.NewWriter(tmpFile)
	zipWriter := gzip.NewWriter(bufioWriter)
	tw := &Writer{
		zipWriter,
		bufioWriter,
		tmpFile,
		nil,
		path,
		trapFilePath,
		pkg,
	}
	tw.Labeler = newLabeler(tw)
	return tw, nil
}

func trapFolder() (string, error) {
	trapFolder := os.Getenv("CODEQL_EXTRACTOR_GO_TRAP_DIR")
	if trapFolder == "" {
		trapFolder = os.Getenv("TRAP_FOLDER")
	}
	if trapFolder == "" {
		return "", errors.New("environment variable CODEQL_EXTRACTOR_GO_TRAP_DIR not set")
	}
	err := os.MkdirAll(trapFolder, 0755)
	if err != nil {
		return "", err
	}
	return trapFolder, nil
}

// Close the underlying file writer
func (tw *Writer) Close() error {
	err := tw.zip.Close()
	if err != nil {
		// return zip-close error, but ignore file-close error
		tw.file.Close()
		return err
	}
	err = tw.w.Flush()
	if err != nil {
		// throw away close error because write errors are likely to be more important
		tw.file.Close()
		return err
	}
	err = tw.file.Close()
	if err != nil {
		return err
	}
	return os.Rename(tw.file.Name(), tw.trapFilePath)
}

// ForEachObject iterates over all objects labeled by this labeler, and invokes
// the provided callback with a writer for the trap file, the object, and its
// label.
func (tw *Writer) ForEachObject(cb func(*Writer, types.Object, Label)) {
	for object, lbl := range tw.Labeler.objectLabels {
		cb(tw, object, lbl)
	}
}

const max_strlen = 1024 * 1024

func capStringLength(s string) string {
	// if the UTF8-encoded string is longer than 1MiB, we truncate it
	if len(s) > max_strlen {
		// to ensure that the truncated string is valid UTF-8, we find the last byte at or
		// before index max_strlen that starts a UTF-8 encoded character, and then cut off
		// right before that byte
		end := max_strlen
		for ; !utf8.RuneStart(s[end]); end-- {
		}
		return s[0:end]
	}
	return s
}

// Emit writes out a tuple of values for the given `table`
func (tw *Writer) Emit(table string, values []interface{}) error {
	fmt.Fprintf(tw.zip, "%s(", table)
	for i, value := range values {
		if i > 0 {
			fmt.Fprint(tw.zip, ", ")
		}
		switch value := value.(type) {
		case Label:
			fmt.Fprint(tw.zip, value.id)
		case string:
			fmt.Fprintf(tw.zip, "\"%s\"", escapeString(capStringLength(value)))
		case int:
			fmt.Fprintf(tw.zip, "%d", value)
		case float64:
			fmt.Fprintf(tw.zip, "%e", value)
		default:
			return errors.New("Cannot emit value")
		}
	}
	fmt.Fprintf(tw.zip, ")\n")
	return nil
}

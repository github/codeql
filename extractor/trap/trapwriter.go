package trap

import (
	"errors"
	"fmt"
	"go/types"
	"io/ioutil"
	"os"
	"path/filepath"

	"github.com/Semmle/go/extractor/srcarchive"
	"golang.org/x/tools/go/packages"
)

// A Writer provides methods for writing data to a TRAP file
type Writer struct {
	w            *os.File
	Labeler      *Labeler
	path         string
	trapFilePath string
	Package      *packages.Package
}

// NewWriter creates a TRAP file for the given path and returns a writer for
// writing to it
func NewWriter(path string, pkg *packages.Package) (*Writer, error) {
	trapFolder, err := trapFolder()
	if err != nil {
		return nil, err
	}
	trapFilePath := filepath.Join(trapFolder, srcarchive.AppendablePath(path)+".trap")
	trapFileDir := filepath.Dir(trapFilePath)
	err = os.MkdirAll(trapFileDir, 0755)
	if err != nil {
		return nil, err
	}
	tmpFile, err := ioutil.TempFile(trapFileDir, filepath.Base(trapFilePath))
	if err != nil {
		return nil, err
	}
	tw := &Writer{
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
	trapFolder := os.Getenv("TRAP_FOLDER")
	if trapFolder == "" {
		return "", errors.New("environment variable TRAP_FOLDER not set")
	}
	err := os.MkdirAll(trapFolder, 0755)
	if err != nil {
		return "", err
	}
	return trapFolder, nil
}

// Close the underlying file writer
func (tw *Writer) Close() error {
	err := tw.w.Sync()
	if err != nil {
		return err
	}
	err = tw.w.Close()
	if err != nil {
		return err
	}
	return os.Rename(tw.w.Name(), tw.trapFilePath)
}

// ForEachObject iterates over all objects labeled by this labeler, and invokes
// the provided callback with a writer for the trap file, the object, and its
// label.
func (tw *Writer) ForEachObject(cb func(*Writer, types.Object, Label)) {
	for object, lbl := range tw.Labeler.objectLabels {
		cb(tw, object, lbl)
	}
}

// Emit writes out a tuple of values for the given `table`
func (tw *Writer) Emit(table string, values []interface{}) error {
	fmt.Fprintf(tw.w, "%s(", table)
	for i, value := range values {
		if i > 0 {
			fmt.Fprint(tw.w, ", ")
		}
		switch value := value.(type) {
		case Label:
			fmt.Fprint(tw.w, value.id)
		case string:
			fmt.Fprintf(tw.w, "\"%s\"", escapeString(value))
		case int:
			fmt.Fprintf(tw.w, "%d", value)
		default:
			return errors.New("Cannot emit value")
		}
	}
	fmt.Fprintf(tw.w, ")\n")
	return nil
}

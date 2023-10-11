// Jade.go - template engine. Package implements Jade-lang templates for generating Go html/template output.
package jade

import (
	"bytes"
	"io"
	"net/http"
)

/*
Parse parses the template definition string to construct a representation of the template for execution.

Trivial usage:

	package main

	import (
		"fmt"
		"html/template"
		"net/http"

		"github.com/Joker/jade"
	)

	func handler(w http.ResponseWriter, r *http.Request) {
		jadeTpl, _ := jade.Parse("jade", []byte("doctype 5\n html: body: p Hello #{.Word}!"))
		goTpl, _ := template.New("html").Parse(jadeTpl)

		goTpl.Execute(w, struct{ Word string }{"jade"})
	}

	func main() {
		http.HandleFunc("/", handler)
		http.ListenAndServe(":8080", nil)
	}

Output:

	<!DOCTYPE html><html><body><p>Hello jade!</p></body></html>
*/
func Parse(fname string, text []byte) (string, error) {
	outTpl, err := New(fname).Parse(text)
	if err != nil {
		return "", err
	}
	bb := new(bytes.Buffer)
	outTpl.WriteIn(bb)
	return bb.String(), nil
}

// ParseFile parse the jade template file in given filename
func ParseFile(fname string) (string, error) {
	text, err := ReadFunc(fname)
	if err != nil {
		return "", err
	}
	return Parse(fname, text)
}

// ParseWithFileSystem parse in context of a http.FileSystem (supports embedded files)
func ParseWithFileSystem(fname string, text []byte, fs http.FileSystem) (str string, err error) {
	outTpl := New(fname)
	outTpl.fs = fs

	outTpl, err = outTpl.Parse(text)
	if err != nil {
		return "", err
	}

	bb := new(bytes.Buffer)
	outTpl.WriteIn(bb)
	return bb.String(), nil
}

// ParseFileFromFileSystem parse template file in context of a http.FileSystem (supports embedded files)
func ParseFileFromFileSystem(fname string, fs http.FileSystem) (str string, err error) {
	text, err := readFile(fname, fs)
	if err != nil {
		return "", err
	}
	return ParseWithFileSystem(fname, text, fs)
}

func (t *tree) WriteIn(b io.Writer) {
	t.Root.WriteIn(b)
}

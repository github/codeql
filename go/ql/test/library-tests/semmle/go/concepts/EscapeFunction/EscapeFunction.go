package main

// this is a dummy file that imports the relevant libraries so the tests
// can pick up the functions that should be detected.

import (
	"bytes"
	"text/template"
)

func main() {
	buf := bytes.NewBufferString("")
	template.HTMLEscape(buf, []byte("<script>alert('hi')</script>"))
}

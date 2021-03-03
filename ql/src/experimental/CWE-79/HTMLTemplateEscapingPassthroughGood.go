package main

import (
	"html/template"
	"os"
)

// good is an example of a good implementation
func good() {
	tmpl, _ := template.New("test").Parse(`Hello, {{.}}\n`)
	{ // This will be escaped:
		var caught = source(`<a href="example.com">link</a>`)
		checkError(tmpl.Execute(os.Stdout, caught))
	}
}

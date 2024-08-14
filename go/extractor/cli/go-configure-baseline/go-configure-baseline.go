package main

import (
	"github.com/github/codeql-go/extractor/configurebaseline"
)

func main() {
	jsonResult, err := configurebaseline.GetConfigBaselineAsJSON(".")
	if err != nil {
		panic(err)
	} else {
		println(string(jsonResult))
	}
}

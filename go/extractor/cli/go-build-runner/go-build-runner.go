package main

import (
	"github.com/github/codeql-go/extractor/util"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"

	"github.com/github/codeql-go/extractor/autobuilder"
)

func main() {
	// check if a build command has successfully extracted something
	autobuilder.CheckExtracted = true
	if autobuilder.Autobuild() {
		return
	}

	// if the autobuilder fails, invoke the extractor manually
	// we cannot simply call `go build` here, because the tracer is not able to trace calls made by
	// this binary
	log.Printf("No build commands succeeded, falling back to go build ./...")

	mypath, err := os.Executable()
	if err != nil {
		log.Fatalf("Could not determine path of extractor: %v.\n", err)
	}
	extractor := filepath.Join(filepath.Dir(mypath), "go-extractor")
	if runtime.GOOS == "windows" {
		extractor = extractor + ".exe"
	}

	util.RunCmd(exec.Command(extractor, "./..."))
}

// Package autobuilder implements a simple system that attempts to run build commands for common
// build frameworks, if the relevant files exist.
package autobuilder

import (
	"log"
	"os"
	"os/exec"

	"github.com/github/codeql-go/extractor/util"
)

// CheckExtracted sets whether the autobuilder should check whether source files have been extracted
// to the CodeQL source directory as well as whether the build command executed successfully.
var CheckExtracted = false

// checkEmpty checks whether a directory either doesn't exist or is empty.
func checkEmpty(dir string) (bool, error) {
	if !util.DirExists(dir) {
		return true, nil
	}

	d, err := os.Open(dir)
	if err != nil {
		return false, err
	}
	defer d.Close()

	names, err := d.Readdirnames(-1)
	if err != nil {
		return false, err
	}
	return len(names) == 0, nil
}

// checkExtractorRun checks whether the CodeQL Go extractor has run, by checking if the source
// archive directory is empty or not.
func checkExtractorRun() bool {
	srcDir := os.Getenv("CODEQL_EXTRACTOR_GO_SOURCE_ARCHIVE_DIR")
	if srcDir != "" {
		empty, err := checkEmpty(srcDir)
		if err != nil {
			log.Fatalf("Unable to read source archive directory %s.", srcDir)
		}
		if empty {
			log.Printf("No Go code seen; continuing to try other builds.")
			return false
		}
		return true
	} else {
		log.Fatalf("No source directory set.\nThis binary should not be run manually; instead, use the CodeQL CLI or VSCode extension. See https://securitylab.github.com/tools/codeql.")
		return false
	}
}

// tryBuildIfExists tries to run the command `cmd args...` if the file `buildFile` exists and is not
// a directory. Returns true if the command was successful and false if not.
func tryBuildIfExists(buildFile, cmd string, args ...string) bool {
	if util.FileExists(buildFile) {
		log.Printf("%s found.\n", buildFile)
		return tryBuild(cmd, args...)
	}
	return false
}

// tryBuild tries to run `cmd args...`, returning true if successful and false if not.
func tryBuild(cmd string, args ...string) bool {
	log.Printf("Trying build command %s %v", cmd, args)
	res := util.RunCmd(exec.Command(cmd, args...))
	return res && (!CheckExtracted || checkExtractorRun())
}

// Autobuild attempts to detect build system and run the corresponding command.
func Autobuild() bool {
	return tryBuildIfExists("Makefile", "make") ||
		tryBuildIfExists("makefile", "make") ||
		tryBuildIfExists("GNUmakefile", "make") ||
		tryBuildIfExists("build.ninja", "ninja") ||
		tryBuildIfExists("build", "./build") ||
		tryBuildIfExists("build.sh", "./build.sh")
}

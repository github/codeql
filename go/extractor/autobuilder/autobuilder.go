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
// a directory. Returns values indicating whether the script succeeded as well as whether the script was found.
func tryBuildIfExists(buildFile, cmd string, args ...string) (scriptSuccess bool, scriptFound bool) {
	scriptSuccess = false
	scriptFound = util.FileExists(buildFile)
	if scriptFound {
		log.Printf("%s found.\n", buildFile)
		scriptSuccess = tryBuild(cmd, args...)
	}
	return
}

// tryBuild tries to run `cmd args...`, returning true if successful and false if not.
func tryBuild(cmd string, args ...string) bool {
	log.Printf("Trying build command %s %v", cmd, args)
	res := util.RunCmd(exec.Command(cmd, args...))
	return res && (!CheckExtracted || checkExtractorRun())
}

// If a project is accompanied by a build script (such as a makefile), then we try executing such
// build scripts to build the project. This type represents pairs of script names to check for
// and the names of corresponding build tools to invoke if those scripts exist.
type BuildScript struct {
	Tool     string // The name of the command to execute if the build script exists
	Filename string // The name of the build script to check for
}

// An array of build scripts to check for and corresponding commands that we can execute
// if they exist.
var BuildScripts = []BuildScript{
	{Tool: "make", Filename: "Makefile"},
	{Tool: "make", Filename: "makefile"},
	{Tool: "make", Filename: "GNUmakefile"},
	{Tool: "ninja", Filename: "build.ninja"},
	{Tool: "./build", Filename: "build"},
	{Tool: "./build.sh", Filename: "build.sh"},
}

// Autobuild attempts to detect build systems based on the presence of build scripts from the
// list in `BuildScripts` and run the corresponding command. This may invoke zero or more
// build scripts in the order given by `BuildScripts`.
// Returns `scriptSuccess` which indicates whether a build script was successfully executed.
// Returns `scriptsExecuted` which contains the names of all build scripts that were executed.
func Autobuild() (scriptSuccess bool, scriptsExecuted []string) {
	scriptSuccess = false
	scriptsExecuted = []string{}

	for _, script := range BuildScripts {
		// Try to run the build script
		success, scriptFound := tryBuildIfExists(script.Filename, script.Tool)

		// If it was found, we attempted to run it: add it to the array.
		if scriptFound {
			scriptsExecuted = append(scriptsExecuted, script.Filename)
		}
		// If it was successfully executed, we stop here.
		if success {
			scriptSuccess = true
			return
		}
	}
	return
}

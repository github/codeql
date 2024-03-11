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

// tryBuildIfExists tries to run the build commands `cmds` if the file `buildFile` exists and is not
// a directory. Returns true if the command was successful and false if not.
func tryBuildIfExists(buildFile string, cmds []BuildCommand) bool {
	if util.FileExists(buildFile) {
		log.Printf("%s found.\n", buildFile)
		return tryBuild(cmds)
	}
	return false
}

// tryBuild tries to run `cmds`, returning true if successful and false if not.
func tryBuild(cmds []BuildCommand) bool {
	for _, cmd := range cmds {
		log.Printf("Trying build command %s %v", cmd.Command, cmd.Args)
		if !util.RunCmd(exec.Command(cmd.Command, cmd.Args...)) {
			return false
		}
	}
	return !CheckExtracted || checkExtractorRun()
}

// If a project is accompanied by a build script (such as a makefile), then we try executing such
// build scripts to build the project. This type represents pairs of script names to check for
// and the corresponding build commands to invoke if those scripts exist.
type BuildScript struct {
	Commands []BuildCommand // The commands to execute if the build script exists
	Filename string         // The name of the build script to check for
}

// Represents build commands comprised of command names and arguments.
type BuildCommand struct {
	Command string   // The name of the command to execute if the build script exists
	Args    []string // Extra arguments to pass to the build command
}

// An array of build scripts to check for and corresponding commands that we can execute
// if they exist.
var BuildScripts = []BuildScript{
	{Filename: "Makefile", Commands: []BuildCommand{{Command: "make"}}},
	{Filename: "makefile", Commands: []BuildCommand{{Command: "make"}}},
	{Filename: "GNUmakefile", Commands: []BuildCommand{{Command: "make"}}},
	{Filename: "build.ninja", Commands: []BuildCommand{{Command: "ninja"}}},
	{Filename: "build", Commands: []BuildCommand{{Command: "./build"}}},
	{Filename: "build.sh", Commands: []BuildCommand{{Command: "./build.sh"}}},
}

// Autobuild attempts to detect build systems based on the presence of build scripts from the
// list in `BuildScripts` and run the corresponding command. This may invoke zero or more
// build scripts in the order given by `BuildScripts`.
func Autobuild() bool {
	for _, script := range BuildScripts {
		if tryBuildIfExists(script.Filename, script.Commands) {
			return true
		}
	}
	return false
}

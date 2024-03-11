package toolchain

import (
	"bufio"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/github/codeql-go/extractor/util"
	"golang.org/x/mod/semver"
)

// Check if Go is installed in the environment.
func IsInstalled() bool {
	_, err := exec.LookPath("go")
	return err == nil
}

var goVersion = ""

// Returns the current Go version as returned by 'go version', e.g. go1.14.4
func GetEnvGoVersion() string {
	if goVersion == "" {
		// Since Go 1.21, running 'go version' in a directory with a 'go.mod' file will attempt to
		// download the version of Go specified in there. That may either fail or result in us just
		// being told what's already in 'go.mod'. Setting 'GOTOOLCHAIN' to 'local' will force it
		// to use the local Go toolchain instead.
		cmd := exec.Command("go", "version")
		cmd.Env = append(os.Environ(), "GOTOOLCHAIN=local")
		out, err := cmd.CombinedOutput()

		if err != nil {
			log.Fatalf("Unable to run the go command, is it installed?\nError: %s", err.Error())
		}

		goVersion = parseGoVersion(string(out))
	}
	return goVersion
}

// Returns the current Go version in semver format, e.g. v1.14.4
func GetEnvGoSemVer() string {
	goVersion := GetEnvGoVersion()
	if !strings.HasPrefix(goVersion, "go") {
		log.Fatalf("Expected 'go version' output of the form 'go1.2.3'; got '%s'", goVersion)
	}
	// Go versions don't follow the SemVer format, but the only exception we normally care about
	// is release candidates; so this is a horrible hack to convert e.g. `go1.22rc1` into `go1.22-rc1`
	// which is compatible with the SemVer specification
	rcIndex := strings.Index(goVersion, "rc")
	if rcIndex != -1 {
		return semver.Canonical("v"+goVersion[2:rcIndex]) + "-" + goVersion[rcIndex:]
	} else {
		return semver.Canonical("v" + goVersion[2:])
	}
}

// The 'go version' command may output warnings on separate lines before
// the actual version string is printed. This function parses the output
// to retrieve just the version string.
func parseGoVersion(data string) string {
	var lastLine string
	sc := bufio.NewScanner(strings.NewReader(data))
	for sc.Scan() {
		lastLine = sc.Text()
	}
	return strings.Fields(lastLine)[2]
}

// Returns a value indicating whether the system Go toolchain supports workspaces.
func SupportsWorkspaces() bool {
	return semver.Compare(GetEnvGoSemVer(), "v1.18.0") >= 0
}

// Run `go mod tidy -e` in the directory given by `path`.
func TidyModule(path string) *exec.Cmd {
	cmd := exec.Command("go", "mod", "tidy", "-e")
	cmd.Dir = path
	return cmd
}

// Run `go mod init` in the directory given by `path`.
func InitModule(path string) *exec.Cmd {
	moduleName := "codeql/auto-project"

	if importpath := util.GetImportPath(); importpath != "" {
		// This should be something like `github.com/user/repo`
		moduleName = importpath

		// If we are not initialising the new module in the root directory of the workspace,
		// append the relative path to the module name.
		if relPath, err := filepath.Rel(".", path); err != nil && relPath != "." {
			moduleName = moduleName + "/" + relPath
		}
	}

	modInit := exec.Command("go", "mod", "init", moduleName)
	modInit.Dir = path
	return modInit
}

// Constructs a command to run `go mod vendor -e` in the directory given by `path`.
func VendorModule(path string) *exec.Cmd {
	modVendor := exec.Command("go", "mod", "vendor", "-e")
	modVendor.Dir = path
	return modVendor
}

package toolchain

import (
	"bufio"
	"encoding/json"
	"io"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/github/codeql-go/extractor/util"
)

var V1_14 = util.NewSemVer("v1.14.0")
var V1_16 = util.NewSemVer("v1.16.0")
var V1_18 = util.NewSemVer("v1.18.0")
var V1_21 = util.NewSemVer("v1.21.0")

// Check if Go is installed in the environment.
func IsInstalled() bool {
	_, err := exec.LookPath("go")
	return err == nil
}

// The default Go version that is available on a system and a set of all versions
// that we know are installed on the system.
var goVersion = ""
var goVersions = map[util.SemVer]struct{}{}

// Adds an entry to the set of installed Go versions for the normalised `version` number.
func addGoVersion(version util.SemVer) {
	goVersions[version] = struct{}{}
}

// Returns the current Go version as returned by 'go version', e.g. go1.14.4
func GetEnvGoVersion() string {
	if goVersion == "" {
		// Since Go 1.21, running 'go version' in a directory with a 'go.mod' file will attempt to
		// download the version of Go specified in there. That may either fail or result in us just
		// being told what's already in 'go.mod'. Setting 'GOTOOLCHAIN' to 'local' will force it
		// to use the local Go toolchain instead.
		cmd := Version()

		// If 'GOTOOLCHAIN' is already set, then leave it as is. This allows us to force a specific
		// Go version in tests and also allows users to override the system default more generally.
		_, hasToolchainVar := os.LookupEnv("GOTOOLCHAIN")
		if !hasToolchainVar {
			cmd.Env = append(os.Environ(), "GOTOOLCHAIN=local")
		}

		out, err := cmd.CombinedOutput()

		if err != nil {
			log.Println(string(out))
			log.Fatalf("Unable to run the go command, is it installed?\nError: %s", err.Error())
		}

		goVersion = parseGoVersion(string(out))
		addGoVersion(util.NewSemVer(goVersion))
	}
	return goVersion
}

// Determines whether, to our knowledge, `version` is available on the current system.
func HasGoVersion(version util.SemVer) bool {
	_, found := goVersions[version]
	return found
}

// Attempts to install the Go toolchain `version`.
func InstallVersion(workingDir string, version util.SemVer) bool {
	// No need to install it if we know that it is already installed.
	if HasGoVersion(version) {
		return true
	}

	// Construct a command to invoke `go version` with `GOTOOLCHAIN=go1.N.0` to give
	// Go a valid toolchain version to download the toolchain we need; subsequent commands
	// should then work even with an invalid version that's still in `go.mod`
	toolchainArg := "GOTOOLCHAIN=go" + version.String()[1:]
	versionCmd := Version()
	versionCmd.Dir = workingDir
	versionCmd.Env = append(os.Environ(), toolchainArg)
	versionCmd.Stdout = os.Stdout
	versionCmd.Stderr = os.Stderr

	log.Printf(
		"Trying to install Go %s using its canonical representation in `%s`.",
		version,
		workingDir,
	)

	// Run the command. If something goes wrong, report it to the log and signal failure
	// to the caller.
	if versionErr := versionCmd.Run(); versionErr != nil {
		log.Printf(
			"Failed to invoke `%s go version` in %s: %s\n",
			toolchainArg,
			versionCmd.Dir,
			versionErr.Error(),
		)

		return false
	}

	// Add the version to the set of versions that we know are installed and signal
	// success to the caller.
	addGoVersion(version)
	return true
}

// Returns the current Go version in semver format, e.g. v1.14.4
func GetEnvGoSemVer() util.SemVer {
	goVersion := GetEnvGoVersion()
	if !strings.HasPrefix(goVersion, "go") {
		log.Fatalf("Expected 'go version' output of the form 'go1.2.3'; got '%s'", goVersion)
	}
	return util.NewSemVer(goVersion)
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
	return GetEnvGoSemVer().IsAtLeast(V1_18)
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

// Constructs a command to run `go version`.
func Version() *exec.Cmd {
	version := exec.Command("go", "version")
	return version
}

// Runs `go list` with `format`, `patterns`, and `flags` for the respective inputs.
func RunList(format string, patterns []string, flags ...string) (string, error) {
	return RunListWithEnv(format, patterns, nil, flags...)
}

// Constructs a `go list` command with `format`, `patterns`, and `flags` for the respective inputs.
func List(format string, patterns []string, flags ...string) *exec.Cmd {
	return ListWithEnv(format, patterns, nil, flags...)
}

// Runs `go list`.
func RunListWithEnv(format string, patterns []string, additionalEnv []string, flags ...string) (string, error) {
	cmd := ListWithEnv(format, patterns, additionalEnv, flags...)
	out, err := cmd.Output()

	if err != nil {
		if exitErr, ok := err.(*exec.ExitError); ok {
			log.Printf("Warning: go list command failed, output below:\nstdout:\n%s\nstderr:\n%s\n", out, exitErr.Stderr)
		} else {
			log.Printf("Warning: Failed to run go list: %s", err.Error())
		}
		return "", err
	}

	return strings.TrimSpace(string(out)), nil
}

// Constructs a `go list` command with `format`, `patterns`, and `flags` for the respective inputs
// and the extra environment variables given by `additionalEnv`.
func ListWithEnv(format string, patterns []string, additionalEnv []string, flags ...string) *exec.Cmd {
	args := append([]string{"list", "-e", "-f", format}, flags...)
	args = append(args, patterns...)
	cmd := exec.Command("go", args...)
	cmd.Env = append(os.Environ(), additionalEnv...)
	return cmd
}

// PkgInfo holds package directory and module directory (if any) for a package
type PkgInfo struct {
	PkgDir string // the directory directly containing source code of this package
	ModDir string // the module directory containing this package, empty if not a module
}

// GetPkgsInfo gets the absolute module and package root directories for the packages matched by the
// patterns `patterns`. It passes to `go list` the flags specified by `flags`.  If `includingDeps`
// is true, all dependencies will also be included.
func GetPkgsInfo(patterns []string, includingDeps bool, extractTests bool, flags ...string) (map[string]PkgInfo, error) {
	// enable module mode so that we can find a module root if it exists, even if go module support is
	// disabled by a build
	if includingDeps {
		// the flag `-deps` causes all dependencies to be retrieved
		flags = append(flags, "-deps")
	}

	if extractTests {
		// Without the `-test` flag, test packages would be omitted from the `go list` output.
		flags = append(flags, "-test")
	}

	// using -json overrides -f format
	output, err := RunList("", patterns, append(flags, "-json")...)
	if err != nil {
		return nil, err
	}

	// the output of `go list -json` is a stream of json object
	type goListPkgInfo struct {
		ImportPath string
		Dir        string
		Module     *struct {
			Dir string
		}
	}
	pkgInfoMapping := make(map[string]PkgInfo)
	streamDecoder := json.NewDecoder(strings.NewReader(output))
	for {
		var pkgInfo goListPkgInfo
		decErr := streamDecoder.Decode(&pkgInfo)
		if decErr == io.EOF {
			break
		}
		if decErr != nil {
			log.Printf("Error decoding output of go list -json: %s", err.Error())
			return nil, decErr
		}
		pkgAbsDir, err := filepath.Abs(pkgInfo.Dir)
		if err != nil {
			log.Printf("Unable to make package dir %s absolute: %s", pkgInfo.Dir, err.Error())
		}
		var modAbsDir string
		if pkgInfo.Module != nil {
			modAbsDir, err = filepath.Abs(pkgInfo.Module.Dir)
			if err != nil {
				log.Printf("Unable to make module dir %s absolute: %s", pkgInfo.Module.Dir, err.Error())
			}
		}
		pkgInfoMapping[pkgInfo.ImportPath] = PkgInfo{
			PkgDir: pkgAbsDir,
			ModDir: modAbsDir,
		}

		if extractTests && strings.Contains(pkgInfo.ImportPath, " [") {
			// Assume " [" is the start of a qualifier, and index the package by its base name
			baseImportPath := strings.Split(pkgInfo.ImportPath, " [")[0]
			pkgInfoMapping[baseImportPath] = pkgInfoMapping[pkgInfo.ImportPath]
		}
	}
	return pkgInfoMapping, nil
}

// GetPkgInfo fills the package info structure for the specified package path.
// It passes the `go list` the flags specified by `flags`.
func GetPkgInfo(pkgpath string, flags ...string) PkgInfo {
	return PkgInfo{
		PkgDir: GetPkgDir(pkgpath, flags...),
		ModDir: GetModDir(pkgpath, flags...),
	}
}

// GetModDir gets the absolute directory of the module containing the package with path
// `pkgpath`. It passes the `go list` the flags specified by `flags`.
func GetModDir(pkgpath string, flags ...string) string {
	// enable module mode so that we can find a module root if it exists, even if go module support is
	// disabled by a build
	mod, err := RunListWithEnv("{{.Module}}", []string{pkgpath}, []string{"GO111MODULE=on"}, flags...)
	if err != nil || mod == "<nil>" {
		// if the command errors or modules aren't being used, return the empty string
		return ""
	}

	modDir, err := RunListWithEnv("{{.Module.Dir}}", []string{pkgpath}, []string{"GO111MODULE=on"}, flags...)
	if err != nil {
		return ""
	}

	abs, err := filepath.Abs(modDir)
	if err != nil {
		log.Printf("Warning: unable to make %s absolute: %s", modDir, err.Error())
		return ""
	}
	return abs
}

// GetPkgDir gets the absolute directory containing the package with path `pkgpath`. It passes the
// `go list` command the flags specified by `flags`.
func GetPkgDir(pkgpath string, flags ...string) string {
	pkgDir, err := RunList("{{.Dir}}", []string{pkgpath}, flags...)
	if err != nil {
		return ""
	}

	abs, err := filepath.Abs(pkgDir)
	if err != nil {
		log.Printf("Warning: unable to make %s absolute: %s", pkgDir, err.Error())
		return ""
	}
	return abs
}

// DepErrors checks there are any errors resolving dependencies for `pkgpath`. It passes the `go
// list` command the flags specified by `flags`.
func DepErrors(pkgpath string, flags ...string) bool {
	out, err := RunList("{{if .DepsErrors}}error{{else}}{{end}}", []string{pkgpath}, flags...)
	if err != nil {
		// if go list failed, assume dependencies are broken
		return false
	}

	return out != ""
}

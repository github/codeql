package util

import (
	"encoding/json"
	"errors"
	"io"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"
)

var extractorPath string

// Getenv retrieves the value of the environment variable named by the key.  If that variable is not
// present, it iterates over the given aliases until it finds one that is. If none are present, the
// empty string is returned.
func Getenv(key string, aliases ...string) string {
	val := os.Getenv(key)
	if val != "" {
		return val
	}
	for _, alias := range aliases {
		val = os.Getenv(alias)
		if val != "" {
			return val
		}
	}
	return ""
}

// runGoList is a helper function for running go list with format `format` and flags `flags` on
// package `pkgpath`.
func runGoList(format string, pkgpath string, flags ...string) (string, error) {
	return runGoListWithEnv(format, []string{pkgpath}, nil, flags...)
}

// runGoListWithEnv is a helper function for running go list with format `format` and flags `flags`
// on pattern `patterns`, with environment variables `additionalEnv`, which is a slice of strings in
// the format `NAME=VALUE`.
func runGoListWithEnv(format string, patterns []string, additionalEnv []string, flags ...string) (string, error) {
	args := append([]string{"list", "-e", "-f", format}, flags...)
	args = append(args, patterns...)
	cmd := exec.Command("go", args...)
	cmd.Env = append(os.Environ(), additionalEnv...)
	log.Printf("Running cmd: %s", cmd.String())
	out, err := cmd.Output()

	if err != nil {
		if err, ok := err.(*exec.ExitError); ok {
			log.Printf("Warning: go list command failed, output below:\nstdout:\n%s\nstderr:\n%s\n", out, err.Stderr)
		} else {
			log.Printf("Warning: Failed to run go list: %s", err.Error())
		}
		return "", err
	}

	return strings.TrimSpace(string(out)), nil
}

// PkgInfo holds package directory and module directory (if any) for a package
type PkgInfo struct {
	PkgDir string // the directory directly containing source code of this package
	ModDir string // the module directory containing this package, empty if not a module
}

// GetPkgsInfo gets absolute directories of module and package root, where packages are denoted by `patterns`.
// It passes the `go list` the flags specified by `flags`.
// If `includingDeps`, all dependencies will also be included. see `go help list` for `-deps` flag
func GetPkgsInfo(patterns []string, includingDeps bool, flags ...string) (map[string]*PkgInfo, error) {
	// enable module mode so that we can find a module root if it exists, even if go module support is
	// disabled by a build
	if includingDeps {
		// the flag `-deps` causes all dependencies to be retrieved
		flags = append(flags, "-deps")
	}

	// using -json overrides -f format
	output, err := runGoListWithEnv("", patterns, []string{"GO111MODULE=on"}, append(flags, "-json")...)
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
	pkgInfoMapping := make(map[string]*PkgInfo)
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
		pkgInfoMapping[pkgInfo.ImportPath] = &PkgInfo{
			PkgDir: pkgAbsDir,
			ModDir: modAbsDir,
		}
	}
	return pkgInfoMapping, nil
}

// DepErrors checks there are any errors resolving dependencies for `pkgpath`. It passes the `go
// list` command the flags specified by `flags`.
func DepErrors(pkgpath string, flags ...string) bool {
	out, err := runGoList("{{if .DepsErrors}}{{else}}error{{end}}", pkgpath, flags...)
	if err != nil {
		// if go list failed, assume dependencies are broken
		return false
	}

	return out != ""
}

// FileExists tests whether the file at `filename` exists and is not a directory.
func FileExists(filename string) bool {
	info, err := os.Stat(filename)
	if err != nil && !os.IsNotExist(err) {
		log.Printf("Unable to stat %s: %s\n", filename, err.Error())
	}
	return err == nil && !info.IsDir()
}

// DirExists tests whether `filename` exists and is a directory.
func DirExists(filename string) bool {
	info, err := os.Stat(filename)
	if err != nil && !os.IsNotExist(err) {
		log.Printf("Unable to stat %s: %s\n", filename, err.Error())
	}
	return err == nil && info.IsDir()
}

func RunCmd(cmd *exec.Cmd) bool {
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	in, _ := cmd.StdinPipe()
	err := cmd.Start()
	if err != nil {
		log.Printf("Running %s failed, continuing anyway: %s\n", cmd.Path, err.Error())
		return false
	}
	in.Close()
	err = cmd.Wait()
	if err != nil {
		log.Printf("Running %s failed, continuing anyway: %s\n", cmd.Path, err.Error())
		return false
	}

	return true
}

func getOsToolsSubdir() (string, error) {
	platform, set := os.LookupEnv("CODEQL_PLATFORM")
	if set && platform != "" {
		return platform, nil
	}

	switch runtime.GOOS {
	case "darwin":
		return "osx64", nil
	case "linux":
		return "linux64", nil
	case "windows":
		return "win64", nil
	}
	return "", errors.New("Unsupported OS: " + runtime.GOOS)
}

func getExtractorDir() (string, error) {
	extractorRoot := os.Getenv("CODEQL_EXTRACTOR_GO_ROOT")
	if extractorRoot == "" {
		log.Print("CODEQL_EXTRACTOR_GO_ROOT not set.\nThis binary should not be run manually; instead, use the CodeQL CLI or VSCode extension. See https://securitylab.github.com/tools/codeql.\n")
		log.Print("Falling back to guess the root based on this executable's path.\n")

		mypath, err := os.Executable()
		if err == nil {
			return filepath.Dir(mypath), nil
		} else {
			return "", errors.New("CODEQL_EXTRACTOR_GO_ROOT not set, and could not determine path of this executable: " + err.Error())
		}
	}

	osSubdir, err := getOsToolsSubdir()
	if err != nil {
		return "", err
	}

	return filepath.Join(extractorRoot, "tools", osSubdir), nil
}

func GetExtractorPath() (string, error) {
	if extractorPath != "" {
		return extractorPath, nil
	}

	dirname, err := getExtractorDir()
	if err != nil {
		return "", err
	}
	extractorPath := filepath.Join(dirname, "go-extractor")
	if runtime.GOOS == "windows" {
		extractorPath = extractorPath + ".exe"
	}
	return extractorPath, nil
}

func EscapeTrapSpecialChars(s string) string {
	// Replace TRAP special characters with their HTML entities, as well as '&' to avoid ambiguity.
	s = strings.ReplaceAll(s, "&", "&amp;")
	s = strings.ReplaceAll(s, "{", "&lbrace;")
	s = strings.ReplaceAll(s, "}", "&rbrace;")
	s = strings.ReplaceAll(s, "\"", "&quot;")
	s = strings.ReplaceAll(s, "@", "&commat;")
	s = strings.ReplaceAll(s, "#", "&num;")
	return s
}

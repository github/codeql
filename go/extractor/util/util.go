package util

import (
	"errors"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"
)

var extractorPath string

// Getenv retrieves the value of the environment variable named by the key.
// If that variable is not present, it iterates over the given aliases until
// it finds one that is. If none are present, the empty string is returned.
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
	return runGoListWithEnv(format, pkgpath, nil, flags...)
}

func runGoListWithEnv(format string, pkgpath string, additionalEnv []string, flags ...string) (string, error) {
	args := append([]string{"list", "-e", "-f", format}, flags...)
	args = append(args, pkgpath)
	cmd := exec.Command("go", args...)
	cmd.Env = append(os.Environ(), additionalEnv...)
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

// GetModDir gets the absolute directory of the module containing the package with path
// `pkgpath`. It passes the `go list` the flags specified by `flags`.
func GetModDir(pkgpath string, flags ...string) string {
	// enable module mode so that we can find a module root if it exists, even if go module support is
	// disabled by a build
	mod, err := runGoListWithEnv("{{.Module}}", pkgpath, []string{"GO111MODULE=on"}, flags...)
	if err != nil || mod == "<nil>" {
		// if the command errors or modules aren't being used, return the empty string
		return ""
	}

	modDir, err := runGoListWithEnv("{{.Module.Dir}}", pkgpath, []string{"GO111MODULE=on"}, flags...)
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
	pkgDir, err := runGoList("{{.Dir}}", pkgpath, flags...)
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

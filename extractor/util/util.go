package util

import (
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

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
	args := append([]string{"list", "-e", "-f", format}, flags...)
	args = append(args, pkgpath)
	cmd := exec.Command("go", args...)
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
	mod, err := runGoList("{{.Module}}", pkgpath, flags...)
	if err != nil || mod == "<nil>" {
		// if the command errors or modules aren't being used, return the empty string
		return ""
	}

	modDir, err := runGoList("{{.Module.Dir}}", pkgpath, flags...)
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

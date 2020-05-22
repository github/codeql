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

// GetModDir gets directory of the module containing the package with path `pkgpath`.
func GetModDir(pkgpath string) string {
	mod, err := exec.Command("go", "list", "-e", "-f", "{{.Module}}", pkgpath).Output()
	if err != nil {
		if err, ok := err.(*exec.ExitError); ok {
			log.Printf("Warning: go list command failed, output below:\n%s%s", mod, err.Stderr)
		} else {
			log.Printf("Warning: Failed to run go list: %s", err.Error())
		}

		return ""
	}

	if strings.TrimSpace(string(mod)) == "<nil>" {
		// if modules aren't being used, return nothing
		return ""
	}

	modDir, err := exec.Command("go", "list", "-e", "-f", "{{.Module.Dir}}", pkgpath).Output()
	if err != nil {
		if err, ok := err.(*exec.ExitError); ok {
			log.Printf("Warning: go list command failed, output below:\n%s%s", modDir, err.Stderr)
		} else {
			log.Printf("Warning: Failed to run go list: %s", err.Error())
		}

		return ""
	}

	trimmed := strings.TrimSpace(string(modDir))
	abs, err := filepath.Abs(trimmed)
	if err != nil {
		log.Printf("Warning: unable to make %s absolute: %s", trimmed, err.Error())
	}
	return abs
}

// GetPkgDir gets directory containing the package with path `pkgpath`.
func GetPkgDir(pkgpath string) string {
	pkgDir, err := exec.Command("go", "list", "-e", "-f", "{{.Dir}}", pkgpath).Output()
	if err != nil {
		if err, ok := err.(*exec.ExitError); ok {
			log.Printf("Warning: go list command failed, output below:\n%s%s", pkgDir, err.Stderr)
		} else {
			log.Printf("Warning: Failed to run go list: %s", err.Error())
		}

		return ""
	}

	trimmed := strings.TrimSpace(string(pkgDir))
	abs, err := filepath.Abs(trimmed)
	if err != nil {
		log.Printf("Warning: unable to make %s absolute: %s", trimmed, err.Error())
	}
	return abs
}

// FileExists tests whether the file at `filename` exists.
func FileExists(filename string) bool {
	_, err := os.Stat(filename)
	if err != nil && !os.IsNotExist(err) {
		log.Printf("Unable to stat %s: %s\n", filename, err.Error())
	}
	return err == nil
}

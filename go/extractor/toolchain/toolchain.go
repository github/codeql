package toolchain

import (
	"bufio"
	"log"
	"os"
	"os/exec"
	"strings"
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

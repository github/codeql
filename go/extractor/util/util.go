package util

import (
	"errors"
	"fmt"
	"io/fs"
	"log"
	"net/url"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"runtime"
	"slices"
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

// FileExists tests whether the file at `filename` exists and is not a directory.
func FileExists(filename string) bool {
	info, err := os.Stat(filename)
	if err != nil && !errors.Is(err, fs.ErrNotExist) {
		log.Printf("Unable to stat %s: %s\n", filename, err.Error())
	}
	return err == nil && !info.IsDir()
}

// DirExists tests whether `filename` exists and is a directory.
func DirExists(filename string) bool {
	info, err := os.Stat(filename)
	if err != nil && !errors.Is(err, fs.ErrNotExist) {
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
		log.Printf("Running %s %v failed, continuing anyway: %s\n", cmd.Path, cmd.Args, err.Error())
		return false
	}
	in.Close()
	err = cmd.Wait()
	if err != nil {
		log.Printf("Running %s %v failed, continuing anyway: %s\n", cmd.Path, cmd.Args, err.Error())
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

func FindGoFiles(root string) bool {
	found := false
	filepath.WalkDir(root, func(s string, d fs.DirEntry, e error) error {
		if e != nil {
			return e
		}
		if filepath.Ext(d.Name()) == ".go" {
			found = true
			return filepath.SkipAll
		}
		return nil
	})
	return found
}

func FindAllFilesWithName(root string, name string, dirsToSkip ...string) []string {
	paths := make([]string, 0, 1)
	filepath.WalkDir(root, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if d.IsDir() {
			for _, dirToSkip := range dirsToSkip {
				if path == dirToSkip {
					return filepath.SkipDir
				}
			}
		}
		if d.Name() == name {
			paths = append(paths, path)
		}
		return nil
	})
	return paths
}

// Returns an array of any Go source files in locations which do not have a `go.mod`
// file in the same directory or higher up in the file hierarchy, relative to the `root`.
func GoFilesOutsideDirs(root string, dirsToSkip ...string) []string {
	result := []string{}

	filepath.WalkDir(root, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if d.IsDir() && slices.Contains(dirsToSkip, path) {
			return filepath.SkipDir
		}
		if filepath.Ext(d.Name()) == ".go" {
			result = append(result, path)
		}
		return nil
	})

	if len(result) > 0 {
		log.Printf(
			"Found %d stray Go source file(s) in %s\n",
			len(result),
			JoinTruncatedList(result, ", ", 5),
		)
	}

	return result
}

// Joins the `elements` into one string, up to `maxElements`, separated by `sep`.
// If the length of `elements` exceeds `maxElements`, the string "and %d more" is
// appended where `%d` is the number of `elements` that were omitted.
func JoinTruncatedList(elements []string, sep string, maxElements int) string {
	num := len(elements)
	numIncluded := num
	truncated := false
	if num > maxElements {
		numIncluded = maxElements
		truncated = true
	}

	result := strings.Join(elements[0:numIncluded], sep)
	if truncated {
		result += fmt.Sprintf(", and %d more", num-maxElements)
	}

	return result
}

// For every file path in the input array, return the parent directory.
func GetParentDirs(paths []string) []string {
	dirs := make([]string, len(paths))
	for i, path := range paths {
		dirs[i] = filepath.Dir(path)
	}
	return dirs
}

// Returns the import path of the package being built, or "" if it cannot be determined.
func GetImportPath() (importpath string) {
	importpath = os.Getenv("LGTM_INDEX_IMPORT_PATH")
	if importpath == "" {
		repourl := os.Getenv("SEMMLE_REPO_URL")
		if repourl == "" {
			githubrepo := os.Getenv("GITHUB_REPOSITORY")
			if githubrepo == "" {
				log.Printf("Unable to determine import path, as neither LGTM_INDEX_IMPORT_PATH nor GITHUB_REPOSITORY is set\n")
				return ""
			} else {
				importpath = "github.com/" + githubrepo
			}
		} else {
			importpath = getImportPathFromRepoURL(repourl)
			if importpath == "" {
				log.Printf("Failed to determine import path from SEMMLE_REPO_URL '%s'\n", repourl)
				return
			}
		}
	}
	log.Printf("Import path is '%s'\n", importpath)
	return
}

// Returns the import path of the package being built from `repourl`, or "" if it cannot be
// determined.
func getImportPathFromRepoURL(repourl string) string {
	// check for scp-like URL as in "git@github.com:github/codeql-go.git"
	shorturl := regexp.MustCompile(`^([^@]+@)?([^:]+):([^/].*?)(\.git)?$`)
	m := shorturl.FindStringSubmatch(repourl)
	if m != nil {
		return m[2] + "/" + m[3]
	}

	// otherwise parse as proper URL
	u, err := url.Parse(repourl)
	if err != nil {
		log.Fatalf("Malformed repository URL '%s'\n", repourl)
	}

	if u.Scheme == "file" {
		// we can't determine import paths from file paths
		return ""
	}

	if u.Hostname() == "" || u.Path == "" {
		return ""
	}

	host := u.Hostname()
	path := u.Path
	// strip off leading slashes and trailing `.git` if present
	path = regexp.MustCompile(`^/+|\.git$`).ReplaceAllString(path, "")
	return host + "/" + path
}

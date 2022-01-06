package main

import (
	"fmt"
	"golang.org/x/mod/semver"
	"io/ioutil"
	"log"
	"net/url"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"runtime"
	"strings"

	"github.com/github/codeql-go/extractor/autobuilder"
	"github.com/github/codeql-go/extractor/util"
)

func usage() {
	fmt.Fprintf(os.Stderr,
		`%s is a wrapper script that installs dependencies and calls the extractor.

When LGTM_SRC is not set, the script installs dependencies as described below, and then invokes the
extractor in the working directory.

If LGTM_SRC is set, it checks for the presence of the files 'go.mod', 'Gopkg.toml', and
'glide.yaml' to determine how to install dependencies: if a 'Gopkg.toml' file is present, it uses
'dep ensure', if there is a 'glide.yaml' it uses 'glide install', and otherwise 'go get'.
Additionally, unless a 'go.mod' file is detected, it sets up a temporary GOPATH and moves all
source files into a folder corresponding to the package's import path before installing
dependencies.

This behavior can be further customized using environment variables: setting LGTM_INDEX_NEED_GOPATH
to 'false' disables the GOPATH set-up, CODEQL_EXTRACTOR_GO_BUILD_COMMAND (or alternatively
LGTM_INDEX_BUILD_COMMAND), can be set to a newline-separated list of commands to run in order to
install dependencies, and LGTM_INDEX_IMPORT_PATH can be used to override the package import path,
which is otherwise inferred from the SEMMLE_REPO_URL or GITHUB_REPOSITORY environment variables.

In resource-constrained environments, the environment variable CODEQL_EXTRACTOR_GO_MAX_GOROUTINES
(or its legacy alias SEMMLE_MAX_GOROUTINES) can be used to limit the number of parallel goroutines
started by the extractor, which reduces CPU and memory requirements. The default value for this
variable is 32.
`,
		os.Args[0])
	fmt.Fprintf(os.Stderr, "Usage:\n\n  %s\n", os.Args[0])
}

var goVersion = ""

// Returns the current Go version as returned by 'go version', e.g. go1.14.4
func getEnvGoVersion() string {
	if goVersion == "" {
		gover, err := exec.Command("go", "version").CombinedOutput()
		if err != nil {
			log.Fatalf("Unable to run the go command, is it installed?\nError: %s", err.Error())
		}
		goVersion = strings.Fields(string(gover))[2]
	}
	return goVersion
}

// Returns the current Go version in semver format, e.g. v1.14.4
func getEnvGoSemVer() string {
	goVersion := getEnvGoVersion()
	if !strings.HasPrefix(goVersion, "go") {
		log.Fatalf("Expected 'go version' output of the form 'go1.2.3'; got '%s'", goVersion)
	}
	return "v" + goVersion[2:]
}

func tryBuild(buildFile, cmd string, args ...string) bool {
	if util.FileExists(buildFile) {
		log.Printf("%s found, running %s\n", buildFile, cmd)
		return util.RunCmd(exec.Command(cmd, args...))
	}
	return false
}

func getImportPath() (importpath string) {
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

func getImportPathFromRepoURL(repourl string) string {
	// check for scp-like URL as in "git@github.com:github/codeql-go.git"
	shorturl := regexp.MustCompile("^([^@]+@)?([^:]+):([^/].*?)(\\.git)?$")
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
	path = regexp.MustCompile("^/+|\\.git$").ReplaceAllString(path, "")
	return host + "/" + path
}

func restoreRepoLayout(fromDir string, dirEntries []string, scratchDirName string, toDir string) {
	for _, dirEntry := range dirEntries {
		if dirEntry != scratchDirName {
			log.Printf("Restoring %s/%s to %s/%s.\n", fromDir, dirEntry, toDir, dirEntry)
			err := os.Rename(filepath.Join(fromDir, dirEntry), filepath.Join(toDir, dirEntry))
			if err != nil {
				log.Printf("Failed to move file/directory %s from directory %s to directory %s: %s\n", dirEntry, fromDir, toDir, err.Error())
			}
		}
	}
}

// DependencyInstallerMode is an enum describing how dependencies should be installed
type DependencyInstallerMode int

const (
	// GoGetNoModules represents dependency installation using `go get` without modules
	GoGetNoModules DependencyInstallerMode = iota
	// GoGetWithModules represents dependency installation using `go get` with modules
	GoGetWithModules
	// Dep represent dependency installation using `dep ensure`
	Dep
	// Glide represents dependency installation using `glide install`
	Glide
)

// ModMode corresponds to the possible values of the -mod flag for the Go compiler
type ModMode int

const (
	ModUnset ModMode = iota
	ModReadonly
	ModMod
	ModVendor
)

func (m ModMode) argsForGoVersion(version string) []string {
	switch m {
	case ModUnset:
		return []string{}
	case ModReadonly:
		return []string{"-mod=readonly"}
	case ModMod:
		if !semver.IsValid(version) {
			log.Fatalf("Invalid Go semver: '%s'", version)
		}
		if semver.Compare(version, "v1.14") < 0 {
			return []string{} // -mod=mod is the default behaviour for go <= 1.13, and is not accepted as an argument
		} else {
			return []string{"-mod=mod"}
		}
	case ModVendor:
		return []string{"-mod=vendor"}
	}
	return nil
}

// addVersionToMod add a go version directive, e.g. `go 1.14` to a `go.mod` file.
func addVersionToMod(goMod []byte, version string) bool {
	cmd := exec.Command("go", "mod", "edit", "-go="+version)
	return util.RunCmd(cmd)
}

// checkVendor tests to see whether a vendor directory is inconsistent according to the go frontend
func checkVendor() bool {
	vendorCheckCmd := exec.Command("go", "list", "-mod=vendor", "./...")
	outp, err := vendorCheckCmd.CombinedOutput()
	if err != nil {
		badVendorRe := regexp.MustCompile(`(?m)^go: inconsistent vendoring in .*:$`)
		return !badVendorRe.Match(outp)
	}

	return true
}

func main() {
	if len(os.Args) > 1 {
		usage()
		os.Exit(2)
	}

	log.Printf("Autobuilder was built with %s, environment has %s\n", runtime.Version(), getEnvGoVersion())

	srcdir := os.Getenv("LGTM_SRC")
	inLGTM := srcdir != ""
	if inLGTM {
		log.Printf("LGTM_SRC is %s\n", srcdir)
	} else {
		cwd, err := os.Getwd()
		if err != nil {
			log.Fatalln("Failed to get current working directory.")
		}
		log.Printf("LGTM_SRC is not set; defaulting to current working directory %s\n", cwd)
		srcdir = cwd
	}

	// we set `SEMMLE_PATH_TRANSFORMER` ourselves in some cases, so blank it out first for consistency
	os.Setenv("SEMMLE_PATH_TRANSFORMER", "")

	// determine how to install dependencies and whether a GOPATH needs to be set up before
	// extraction
	depMode := GoGetNoModules
	modMode := ModUnset
	needGopath := true
	if _, present := os.LookupEnv("GO111MODULE"); !present {
		os.Setenv("GO111MODULE", "auto")
	}
	if util.FileExists("go.mod") {
		depMode = GoGetWithModules
		needGopath = false
		log.Println("Found go.mod, enabling go modules")
	} else if util.FileExists("Gopkg.toml") {
		depMode = Dep
		log.Println("Found Gopkg.toml, using dep instead of go get")
	} else if util.FileExists("glide.yaml") {
		depMode = Glide
		log.Println("Found glide.yaml, enabling go modules")
	}

	if depMode == GoGetWithModules {
		// if a vendor/modules.txt file exists, we assume that there are vendored Go dependencies, and
		// skip the dependency installation step and run the extractor with `-mod=vendor`
		if util.FileExists("vendor/modules.txt") {
			modMode = ModVendor
		} else if util.DirExists("vendor") {
			modMode = ModMod
		}
	}

	if modMode == ModVendor {
		// fix go vendor issues with go versions >= 1.14 when no go version is specified in the go.mod
		// if this is the case, and dependencies were vendored with an old go version (and therefore
		// do not contain a '## explicit' annotation, the go command will fail and refuse to do any
		// work
		//
		// we work around this by adding an explicit go version of 1.13, which is the last version
		// where this is not an issue
		if depMode == GoGetWithModules {
			goMod, err := ioutil.ReadFile("go.mod")
			if err != nil {
				log.Println("Failed to read go.mod to check for missing Go version")
			} else if versionRe := regexp.MustCompile(`(?m)^go[ \t\r]+[0-9]+\.[0-9]+$`); !versionRe.Match(goMod) {
				// if the go.mod does not contain a version line
				modulesTxt, err := ioutil.ReadFile("vendor/modules.txt")
				if err != nil {
					log.Println("Failed to read vendor/modules.txt to check for mismatched Go version")
				} else if explicitRe := regexp.MustCompile("(?m)^## explicit$"); !explicitRe.Match(modulesTxt) {
					// and the modules.txt does not contain an explicit annotation
					log.Println("Adding a version directive to the go.mod file as the modules.txt does not have explicit annotations")
					if !addVersionToMod(goMod, "1.13") {
						log.Println("Failed to add a version to the go.mod file to fix explicitly required package bug; not using vendored dependencies")
						modMode = ModMod
					}
				}
			}
		}
	}

	// if `LGTM_INDEX_NEED_GOPATH` is set, it overrides the value for `needGopath` inferred above
	if needGopathOverride := os.Getenv("LGTM_INDEX_NEED_GOPATH"); needGopathOverride != "" {
		inLGTM = true
		if needGopathOverride == "true" {
			needGopath = true
		} else if needGopathOverride == "false" {
			needGopath = false
		} else {
			log.Fatalf("Unexpected value for Boolean environment variable LGTM_NEED_GOPATH: %v.\n", needGopathOverride)
		}
	}

	importpath := getImportPath()
	if needGopath && importpath == "" {
		log.Printf("Failed to determine import path, not setting up GOPATH")
		needGopath = false
	}

	if inLGTM && needGopath {
		// a temporary directory where everything is moved while the correct
		// directory structure is created.
		scratch, err := ioutil.TempDir(srcdir, "scratch")
		if err != nil {
			log.Fatalf("Failed to create temporary directory %s in directory %s: %s\n",
				scratch, srcdir, err.Error())
		}
		log.Printf("Temporary directory is %s.\n", scratch)

		// move all files in `srcdir` to `scratch`
		dir, err := os.Open(srcdir)
		if err != nil {
			log.Fatalf("Failed to open source directory %s for reading: %s\n", srcdir, err.Error())
		}
		files, err := dir.Readdirnames(-1)
		if err != nil {
			log.Fatalf("Failed to read source directory %s: %s\n", srcdir, err.Error())
		}
		for _, file := range files {
			if file != filepath.Base(scratch) {
				log.Printf("Moving %s/%s to %s/%s.\n", srcdir, file, scratch, file)
				err := os.Rename(filepath.Join(srcdir, file), filepath.Join(scratch, file))
				if err != nil {
					log.Fatalf("Failed to move file %s to the temporary directory: %s\n", file, err.Error())
				}
			}
		}

		// create a new folder which we will add to GOPATH below
		// Note we evaluate all symlinks here for consistency: otherwise os.Chdir below
		// will follow links but other references to the path may not, which can lead to
		// disagreements between GOPATH and the working directory.
		realSrc, err := filepath.EvalSymlinks(srcdir)
		if err != nil {
			log.Fatalf("Failed to evaluate symlinks in %s: %s\n", srcdir, err.Error())
		}

		root := filepath.Join(realSrc, "root")

		// move source files to where Go expects them to be
		newdir := filepath.Join(root, "src", importpath)
		err = os.MkdirAll(filepath.Dir(newdir), 0755)
		if err != nil {
			log.Fatalf("Failed to create directory %s: %s\n", newdir, err.Error())
		}
		log.Printf("Moving %s to %s.\n", scratch, newdir)
		err = os.Rename(scratch, newdir)
		if err != nil {
			log.Fatalf("Failed to rename %s to %s: %s\n", scratch, newdir, err.Error())
		}

		// schedule restoring the contents of newdir to their original location after this function completes:
		defer restoreRepoLayout(newdir, files, filepath.Base(scratch), srcdir)

		err = os.Chdir(newdir)
		if err != nil {
			log.Fatalf("Failed to chdir into %s: %s\n", newdir, err.Error())
		}

		// set up SEMMLE_PATH_TRANSFORMER to ensure paths in the source archive and the snapshot
		// match the original source location, not the location we moved it to
		pt, err := ioutil.TempFile("", "path-transformer")
		if err != nil {
			log.Fatalf("Unable to create path transformer file: %s.", err.Error())
		}
		defer os.Remove(pt.Name())
		_, err = pt.WriteString("#" + realSrc + "\n" + newdir + "//\n")
		if err != nil {
			log.Fatalf("Unable to write path transformer file: %s.", err.Error())
		}
		err = pt.Close()
		if err != nil {
			log.Fatalf("Unable to close path transformer file: %s.", err.Error())
		}
		err = os.Setenv("SEMMLE_PATH_TRANSFORMER", pt.Name())
		if err != nil {
			log.Fatalf("Unable to set SEMMLE_PATH_TRANSFORMER environment variable: %s.\n", err.Error())
		}

		// set/extend GOPATH
		oldGopath := os.Getenv("GOPATH")
		var newGopath string
		if oldGopath != "" {
			newGopath = strings.Join(
				[]string{root, oldGopath},
				string(os.PathListSeparator),
			)
		} else {
			newGopath = root
		}
		err = os.Setenv("GOPATH", newGopath)
		if err != nil {
			log.Fatalf("Unable to set GOPATH to %s: %s\n", newGopath, err.Error())
		}
		log.Printf("GOPATH set to %s.\n", newGopath)
	}

	// check whether an explicit dependency installation command was provided
	inst := util.Getenv("CODEQL_EXTRACTOR_GO_BUILD_COMMAND", "LGTM_INDEX_BUILD_COMMAND")
	shouldInstallDependencies := false
	if inst == "" {
		// try to build the project
		buildSucceeded := autobuilder.Autobuild()

		// Build failed or there are still dependency errors; we'll try to install dependencies
		// ourselves
		if !buildSucceeded {
			log.Println("Build failed, continuing to install dependencies.")

			shouldInstallDependencies = true
		} else if util.DepErrors("./...", modMode.argsForGoVersion(getEnvGoSemVer())...) {
			log.Println("Dependencies are still not resolving after the build, continuing to install dependencies.")

			shouldInstallDependencies = true
		}
	} else {
		// write custom build commands into a script, then run it
		var (
			ext    = ""
			header = ""
			footer = ""
		)
		if runtime.GOOS == "windows" {
			ext = ".cmd"
			header = "@echo on\n@prompt +$S\n"
			footer = "\nIF %ERRORLEVEL% NEQ 0 EXIT"
		} else {
			ext = ".sh"
			header = "#! /bin/bash\nset -xe +u\n"
		}
		script, err := ioutil.TempFile("", "go-build-command-*"+ext)
		if err != nil {
			log.Fatalf("Unable to create temporary script holding custom build commands: %s\n", err.Error())
		}
		defer os.Remove(script.Name())
		_, err = script.WriteString(header + inst + footer)
		if err != nil {
			log.Fatalf("Unable to write to temporary script holding custom build commands: %s\n", err.Error())
		}
		err = script.Close()
		if err != nil {
			log.Fatalf("Unable to close temporary script holding custom build commands: %s\n", err.Error())
		}
		os.Chmod(script.Name(), 0700)
		log.Println("Installing dependencies using custom build command.")
		util.RunCmd(exec.Command(script.Name()))
	}

	if modMode == ModVendor {
		// test if running `go` with -mod=vendor works, and if it doesn't, try to fallback to -mod=mod
		// or not set if the go version < 1.14. Note we check this post-build in case the build brings
		// the vendor directory up to date.
		if !checkVendor() {
			modMode = ModMod
			log.Println("The vendor directory is not consistent with the go.mod; not using vendored dependencies.")
		}
	}

	if shouldInstallDependencies {
		if modMode == ModVendor {
			log.Printf("Skipping dependency installation because a Go vendor directory was found.")
		} else {
			// automatically determine command to install dependencies
			var install *exec.Cmd
			if depMode == Dep {
				// set up the dep cache if SEMMLE_CACHE is set
				cacheDir := os.Getenv("SEMMLE_CACHE")
				if cacheDir != "" {
					depCacheDir := filepath.Join(cacheDir, "go", "dep")
					log.Printf("Attempting to create dep cache dir %s\n", depCacheDir)
					err := os.MkdirAll(depCacheDir, 0755)
					if err != nil {
						log.Printf("Failed to create dep cache directory: %s\n", err.Error())
					} else {
						log.Printf("Setting dep cache directory to %s\n", depCacheDir)
						err = os.Setenv("DEPCACHEDIR", depCacheDir)
						if err != nil {
							log.Println("Failed to set dep cache directory")
						} else {
							err = os.Setenv("DEPCACHEAGE", "720h") // 30 days
							if err != nil {
								log.Println("Failed to set dep cache age")
							}
						}
					}
				}

				if util.FileExists("Gopkg.lock") {
					// if Gopkg.lock exists, don't update it and only vendor dependencies
					install = exec.Command("dep", "ensure", "-v", "-vendor-only")
				} else {
					install = exec.Command("dep", "ensure", "-v")
				}
				log.Println("Installing dependencies using `dep ensure`.")
			} else if depMode == Glide {
				install = exec.Command("glide", "install")
				log.Println("Installing dependencies using `glide install`")
			} else {
				// explicitly set go module support
				if depMode == GoGetWithModules {
					os.Setenv("GO111MODULE", "on")
				} else if depMode == GoGetNoModules {
					os.Setenv("GO111MODULE", "off")
				}

				// get dependencies
				install = exec.Command("go", "get", "-v", "./...")
				log.Println("Installing dependencies using `go get -v ./...`.")
			}
			util.RunCmd(install)
		}
	}

	// extract
	extractor, err := util.GetExtractorPath()
	if err != nil {
		log.Fatalf("Could not determine path of extractor: %v.\n", err)
	}

	cwd, err := os.Getwd()
	if err != nil {
		log.Fatalf("Unable to determine current directory: %s\n", err.Error())
	}

	extractorArgs := []string{}
	if depMode == GoGetWithModules {
		extractorArgs = append(extractorArgs, modMode.argsForGoVersion(getEnvGoSemVer())...)
	}
	extractorArgs = append(extractorArgs, "./...")

	log.Printf("Running extractor command '%s %v' from directory '%s'.\n", extractor, extractorArgs, cwd)
	cmd := exec.Command(extractor, extractorArgs...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err = cmd.Run()
	if err != nil {
		log.Fatalf("Extraction failed: %s\n", err.Error())
	}
}

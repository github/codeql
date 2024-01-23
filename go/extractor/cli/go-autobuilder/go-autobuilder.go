package main

import (
	"fmt"
	"log"
	"net/url"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"runtime"
	"strings"

	"golang.org/x/mod/semver"

	"github.com/github/codeql-go/extractor/autobuilder"
	"github.com/github/codeql-go/extractor/diagnostics"
	"github.com/github/codeql-go/extractor/project"
	"github.com/github/codeql-go/extractor/toolchain"
	"github.com/github/codeql-go/extractor/util"
)

func usage() {
	fmt.Fprintf(os.Stderr,
		`%s is a wrapper script that installs dependencies and calls the extractor

Options:
  --identify-environment
    Output some json on stdout specifying which Go version should be installed in the environment
	so that autobuilding will be successful.

Build behavior:

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

// Returns the current Go version in semver format, e.g. v1.14.4
func getEnvGoSemVer() string {
	goVersion := toolchain.GetEnvGoVersion()
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

// Returns the import path of the package being built, or "" if it cannot be determined.
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

// addVersionToMod add a go version directive, e.g. `go 1.14` to a `go.mod` file.
func addVersionToMod(version string) bool {
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

// Returns the directory containing the source code to be analyzed.
func getSourceDir() string {
	srcdir := os.Getenv("LGTM_SRC")
	if srcdir != "" {
		log.Printf("LGTM_SRC is %s\n", srcdir)
	} else {
		cwd, err := os.Getwd()
		if err != nil {
			log.Fatalln("Failed to get current working directory.")
		}
		log.Printf("LGTM_SRC is not set; defaulting to current working directory %s\n", cwd)
		srcdir = cwd
	}
	return srcdir
}

// fixGoVendorIssues fixes issues with go vendor for go version >= 1.14
func fixGoVendorIssues(buildInfo *project.BuildInfo, goModVersionFound bool) {
	if buildInfo.ModMode == project.ModVendor {
		// fix go vendor issues with go versions >= 1.14 when no go version is specified in the go.mod
		// if this is the case, and dependencies were vendored with an old go version (and therefore
		// do not contain a '## explicit' annotation, the go command will fail and refuse to do any
		// work
		//
		// we work around this by adding an explicit go version of 1.13, which is the last version
		// where this is not an issue
		if buildInfo.DepMode == project.GoGetWithModules {
			if !goModVersionFound {
				// if the go.mod does not contain a version line
				modulesTxt, err := os.ReadFile("vendor/modules.txt")
				if err != nil {
					log.Println("Failed to read vendor/modules.txt to check for mismatched Go version")
				} else if explicitRe := regexp.MustCompile("(?m)^## explicit$"); !explicitRe.Match(modulesTxt) {
					// and the modules.txt does not contain an explicit annotation
					log.Println("Adding a version directive to the go.mod file as the modules.txt does not have explicit annotations")
					if !addVersionToMod("1.13") {
						log.Println("Failed to add a version to the go.mod file to fix explicitly required package bug; not using vendored dependencies")
						buildInfo.ModMode = project.ModMod
					}
				}
			}
		}
	}
}

// Determines whether the project needs a GOPATH set up
func getNeedGopath(buildInfo project.BuildInfo, importpath string) bool {
	needGopath := true
	if buildInfo.DepMode == project.GoGetWithModules {
		needGopath = false
	}
	// if `LGTM_INDEX_NEED_GOPATH` is set, it overrides the value for `needGopath` inferred above
	if needGopathOverride := os.Getenv("LGTM_INDEX_NEED_GOPATH"); needGopathOverride != "" {
		if needGopathOverride == "true" {
			needGopath = true
		} else if needGopathOverride == "false" {
			needGopath = false
		} else {
			log.Fatalf("Unexpected value for Boolean environment variable LGTM_NEED_GOPATH: %v.\n", needGopathOverride)
		}
	}
	if needGopath && importpath == "" {
		log.Printf("Failed to determine import path, not setting up GOPATH")
		needGopath = false
	}
	return needGopath
}

// Try to update `go.mod` and `go.sum` if the go version is >= 1.16.
func tryUpdateGoModAndGoSum(buildInfo project.BuildInfo) {
	// Go 1.16 and later won't automatically attempt to update go.mod / go.sum during package loading, so try to update them here:
	if buildInfo.ModMode != project.ModVendor && buildInfo.DepMode == project.GoGetWithModules && semver.Compare(getEnvGoSemVer(), "v1.16") >= 0 {
		// stat go.mod and go.sum
		goModPath := filepath.Join(buildInfo.BaseDir, "go.mod")
		beforeGoModFileInfo, beforeGoModErr := os.Stat(goModPath)
		if beforeGoModErr != nil {
			log.Println("Failed to stat go.mod before running `go mod tidy -e`")
		}

		goSumPath := filepath.Join(buildInfo.BaseDir, "go.sum")
		beforeGoSumFileInfo, beforeGoSumErr := os.Stat(goSumPath)

		// run `go mod tidy -e`
		cmd := exec.Command("go", "mod", "tidy", "-e")
		cmd.Dir = buildInfo.BaseDir
		res := util.RunCmd(cmd)

		if !res {
			log.Println("Failed to run `go mod tidy -e`")
		} else {
			if beforeGoModFileInfo != nil {
				afterGoModFileInfo, afterGoModErr := os.Stat(goModPath)
				if afterGoModErr != nil {
					log.Println("Failed to stat go.mod after running `go mod tidy -e`")
				} else if afterGoModFileInfo.ModTime().After(beforeGoModFileInfo.ModTime()) {
					// if go.mod has been changed then notify the user
					log.Println("We have run `go mod tidy -e` and it altered go.mod. You may wish to check these changes into version control. ")
				}
			}

			afterGoSumFileInfo, afterGoSumErr := os.Stat(goSumPath)
			if afterGoSumErr != nil {
				log.Println("Failed to stat go.sum after running `go mod tidy -e`")
			} else {
				if beforeGoSumErr != nil || afterGoSumFileInfo.ModTime().After(beforeGoSumFileInfo.ModTime()) {
					// if go.sum has been changed then notify the user
					log.Println("We have run `go mod tidy -e` and it altered go.sum. You may wish to check these changes into version control. ")
				}
			}
		}
	}
}

type moveGopathInfo struct {
	scratch, realSrc, root, newdir string
	files                          []string
}

// Moves all files in `srcdir` to a temporary directory with the correct layout to be added to the GOPATH
func moveToTemporaryGopath(srcdir string, importpath string) moveGopathInfo {
	// a temporary directory where everything is moved while the correct
	// directory structure is created.
	scratch, err := os.MkdirTemp(srcdir, "scratch")
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

	return moveGopathInfo{
		scratch: scratch,
		realSrc: realSrc,
		root:    root,
		newdir:  newdir,
		files:   files,
	}
}

// Creates a path transformer file in the new directory to ensure paths in the source archive and the snapshot
// match the original source location, not the location we moved it to.
func createPathTransformerFile(newdir string) *os.File {
	err := os.Chdir(newdir)
	if err != nil {
		log.Fatalf("Failed to chdir into %s: %s\n", newdir, err.Error())
	}

	// set up SEMMLE_PATH_TRANSFORMER to ensure paths in the source archive and the snapshot
	// match the original source location, not the location we moved it to
	pt, err := os.CreateTemp("", "path-transformer")
	if err != nil {
		log.Fatalf("Unable to create path transformer file: %s.", err.Error())
	}
	return pt
}

// Writes the path transformer file
func writePathTransformerFile(pt *os.File, realSrc, root, newdir string) {
	_, err := pt.WriteString("#" + realSrc + "\n" + newdir + "//\n")
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
}

// Adds `root` to GOPATH.
func setGopath(root string) {
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
	err := os.Setenv("GOPATH", newGopath)
	if err != nil {
		log.Fatalf("Unable to set GOPATH to %s: %s\n", newGopath, err.Error())
	}
	log.Printf("GOPATH set to %s.\n", newGopath)
}

// Try to build the project without custom commands. If that fails, return a boolean indicating
// that we should install dependencies ourselves.
func buildWithoutCustomCommands(modMode project.ModMode) bool {
	shouldInstallDependencies := false
	// try to build the project
	buildSucceeded := autobuilder.Autobuild()

	// Build failed or there are still dependency errors; we'll try to install dependencies
	// ourselves
	if !buildSucceeded {
		log.Println("Build failed, continuing to install dependencies.")

		shouldInstallDependencies = true
	} else if util.DepErrors("./...", modMode.ArgsForGoVersion(getEnvGoSemVer())...) {
		log.Println("Dependencies are still not resolving after the build, continuing to install dependencies.")

		shouldInstallDependencies = true
	}
	return shouldInstallDependencies
}

// Build the project with custom commands.
func buildWithCustomCommands(inst string) {
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
	script, err := os.CreateTemp("", "go-build-command-*"+ext)
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

// Install dependencies using the given dependency installer mode.
func installDependencies(buildInfo project.BuildInfo) {
	// automatically determine command to install dependencies
	var install *exec.Cmd
	if buildInfo.DepMode == project.Dep {
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
	} else if buildInfo.DepMode == project.Glide {
		install = exec.Command("glide", "install")
		log.Println("Installing dependencies using `glide install`")
	} else {
		// explicitly set go module support
		if buildInfo.DepMode == project.GoGetWithModules {
			os.Setenv("GO111MODULE", "on")
		} else if buildInfo.DepMode == project.GoGetNoModules {
			os.Setenv("GO111MODULE", "off")
		}

		// get dependencies
		install = exec.Command("go", "get", "-v", "./...")
		install.Dir = buildInfo.BaseDir
		log.Printf("Installing dependencies using `go get -v ./...` in `%s`.\n", buildInfo.BaseDir)
	}
	util.RunCmd(install)
}

// Run the extractor.
func extract(buildInfo project.BuildInfo) {
	extractor, err := util.GetExtractorPath()
	if err != nil {
		log.Fatalf("Could not determine path of extractor: %v.\n", err)
	}

	extractorArgs := []string{}
	if buildInfo.DepMode == project.GoGetWithModules {
		extractorArgs = append(extractorArgs, buildInfo.ModMode.ArgsForGoVersion(getEnvGoSemVer())...)
	}
	extractorArgs = append(extractorArgs, "./...")

	log.Printf("Running extractor command '%s %v' from directory '%s'.\n", extractor, extractorArgs, buildInfo.BaseDir)
	cmd := exec.Command(extractor, extractorArgs...)
	cmd.Dir = buildInfo.BaseDir
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err = cmd.Run()
	if err != nil {
		log.Fatalf("Extraction failed: %s\n", err.Error())
	}
}

// Build the project and run the extractor.
func installDependenciesAndBuild() {
	log.Printf("Autobuilder was built with %s, environment has %s\n", runtime.Version(), toolchain.GetEnvGoVersion())

	srcdir := getSourceDir()

	// we set `SEMMLE_PATH_TRANSFORMER` ourselves in some cases, so blank it out first for consistency
	os.Setenv("SEMMLE_PATH_TRANSFORMER", "")

	// determine how to install dependencies and whether a GOPATH needs to be set up before
	// extraction
	buildInfo := project.GetBuildInfo(true)
	if _, present := os.LookupEnv("GO111MODULE"); !present {
		os.Setenv("GO111MODULE", "auto")
	}

	goVersionInfo := project.TryReadGoDirective(buildInfo)

	// This diagnostic is not required if the system Go version is 1.21 or greater, since the
	// Go tooling should install required Go versions as needed.
	if semver.Compare(getEnvGoSemVer(), "v1.21.0") < 0 && goVersionInfo.Found && semver.Compare("v"+goVersionInfo.Version, getEnvGoSemVer()) > 0 {
		diagnostics.EmitNewerGoVersionNeeded()
		if val, _ := os.LookupEnv("GITHUB_ACTIONS"); val == "true" {
			log.Printf("The go.mod version is newer than the installed version of Go. Consider adding an actions/setup-go step to your workflow.\n")
		}
	}

	fixGoVendorIssues(&buildInfo, goVersionInfo.Found)

	tryUpdateGoModAndGoSum(buildInfo)

	importpath := getImportPath()
	needGopath := getNeedGopath(buildInfo, importpath)

	inLGTM := os.Getenv("LGTM_SRC") != "" || os.Getenv("LGTM_INDEX_NEED_GOPATH") != ""

	if inLGTM && needGopath {
		paths := moveToTemporaryGopath(srcdir, importpath)

		// schedule restoring the contents of newdir to their original location after this function completes:
		defer restoreRepoLayout(paths.newdir, paths.files, filepath.Base(paths.scratch), srcdir)

		pt := createPathTransformerFile(paths.newdir)
		defer os.Remove(pt.Name())

		writePathTransformerFile(pt, paths.realSrc, paths.root, paths.newdir)
		setGopath(paths.root)
	}

	// check whether an explicit dependency installation command was provided
	inst := util.Getenv("CODEQL_EXTRACTOR_GO_BUILD_COMMAND", "LGTM_INDEX_BUILD_COMMAND")
	shouldInstallDependencies := false
	if inst == "" {
		shouldInstallDependencies = buildWithoutCustomCommands(buildInfo.ModMode)
	} else {
		buildWithCustomCommands(inst)
	}

	if buildInfo.ModMode == project.ModVendor {
		// test if running `go` with -mod=vendor works, and if it doesn't, try to fallback to -mod=mod
		// or not set if the go version < 1.14. Note we check this post-build in case the build brings
		// the vendor directory up to date.
		if !checkVendor() {
			buildInfo.ModMode = project.ModMod
			log.Println("The vendor directory is not consistent with the go.mod; not using vendored dependencies.")
		}
	}

	if shouldInstallDependencies {
		if buildInfo.ModMode == project.ModVendor {
			log.Printf("Skipping dependency installation because a Go vendor directory was found.")
		} else {
			installDependencies(buildInfo)
		}
	}

	extract(buildInfo)
}

const minGoVersion = "1.11"
const maxGoVersion = "1.21"

// Check if `version` is lower than `minGoVersion`. Note that for this comparison we ignore the
// patch part of the version, so 1.20.1 and 1.20 are considered equal.
func belowSupportedRange(version string) bool {
	return semver.Compare(semver.MajorMinor("v"+version), "v"+minGoVersion) < 0
}

// Check if `version` is higher than `maxGoVersion`. Note that for this comparison we ignore the
// patch part of the version, so 1.20.1 and 1.20 are considered equal.
func aboveSupportedRange(version string) bool {
	return semver.Compare(semver.MajorMinor("v"+version), "v"+maxGoVersion) > 0
}

// Check if `version` is lower than `minGoVersion` or higher than `maxGoVersion`. Note that for
// this comparison we ignore the patch part of the version, so 1.20.1 and 1.20 are considered
// equal.
func outsideSupportedRange(version string) bool {
	return belowSupportedRange(version) || aboveSupportedRange(version)
}

// Assuming `v.goModVersionFound` is false, emit a diagnostic and return the version to install,
// or the empty string if we should not attempt to install a version of Go.
func getVersionWhenGoModVersionNotFound(v versionInfo) (msg, version string) {
	if !v.goEnvVersionFound {
		// There is no Go version installed in the environment. We have no indication which version
		// was intended to be used to build this project. Go versions are generally backwards
		// compatible, so we install the maximum supported version.
		msg = "No version of Go installed and no `go.mod` file found. Requesting the maximum " +
			"supported version of Go (" + maxGoVersion + ")."
		version = maxGoVersion
		diagnostics.EmitNoGoModAndNoGoEnv(msg)
	} else if outsideSupportedRange(v.goEnvVersion) {
		// The Go version installed in the environment is not supported. We have no indication
		// which version was intended to be used to build this project. Go versions are generally
		// backwards compatible, so we install the maximum supported version.
		msg = "No `go.mod` file found. The version of Go installed in the environment (" +
			v.goEnvVersion + ") is outside of the supported range (" + minGoVersion + "-" +
			maxGoVersion + "). Requesting the maximum supported version of Go (" + maxGoVersion +
			")."
		version = maxGoVersion
		diagnostics.EmitNoGoModAndGoEnvUnsupported(msg)
	} else {
		// The version of Go that is installed is supported. We have no indication which version
		// was intended to be used to build this project. We assume that the installed version is
		// suitable and do not install a version of Go.
		msg = "No `go.mod` file found. Version " + v.goEnvVersion + " installed in the " +
			"environment is supported. Not requesting any version of Go."
		version = ""
		diagnostics.EmitNoGoModAndGoEnvSupported(msg)
	}

	return msg, version
}

// Assuming `v.goModVersion` is above the supported range, emit a diagnostic and return the
// version to install, or the empty string if we should not attempt to install a version of Go.
func getVersionWhenGoModVersionTooHigh(v versionInfo) (msg, version string) {
	if !v.goEnvVersionFound {
		// The version in the `go.mod` file is above the supported range. There is no Go version
		// installed. We install the maximum supported version as a best effort.
		msg = "The version of Go found in the `go.mod` file (" + v.goModVersion +
			") is above the supported range (" + minGoVersion + "-" + maxGoVersion +
			"). No version of Go installed. Requesting the maximum supported version of Go (" +
			maxGoVersion + ")."
		version = maxGoVersion
		diagnostics.EmitGoModVersionTooHighAndNoGoEnv(msg)
	} else if aboveSupportedRange(v.goEnvVersion) {
		// The version in the `go.mod` file is above the supported range. The version of Go that
		// is installed is above the supported range. We do not install a version of Go.
		msg = "The version of Go found in the `go.mod` file (" + v.goModVersion +
			") is above the supported range (" + minGoVersion + "-" + maxGoVersion +
			"). The version of Go installed in the environment (" + v.goEnvVersion +
			") is above the supported range (" + minGoVersion + "-" + maxGoVersion +
			"). Not requesting any version of Go."
		version = ""
		diagnostics.EmitGoModVersionTooHighAndEnvVersionTooHigh(msg)
	} else if belowSupportedRange(v.goEnvVersion) {
		// The version in the `go.mod` file is above the supported range. The version of Go that
		// is installed is below the supported range. We install the maximum supported version as
		// a best effort.
		msg = "The version of Go found in the `go.mod` file (" + v.goModVersion +
			") is above the supported range (" + minGoVersion + "-" + maxGoVersion +
			"). The version of Go installed in the environment (" + v.goEnvVersion +
			") is below the supported range (" + minGoVersion + "-" + maxGoVersion +
			"). Requesting the maximum supported version of Go (" + maxGoVersion + ")."
		version = maxGoVersion
		diagnostics.EmitGoModVersionTooHighAndEnvVersionTooLow(msg)
	} else if semver.Compare("v"+maxGoVersion, "v"+v.goEnvVersion) > 0 {
		// The version in the `go.mod` file is above the supported range. The version of Go that
		// is installed is supported and below the maximum supported version. We install the
		// maximum supported version as a best effort.
		msg = "The version of Go found in the `go.mod` file (" + v.goModVersion +
			") is above the supported range (" + minGoVersion + "-" + maxGoVersion +
			"). The version of Go installed in the environment (" + v.goEnvVersion +
			") is below the maximum supported version (" + maxGoVersion +
			"). Requesting the maximum supported version of Go (" + maxGoVersion + ")."
		version = maxGoVersion
		diagnostics.EmitGoModVersionTooHighAndEnvVersionBelowMax(msg)
	} else {
		// The version in the `go.mod` file is above the supported range. The version of Go that
		// is installed is the maximum supported version. We do not install a version of Go.
		msg = "The version of Go found in the `go.mod` file (" + v.goModVersion +
			") is above the supported range (" + minGoVersion + "-" + maxGoVersion +
			"). The version of Go installed in the environment (" + v.goEnvVersion +
			") is the maximum supported version (" + maxGoVersion +
			"). Not requesting any version of Go."
		version = ""
		diagnostics.EmitGoModVersionTooHighAndEnvVersionMax(msg)
	}

	return msg, version
}

// Assuming `v.goModVersion` is below the supported range, emit a diagnostic and return the
// version to install, or the empty string if we should not attempt to install a version of Go.
func getVersionWhenGoModVersionTooLow(v versionInfo) (msg, version string) {
	if !v.goEnvVersionFound {
		// There is no Go version installed. The version in the `go.mod` file is below the
		// supported range. Go versions are generally backwards compatible, so we install the
		// minimum supported version.
		msg = "The version of Go found in the `go.mod` file (" + v.goModVersion +
			") is below the supported range (" + minGoVersion + "-" + maxGoVersion +
			"). No version of Go installed. Requesting the minimum supported version of Go (" +
			minGoVersion + ")."
		version = minGoVersion
		diagnostics.EmitGoModVersionTooLowAndNoGoEnv(msg)
	} else if outsideSupportedRange(v.goEnvVersion) {
		// The version of Go that is installed is outside of the supported range. The version
		// in the `go.mod` file is below the supported range. Go versions are generally
		// backwards compatible, so we install the minimum supported version.
		msg = "The version of Go found in the `go.mod` file (" + v.goModVersion +
			") is below the supported range (" + minGoVersion + "-" + maxGoVersion +
			"). The version of Go installed in the environment (" + v.goEnvVersion +
			") is outside of the supported range (" + minGoVersion + "-" + maxGoVersion + "). " +
			"Requesting the minimum supported version of Go (" + minGoVersion + ")."
		version = minGoVersion
		diagnostics.EmitGoModVersionTooLowAndEnvVersionUnsupported(msg)
	} else {
		// The version of Go that is installed is supported. The version in the `go.mod` file is
		// below the supported range. We do not install a version of Go.
		msg = "The version of Go installed in the environment (" + v.goEnvVersion +
			") is supported and is high enough for the version found in the `go.mod` file (" +
			v.goModVersion + "). Not requesting any version of Go."
		version = ""
		diagnostics.EmitGoModVersionTooLowAndEnvVersionSupported(msg)
	}

	return msg, version
}

// Assuming `v.goModVersion` is in the supported range, emit a diagnostic and return the version
// to install, or the empty string if we should not attempt to install a version of Go.
func getVersionWhenGoModVersionSupported(v versionInfo) (msg, version string) {
	if !v.goEnvVersionFound {
		// There is no Go version installed. The version in the `go.mod` file is supported.
		// We install the version from the `go.mod` file.
		msg = "No version of Go installed. Requesting the version of Go found in the `go.mod` " +
			"file (" + v.goModVersion + ")."
		version = v.goModVersion
		diagnostics.EmitGoModVersionSupportedAndNoGoEnv(msg)
	} else if outsideSupportedRange(v.goEnvVersion) {
		// The version of Go that is installed is outside of the supported range. The version in
		// the `go.mod` file is supported. We install the version from the `go.mod` file.
		msg = "The version of Go installed in the environment (" + v.goEnvVersion +
			") is outside of the supported range (" + minGoVersion + "-" + maxGoVersion + "). " +
			"Requesting the version of Go from the `go.mod` file (" +
			v.goModVersion + ")."
		version = v.goModVersion
		diagnostics.EmitGoModVersionSupportedAndGoEnvUnsupported(msg)
	} else if semver.Compare("v"+v.goModVersion, "v"+v.goEnvVersion) > 0 {
		// The version of Go that is installed is supported. The version in the `go.mod` file is
		// supported and is higher than the version that is installed. We install the version from
		// the `go.mod` file.
		msg = "The version of Go installed in the environment (" + v.goEnvVersion +
			") is lower than the version found in the `go.mod` file (" + v.goModVersion +
			"). Requesting the version of Go from the `go.mod` file (" + v.goModVersion + ")."
		version = v.goModVersion
		diagnostics.EmitGoModVersionSupportedHigherGoEnv(msg)
	} else {
		// The version of Go that is installed is supported. The version in the `go.mod` file is
		// supported and is lower than or equal to the version that is installed. We do not install
		// a version of Go.
		msg = "The version of Go installed in the environment (" + v.goEnvVersion +
			") is supported and is high enough for the version found in the `go.mod` file (" +
			v.goModVersion + "). Not requesting any version of Go."
		version = ""
		diagnostics.EmitGoModVersionSupportedLowerEqualGoEnv(msg)
	}

	return msg, version
}

// Check the versions of Go found in the environment and in the `go.mod` file, and return a
// version to install. If the version is the empty string then no installation is required.
// We never return a version of Go that is outside of the supported range.
//
// +-----------------------+-----------------------+-----------------------+-----------------------------------------------------+------------------------------------------------+
// | Found in go.mod >     | *None*                | *Below min supported* | *In supported range*                                | *Above max supported                           |
// | Installed \/          |                       |                       |                                                     |                                                |
// |-----------------------|-----------------------|-----------------------|-----------------------------------------------------|------------------------------------------------|
// | *None*                | Install max supported | Install min supported | Install version from go.mod                         | Install max supported                          |
// | *Below min supported* | Install max supported | Install min supported | Install version from go.mod                         | Install max supported                          |
// | *In supported range*  | No action             | No action             | Install version from go.mod if newer than installed | Install max supported if newer than installed  |
// | *Above max supported* | Install max supported | Install min supported | Install version from go.mod                         | No action                                      |
// +-----------------------+-----------------------+-----------------------+-----------------------------------------------------+------------------------------------------------+
func getVersionToInstall(v versionInfo) (msg, version string) {
	if !v.goModVersionFound {
		return getVersionWhenGoModVersionNotFound(v)
	}

	if aboveSupportedRange(v.goModVersion) {
		return getVersionWhenGoModVersionTooHigh(v)
	}

	if belowSupportedRange(v.goModVersion) {
		return getVersionWhenGoModVersionTooLow(v)
	}

	return getVersionWhenGoModVersionSupported(v)
}

// Output some JSON to stdout specifying the version of Go to install, unless `version` is the
// empty string.
func outputEnvironmentJson(version string) {
	var content string
	if version == "" {
		content = `{ "go": {} }`
	} else {
		content = `{ "go": { "version": "` + version + `" } }`
	}
	_, err := fmt.Fprint(os.Stdout, content)

	if err != nil {
		log.Println("Failed to write environment json to stdout: ")
		log.Println(err)
	}
}

type versionInfo struct {
	goModVersion      string // The version of Go found in the go directive in the `go.mod` file.
	goModVersionFound bool   // Whether a `go` directive was found in the `go.mod` file.
	goEnvVersion      string // The version of Go found in the environment.
	goEnvVersionFound bool   // Whether an installation of Go was found in the environment.
}

func (v versionInfo) String() string {
	return fmt.Sprintf(
		"go.mod version: %s, go.mod directive found: %t, go env version: %s, go installation found: %t",
		v.goModVersion, v.goModVersionFound, v.goEnvVersion, v.goEnvVersionFound)
}

// Get the version of Go to install and output it to stdout as json.
func identifyEnvironment() {
	var v versionInfo
	buildInfo := project.GetBuildInfo(false)
	goVersionInfo := project.TryReadGoDirective(buildInfo)
	v.goModVersion, v.goModVersionFound = goVersionInfo.Version, goVersionInfo.Found

	v.goEnvVersionFound = toolchain.IsInstalled()
	if v.goEnvVersionFound {
		v.goEnvVersion = toolchain.GetEnvGoVersion()[2:]
	}

	msg, versionToInstall := getVersionToInstall(v)
	log.Println(msg)

	outputEnvironmentJson(versionToInstall)
}

func main() {
	if len(os.Args) == 1 {
		installDependenciesAndBuild()
	} else if len(os.Args) == 2 && os.Args[1] == "--identify-environment" {
		identifyEnvironment()
	} else {
		usage()
		os.Exit(2)
	}
}

package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"runtime"
	"strings"

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
func fixGoVendorIssues(workspace *project.GoWorkspace, goModVersionFound bool) {
	if workspace.ModMode == project.ModVendor {
		// fix go vendor issues with go versions >= 1.14 when no go version is specified in the go.mod
		// if this is the case, and dependencies were vendored with an old go version (and therefore
		// do not contain a '## explicit' annotation, the go command will fail and refuse to do any
		// work
		//
		// we work around this by adding an explicit go version of 1.13, which is the last version
		// where this is not an issue
		if workspace.DepMode == project.GoGetWithModules {
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
						workspace.ModMode = project.ModMod
					}
				}
			}
		}
	}
}

// Determines whether the project needs a GOPATH set up
func getNeedGopath(workspace project.GoWorkspace, importpath string) bool {
	needGopath := true
	if workspace.DepMode == project.GoGetWithModules {
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
func tryUpdateGoModAndGoSum(workspace project.GoWorkspace) {
	// Go 1.16 and later won't automatically attempt to update go.mod / go.sum during package loading, so try to update them here:
	if workspace.ModMode != project.ModVendor && workspace.DepMode == project.GoGetWithModules && toolchain.GetEnvGoSemVer().IsAtLeast(toolchain.V1_16) {
		for _, goMod := range workspace.Modules {
			// stat go.mod and go.sum
			goModPath := goMod.Path
			goModDir := filepath.Dir(goModPath)
			beforeGoModFileInfo, beforeGoModErr := os.Stat(goModPath)
			if beforeGoModErr != nil {
				log.Printf("Failed to stat %s before running `go mod tidy -e`\n", goModPath)
			}

			goSumPath := filepath.Join(goModDir, "go.sum")
			beforeGoSumFileInfo, beforeGoSumErr := os.Stat(goSumPath)

			// run `go mod tidy -e`
			cmd := goMod.Tidy()
			res := util.RunCmd(cmd)

			if !res {
				log.Printf("Failed to run `go mod tidy -e` in %s\n", goModDir)
			} else {
				if beforeGoModFileInfo != nil {
					afterGoModFileInfo, afterGoModErr := os.Stat(goModPath)
					if afterGoModErr != nil {
						log.Printf("Failed to stat %s after running `go mod tidy -e`: %s\n", goModPath, afterGoModErr.Error())
					} else if afterGoModFileInfo.ModTime().After(beforeGoModFileInfo.ModTime()) {
						// if go.mod has been changed then notify the user
						log.Println("We have run `go mod tidy -e` and it altered go.mod. You may wish to check these changes into version control. ")
					}
				}

				afterGoSumFileInfo, afterGoSumErr := os.Stat(goSumPath)
				if afterGoSumErr != nil {
					log.Printf("Failed to stat %s after running `go mod tidy -e`: %s\n", goSumPath, afterGoSumErr.Error())
				} else {
					if beforeGoSumErr != nil || afterGoSumFileInfo.ModTime().After(beforeGoSumFileInfo.ModTime()) {
						// if go.sum has been changed then notify the user
						log.Println("We have run `go mod tidy -e` and it altered go.sum. You may wish to check these changes into version control. ")
					}
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

// Try to build the project with a build script. If that fails, return a boolean indicating
// that we should install dependencies in the normal way.
func buildWithoutCustomCommands(workspaces []project.GoWorkspace) {
	// try to run a build script
	scriptSucceeded, scriptsExecuted := autobuilder.Autobuild()
	scriptCount := len(scriptsExecuted)

	// If there is no build script we could invoke successfully or there are still dependency errors;
	// we'll try to install dependencies ourselves in the normal Go way.
	if !scriptSucceeded {
		if scriptCount > 0 {
			log.Printf("Unsuccessfully ran %d build scripts(s), continuing to install dependencies in the normal way.\n", scriptCount)
		} else {
			log.Println("Unable to find any build scripts, continuing to install dependencies in the normal way.")
		}

		// Install dependencies for all workspaces.
		for i, _ := range workspaces {
			workspaces[i].ShouldInstallDependencies = true
		}
	} else {
		for i, workspace := range workspaces {
			if toolchain.DepErrors("./...", workspace.ModMode.ArgsForGoVersion(toolchain.GetEnvGoSemVer())...) {
				log.Printf("Dependencies are still not resolving for `%s` after executing %d build script(s), continuing to install dependencies in the normal way.\n", workspace.BaseDir, scriptCount)

				workspaces[i].ShouldInstallDependencies = true
			}
		}
	}
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
func installDependencies(workspace project.GoWorkspace) {
	// automatically determine command to install dependencies
	var install *exec.Cmd
	if workspace.DepMode == project.Dep {
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
		util.RunCmd(install)
	} else if workspace.DepMode == project.Glide {
		install = exec.Command("glide", "install")
		log.Println("Installing dependencies using `glide install`")
		util.RunCmd(install)
	} else {
		if workspace.Modules == nil {
			project.InitGoModForLegacyProject(workspace.BaseDir)
			workspace.Modules = project.LoadGoModules(true, []string{filepath.Join(workspace.BaseDir, "go.mod")})
		}

		// get dependencies for all modules
		for _, module := range workspace.Modules {
			path := filepath.Dir(module.Path)

			if util.DirExists(filepath.Join(path, "vendor")) {
				vendor := module.Vendor()
				log.Printf("Synchronizing vendor file using `go mod vendor` in %s.\n", path)
				util.RunCmd(vendor)
			}

			install = exec.Command("go", "get", "-v", "./...")
			install.Dir = path
			log.Printf("Installing dependencies using `go get -v ./...` in `%s`.\n", path)
			util.RunCmd(install)
		}
	}
}

// Run the extractor.
func extract(workspace project.GoWorkspace) bool {
	extractor, err := util.GetExtractorPath()
	if err != nil {
		log.Fatalf("Could not determine path of extractor: %v.\n", err)
	}

	extractorArgs := []string{}
	if workspace.DepMode == project.GoGetWithModules {
		extractorArgs = append(extractorArgs, workspace.ModMode.ArgsForGoVersion(toolchain.GetEnvGoSemVer())...)
	}

	if len(workspace.Modules) == 0 {
		// There may be no modules if we are using e.g. Dep or Glide
		extractorArgs = append(extractorArgs, "./...")
	} else {
		for _, module := range workspace.Modules {
			relModPath, relErr := filepath.Rel(workspace.BaseDir, filepath.Dir(module.Path))

			if relErr != nil {
				log.Printf(
					"Unable to make module path %s relative to workspace base dir %s: %s\n",
					filepath.Dir(module.Path), workspace.BaseDir, relErr.Error())
			} else {
				if relModPath != "." {
					extractorArgs = append(extractorArgs, "."+string(os.PathSeparator)+relModPath+"/...")
				} else {
					extractorArgs = append(extractorArgs, relModPath+"/...")
				}
			}
		}
	}

	log.Printf("Running extractor command '%s %v' from directory '%s'.\n", extractor, extractorArgs, workspace.BaseDir)
	cmd := exec.Command(extractor, extractorArgs...)
	cmd.Dir = workspace.BaseDir
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err = cmd.Run()
	if err != nil {
		log.Printf("Extraction failed for %s: %s\n", workspace.BaseDir, err.Error())
		return false
	}

	return true
}

// Build the project and run the extractor.
func installDependenciesAndBuild() {
	// do not print experiments the autobuilder was built with if any, only the version
	version := strings.SplitN(runtime.Version(), " ", 2)[0]
	log.Printf("Autobuilder was built with %s, environment has %s\n", version, toolchain.GetEnvGoVersion())

	srcdir := getSourceDir()

	// we set `SEMMLE_PATH_TRANSFORMER` ourselves in some cases, so blank it out first for consistency
	os.Setenv("SEMMLE_PATH_TRANSFORMER", "")

	// determine how to install dependencies and whether a GOPATH needs to be set up before
	// extraction
	workspaces := project.GetWorkspaceInfo(true)
	if _, present := os.LookupEnv("GO111MODULE"); !present {
		os.Setenv("GO111MODULE", "auto")
	}

	// Remove temporary extractor files (e.g. auto-generated go.mod files) when we are done
	defer project.RemoveTemporaryExtractorFiles()

	// If there is only one workspace and it needs a GOPATH set up, which may be the case if
	// we don't use Go modules, then we move the repository to a temporary directory and set
	// the GOPATH to it.
	if len(workspaces) == 1 {
		workspace := workspaces[0]

		importpath := util.GetImportPath()
		needGopath := getNeedGopath(workspace, importpath)

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
	}

	// Find the greatest version of Go that is required by the workspaces to check it against the version
	// of Go that is installed on the system.
	greatestGoVersion := project.RequiredGoVersion(&workspaces)

	// This diagnostic is not required if the system Go version is 1.21 or greater, since the
	// Go tooling should install required Go versions as needed.
	if toolchain.GetEnvGoSemVer().IsOlderThan(toolchain.V1_21) && greatestGoVersion != nil && greatestGoVersion.IsNewerThan(toolchain.GetEnvGoSemVer()) {
		diagnostics.EmitNewerGoVersionNeeded(toolchain.GetEnvGoSemVer().String(), greatestGoVersion.String())
		if val, _ := os.LookupEnv("GITHUB_ACTIONS"); val == "true" {
			log.Printf(
				"A go.mod file requires version %s of Go, but version %s is installed. Consider adding an actions/setup-go step to your workflow.\n",
				greatestGoVersion,
				toolchain.GetEnvGoSemVer())
		}
	}

	// Track all projects which could not be extracted successfully
	var unsuccessfulProjects = []string{}

	// Attempt to automatically fix issues with each workspace
	for _, workspace := range workspaces {
		goVersionInfo := workspace.RequiredGoVersion()

		fixGoVendorIssues(&workspace, goVersionInfo != nil)

		tryUpdateGoModAndGoSum(workspace)
	}

	// check whether an explicit dependency installation command was provided
	inst := util.Getenv("CODEQL_EXTRACTOR_GO_BUILD_COMMAND", "LGTM_INDEX_BUILD_COMMAND")
	if inst == "" {
		buildWithoutCustomCommands(workspaces)
	} else {
		buildWithCustomCommands(inst)
	}

	// Attempt to extract all workspaces; we will tolerate individual extraction failures here
	for i, workspace := range workspaces {
		if workspace.ModMode == project.ModVendor {
			// test if running `go` with -mod=vendor works, and if it doesn't, try to fallback to -mod=mod
			// or not set if the go version < 1.14. Note we check this post-build in case the build brings
			// the vendor directory up to date.
			if !checkVendor() {
				workspace.ModMode = project.ModMod
				log.Println("The vendor directory is not consistent with the go.mod; not using vendored dependencies.")
			}
		}

		if workspace.ShouldInstallDependencies {
			if workspace.ModMode == project.ModVendor {
				log.Printf("Skipping dependency installation because a Go vendor directory was found.")
			} else {
				installDependencies(workspace)
			}
		}

		workspaces[i].Extracted = extract(workspace)

		if !workspaces[i].Extracted {
			unsuccessfulProjects = append(unsuccessfulProjects, workspace.BaseDir)
		}
	}

	// If all projects could not be extracted successfully, we fail the overall extraction.
	if len(unsuccessfulProjects) == len(workspaces) {
		log.Fatalln("Extraction failed for all discovered Go projects.")
	}

	// If there is at least one project that could not be extracted successfully,
	// emit a diagnostic that reports which projects we could not extract successfully.
	// We only consider this a warning, since there may be test projects etc. which
	// do not matter if they cannot be extracted successfully.
	if len(unsuccessfulProjects) > 0 {
		log.Printf(
			"Warning: extraction failed for %d project(s): %s\n",
			len(unsuccessfulProjects),
			strings.Join(unsuccessfulProjects, ", "))
		diagnostics.EmitExtractionFailedForProjects(unsuccessfulProjects)
	} else {
		log.Printf("Success: extraction succeeded for all %d discovered project(s).\n", len(workspaces))
	}
}

func main() {
	if len(os.Args) == 1 {
		installDependenciesAndBuild()
	} else if len(os.Args) == 2 && os.Args[1] == "--identify-environment" {
		autobuilder.IdentifyEnvironment()
	} else {
		usage()
		os.Exit(2)
	}
}

package project

import (
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"slices"
	"sort"
	"strings"

	"github.com/github/codeql-go/extractor/diagnostics"
	"github.com/github/codeql-go/extractor/toolchain"
	"github.com/github/codeql-go/extractor/util"
	"golang.org/x/mod/modfile"
)

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

// Represents information about a `go.mod` file: this is at least the path to the `go.mod` file,
// plus the parsed contents of the file, if available.
type GoModule struct {
	Path   string        // The path to the `go.mod` file
	Module *modfile.File // The parsed contents of the `go.mod` file
}

// Tries to find the Go toolchain version required for this module.
func (module *GoModule) RequiredGoVersion() util.SemVer {
	if module.Module != nil && module.Module.Toolchain != nil {
		return util.NewSemVer(module.Module.Toolchain.Name)
	} else if module.Module != nil && module.Module.Go != nil {
		return util.NewSemVer(module.Module.Go.Version)
	} else {
		return tryReadGoDirective(module.Path)
	}
}

// Runs `go mod tidy` for this module.
func (module *GoModule) Tidy() *exec.Cmd {
	return toolchain.TidyModule(filepath.Dir(module.Path))
}

// Runs `go mod vendor -e` for this module.
func (module *GoModule) Vendor() *exec.Cmd {
	return toolchain.VendorModule(filepath.Dir(module.Path))
}

// Represents information about a Go project workspace: this may either be a folder containing
// a `go.work` file or a collection of `go.mod` files.
type GoWorkspace struct {
	BaseDir       string                  // The base directory for this workspace
	WorkspaceFile *modfile.WorkFile       // The `go.work` file for this workspace
	Modules       []*GoModule             // A list of `go.mod` files
	DepMode       DependencyInstallerMode // A value indicating how to install dependencies for this workspace
	ModMode       ModMode                 // A value indicating which module mode to use for this workspace
	Extracted     bool                    // A value indicating whether this workspace was extracted successfully

	ShouldInstallDependencies bool // A value indicating whether dependencies should be installed for this module
}

// Represents a nullable version string.
type GoVersionInfo = util.SemVer

// Determines the version of Go that is required by this workspace. This is, in order of preference:
// 1. The Go version specified in the `go.work` file, if any.
// 2. The greatest Go version specified in any `go.mod` file, if any.
func (workspace *GoWorkspace) RequiredGoVersion() util.SemVer {
	// If we have parsed a `go.work` file, we prioritise versions from it over those in individual `go.mod`
	// files. We are interested in toolchain versions, so if there is an explicit toolchain declaration in
	// a `go.work` file, we use that. Otherwise, we fall back to the language version in the `go.work` file
	// and use that as toolchain version. If we didn't parse a `go.work` file, then we try to find the
	// greatest version contained in `go.mod` files.
	if workspace.WorkspaceFile != nil && workspace.WorkspaceFile.Toolchain != nil {
		return util.NewSemVer(workspace.WorkspaceFile.Toolchain.Name)
	} else if workspace.WorkspaceFile != nil && workspace.WorkspaceFile.Go != nil {
		return util.NewSemVer(workspace.WorkspaceFile.Go.Version)
	} else if workspace.Modules != nil && len(workspace.Modules) > 0 {
		// Otherwise, if we have `go.work` files, find the greatest Go version in those.
		var greatestVersion util.SemVer = nil
		for _, module := range workspace.Modules {
			modVersion := module.RequiredGoVersion()

			if modVersion != nil && (greatestVersion == nil || modVersion.IsNewerThan(greatestVersion)) {
				greatestVersion = modVersion
			}
		}

		// If we have found some version, return it.
		return greatestVersion
	}

	return nil
}

// Finds the greatest Go version required by any of the given `workspaces`.
// Returns a `GoVersionInfo` value with `Found: false` if no version information is available.
func RequiredGoVersion(workspaces *[]GoWorkspace) util.SemVer {
	var greatestGoVersion util.SemVer = nil
	for _, workspace := range *workspaces {
		goVersionInfo := workspace.RequiredGoVersion()
		if goVersionInfo != nil && (greatestGoVersion == nil || goVersionInfo.IsNewerThan(greatestGoVersion)) {
			greatestGoVersion = goVersionInfo
		}
	}
	return greatestGoVersion
}

// Determines whether any of the directory paths in the input are nested.
func checkDirsNested(inputDirs []string) (string, bool) {
	// replace "." with "" so that we can check if all the paths are nested
	dirs := make([]string, len(inputDirs))
	for i, inputDir := range inputDirs {
		if inputDir == "." {
			dirs[i] = ""
		} else {
			dirs[i] = inputDir
		}
	}
	// the paths were generated by a depth-first search so I think they might
	// be sorted, but we sort them just in case
	sort.Strings(dirs)
	for _, dir := range dirs {
		if !strings.HasPrefix(dir, dirs[0]) {
			return "", false
		}
	}
	return dirs[0], true
}

// A list of files we created that should be removed after we are done.
var filesToRemove []string = []string{}

// Try to initialize a go.mod file for projects that do not already have one.
func InitGoModForLegacyProject(path string) {
	log.Printf("The code in %s seems to be missing a go.mod file. Attempting to initialize one...\n", path)

	modInit := toolchain.InitModule(path)

	if !util.RunCmd(modInit) {
		log.Printf("Failed to initialize go.mod file for this project.")
		return
	}

	// Add the go.mod file to a list of files we should remove later.
	filesToRemove = append(filesToRemove, filepath.Join(path, "go.mod"))

	modTidy := toolchain.TidyModule(path)
	out, err := modTidy.CombinedOutput()
	log.Println(string(out))

	if err != nil {
		log.Printf("Failed to determine module requirements for this project.")
	}

	if strings.Contains(string(out), "is relative, but relative import paths are not supported in module mode") {
		diagnostics.EmitRelativeImportPaths()
	}
}

// Attempts to remove all files that we created.
func RemoveTemporaryExtractorFiles() {
	for _, path := range filesToRemove {
		err := os.Remove(path)
		if err != nil {
			log.Printf("Unable to remove file we created at %s: %s\n", path, err.Error())
		}
	}

	filesToRemove = []string{}
}

// Find all go.work files in the working directory and its subdirectories
func findGoWorkFiles() []string {
	return util.FindAllFilesWithName(".", "go.work", "vendor")
}

// Find all go.mod files in the specified directory and its subdirectories
func findGoModFiles(root string) []string {
	return util.FindAllFilesWithName(root, "go.mod", "vendor")
}

// A regular expression for the Go toolchain version syntax.
var toolchainVersionRe *regexp.Regexp = regexp.MustCompile(`(?m)^([0-9]+\.[0-9]+\.[0-9]+)$`)

// Returns true if the `go.mod` file specifies a Go language version, that version is `1.21` or greater, and
// there is no `toolchain` directive, and the Go language version is not a valid toolchain version.
func hasInvalidToolchainVersion(modFile *modfile.File) bool {
	return modFile.Toolchain == nil && modFile.Go != nil &&
		!toolchainVersionRe.Match([]byte(modFile.Go.Version)) && util.NewSemVer(modFile.Go.Version).IsAtLeast(toolchain.V1_21)
}

// Given a list of `go.mod` file paths, try to parse them all. The resulting array of `GoModule` objects
// will be the same length as the input array and the objects will contain at least the `go.mod` path.
// If parsing the corresponding file is successful, then the parsed contents will also be available.
func LoadGoModules(emitDiagnostics bool, goModFilePaths []string) []*GoModule {
	results := make([]*GoModule, len(goModFilePaths))

	for i, goModFilePath := range goModFilePaths {
		results[i] = new(GoModule)
		results[i].Path = goModFilePath

		modFileSrc, err := os.ReadFile(goModFilePath)

		if err != nil {
			log.Printf("Unable to read %s: %s.\n", goModFilePath, err.Error())
			continue
		}

		modFile, err := modfile.Parse(goModFilePath, modFileSrc, nil)

		if err != nil {
			log.Printf("Unable to parse %s: %s.\n", goModFilePath, err.Error())
			continue
		}

		results[i].Module = modFile

		// If this `go.mod` file specifies a Go language version, that version is `1.21` or greater, and
		// there is no `toolchain` directive, check that it is a valid Go toolchain version. Otherwise,
		// `go` commands which try to download the right version of the Go toolchain will fail. We detect
		// this situation and emit a diagnostic.
		if hasInvalidToolchainVersion(modFile) {
			diagnostics.EmitInvalidToolchainVersion(goModFilePath, modFile.Go.Version)
		}
	}

	return results
}

// Given a path to a `go.work` file, this function attempts to parse the `go.work` file. If unsuccessful,
// we attempt to discover `go.mod` files within subdirectories of the directory containing the `go.work`
// file ourselves.
func discoverWorkspace(emitDiagnostics bool, workFilePath string) GoWorkspace {
	log.Printf("Loading %s...\n", workFilePath)
	baseDir := filepath.Dir(workFilePath)
	workFileSrc, err := os.ReadFile(workFilePath)

	if err != nil {
		// We couldn't read the `go.work` file for some reason; let's try to find `go.mod` files ourselves
		log.Printf("Unable to read %s, falling back to finding `go.mod` files manually:\n%s\n", workFilePath, err.Error())

		goModFilePaths := findGoModFiles(baseDir)
		log.Printf("Discovered the following Go modules in %s:\n%s\n", baseDir, strings.Join(goModFilePaths, "\n"))

		return GoWorkspace{
			BaseDir: baseDir,
			Modules: LoadGoModules(emitDiagnostics, goModFilePaths),
			DepMode: GoGetWithModules,
			ModMode: getModMode(GoGetWithModules, baseDir),
		}
	}

	workFile, err := modfile.ParseWork(workFilePath, workFileSrc, nil)

	if err != nil {
		// The `go.work` file couldn't be parsed for some reason; let's try to find `go.mod` files ourselves
		log.Printf("Unable to parse %s, falling back to finding `go.mod` files manually:\n%s\n", workFilePath, err.Error())

		goModFilePaths := findGoModFiles(baseDir)
		log.Printf("Discovered the following Go modules in %s:\n%s\n", baseDir, strings.Join(goModFilePaths, "\n"))

		return GoWorkspace{
			BaseDir: baseDir,
			Modules: LoadGoModules(emitDiagnostics, goModFilePaths),
			DepMode: GoGetWithModules,
			ModMode: getModMode(GoGetWithModules, baseDir),
		}
	}

	// Get the paths of all of the `go.mod` files that we read from the `go.work` file.
	goModFilePaths := make([]string, len(workFile.Use))

	for i, use := range workFile.Use {
		if filepath.IsAbs(use.Path) {
			// TODO: This case might be problematic for some other logic (e.g. stray file detection)
			goModFilePaths[i] = filepath.Join(use.Path, "go.mod")
		} else {
			goModFilePaths[i] = filepath.Join(filepath.Dir(workFilePath), use.Path, "go.mod")
		}
	}

	log.Printf("%s uses the following Go modules:\n%s\n", workFilePath, strings.Join(goModFilePaths, "\n"))

	return GoWorkspace{
		BaseDir:       baseDir,
		WorkspaceFile: workFile,
		Modules:       LoadGoModules(emitDiagnostics, goModFilePaths),
		DepMode:       GoGetWithModules,
		ModMode:       ModReadonly, // Workspaces only support "readonly"
	}
}

// Analyse the working directory to discover workspaces.
func discoverWorkspaces(emitDiagnostics bool) []GoWorkspace {
	// Try to find any `go.work` files which may exist in the working directory.
	goWorkFiles := findGoWorkFiles()

	if len(goWorkFiles) == 0 {
		// There is no `go.work` file. Find all `go.mod` files in the working directory.
		log.Println("Found no go.work files in the workspace; looking for go.mod files...")

		goModFiles := findGoModFiles(".")

		// Return a separate workspace for each `go.mod` file that we found.
		results := make([]GoWorkspace, len(goModFiles))

		for i, goModFile := range goModFiles {
			results[i] = GoWorkspace{
				BaseDir: filepath.Dir(goModFile),
				Modules: LoadGoModules(emitDiagnostics, []string{goModFile}),
				DepMode: GoGetWithModules,
				ModMode: getModMode(GoGetWithModules, filepath.Dir(goModFile)),
			}
		}

		return results
	} else {
		// We have found `go.work` files, try to load them all.
		log.Printf("Found go.work file(s) in: %s.\n", strings.Join(goWorkFiles, ", "))

		if emitDiagnostics {
			diagnostics.EmitGoWorkFound(goWorkFiles)
		}

		results := make([]GoWorkspace, len(goWorkFiles))
		for i, workFilePath := range goWorkFiles {
			results[i] = discoverWorkspace(emitDiagnostics, workFilePath)
		}

		// Add all stray `go.mod` files (i.e. those not referenced by `go.work` files)
		// as separate workspaces.
		goModFiles := findGoModFiles(".")

		for _, goModFile := range goModFiles {
			// Check to see whether we already have this module file under an existing workspace.
			found := false
			for _, workspace := range results {
				if workspace.Modules == nil {
					break
				}

				for _, module := range workspace.Modules {
					if module.Path == goModFile {
						found = true
						break
					}
				}

				if found {
					break
				}
			}

			// If not, add it to the array.
			if !found {
				log.Printf("Module %s is not referenced by any go.work file; adding it separately.\n", goModFile)
				results = append(results, GoWorkspace{
					BaseDir: filepath.Dir(goModFile),
					Modules: LoadGoModules(emitDiagnostics, []string{goModFile}),
					DepMode: GoGetWithModules,
					ModMode: getModMode(GoGetWithModules, filepath.Dir(goModFile)),
				})
			}
		}

		return results
	}
}

// Discovers Go workspaces in the current working directory.
// Returns an array of Go workspaces and the total number of module files which we discovered.
func getBuildRoots(emitDiagnostics bool) (goWorkspaces []GoWorkspace, totalModuleFiles int) {
	goWorkspaces = discoverWorkspaces(emitDiagnostics)

	// Determine the total number of `go.mod` files that we discovered.
	totalModuleFiles = 0

	for _, goWorkspace := range goWorkspaces {
		totalModuleFiles += len(goWorkspace.Modules)
	}

	// If there are no `go.mod` files at all, create one in line with https://go.dev/blog/migrating-to-go-modules
	if totalModuleFiles == 0 {
		// Check for other, legacy package managers
		if util.FileExists("Gopkg.toml") {
			if emitDiagnostics {
				diagnostics.EmitGopkgTomlFound()
			}
			log.Println("Found Gopkg.toml, using dep instead of go get")
			goWorkspaces = []GoWorkspace{{
				BaseDir: ".",
				DepMode: Dep,
				ModMode: ModUnset,
			}}
			totalModuleFiles = 0
			return
		}

		if util.FileExists("glide.yaml") {
			if emitDiagnostics {
				diagnostics.EmitGlideYamlFound()
			}
			log.Println("Found glide.yaml, using Glide instead of go get")
			goWorkspaces = []GoWorkspace{{
				BaseDir: ".",
				DepMode: Glide,
				ModMode: ModUnset,
			}}
			totalModuleFiles = 0
			return
		}

		// If we have no `go.mod` files, then the project appears to be a legacy project without
		// a `go.mod` file. Check that there are actually Go source files before initializing a module
		// so that we correctly fail the extraction later.
		if !util.FindGoFiles(".") {
			goWorkspaces = []GoWorkspace{{
				BaseDir: ".",
				DepMode: GoGetNoModules,
				ModMode: ModUnset,
			}}
			totalModuleFiles = 0
			return
		}

		goWorkspaces = []GoWorkspace{{
			BaseDir: ".",
			DepMode: GoGetNoModules,
			ModMode: getModMode(GoGetWithModules, "."),
		}}
		totalModuleFiles = 0
		return
	}

	// Get the paths to all `go.mod` files
	i := 0
	goModPaths := make([]string, totalModuleFiles)

	for _, goWorkspace := range goWorkspaces {
		for _, goModule := range goWorkspace.Modules {
			goModPaths[i] = goModule.Path
			i++
		}
	}

	goModDirs := util.GetParentDirs(goModPaths)
	newGoModDirs := []string{}
	straySourceFiles := util.GoFilesOutsideDirs(".", goModDirs...)
	if len(straySourceFiles) > 0 {
		if emitDiagnostics {
			diagnostics.EmitGoFilesOutsideGoModules(goModPaths)
		}

		// We need to initialise Go modules for the stray source files. Our goal is to initialise
		// as few Go modules as possible, in locations which do not overlap with existing Go
		// modules.
		for _, straySourceFile := range straySourceFiles {
			path := "."
			components := strings.Split(filepath.Dir(straySourceFile), string(os.PathSeparator))

			for _, component := range components {
				path = filepath.Join(path, component)

				// If this path is already covered by a new `go.mod` file we will initialise,
				// then we don't need a more deeply-nested one. Keeping a separate list of
				// `go.mod` files we are initialising in `newGoModDirs` allows us to descend as
				// deep as we need to into the directory structure to place new `go.mod` files
				// that don't conflict with pre-existing ones, but means we won't descend past
				// the ones we are initialising ourselves. E.g. consider the following layout:
				//
				// - pre-existing/go.mod
				// - no-go-mod/main.go
				// - no-go-mod/sub-dir/foo.go
				//
				// Here, we want to initialise a `go.mod` in `no-go-mod/` only. This works fine
				// without the `newGoModDirs` check below. However, if we added `no-go-mod/` to
				// `goModDirs`, we would recurse all the way into `no-go-mod/sub-dir/` and
				// initialise another `go.mod` file there, which we do not want. If we were to
				// add an `else` branch to the `goModDirs` check, then we wouldn't be able to
				// descend into `no-go-mod/` for the `go.mod` file we want.
				if startsWithAnyOf(path, newGoModDirs) {
					break
				}

				// Try to initialize a `go.mod` file automatically for the stray source files if
				// doing so would not place it in a parent directory of an existing `go.mod` file.
				if !startsWithAnyOf(path, goModDirs) {
					goWorkspaces = append(goWorkspaces, GoWorkspace{
						BaseDir: path,
						DepMode: GoGetNoModules,
						ModMode: ModUnset,
					})
					newGoModDirs = append(newGoModDirs, path)
					break
				}
			}
		}

		return
	}

	// If we are emitted diagnostics, report some details about the workspace structure.
	if emitDiagnostics {
		if totalModuleFiles > 1 {
			_, nested := checkDirsNested(goModDirs)

			if nested {
				diagnostics.EmitMultipleGoModFoundNested(goModPaths)
			} else {
				diagnostics.EmitMultipleGoModFoundNotNested(goModPaths)
			}
		} else if totalModuleFiles == 1 {
			if goModDirs[0] == "." {
				diagnostics.EmitSingleRootGoModFound(goModPaths[0])
			} else {
				diagnostics.EmitSingleNonRootGoModFound(goModPaths[0])
			}
		}
	}

	return
}

// Determines whether `str` starts with any of `prefixes`.
func startsWithAnyOf(str string, prefixes []string) bool {
	for _, prefix := range prefixes {
		if relPath, err := filepath.Rel(str, prefix); err == nil && !strings.HasPrefix(relPath, "..") {
			return true
		}
	}
	return false
}

// Finds Go workspaces in the current working directory.
func GetWorkspaceInfo(emitDiagnostics bool) []GoWorkspace {
	bazelPaths := slices.Concat(
		util.FindAllFilesWithName(".", "BUILD", "vendor"),
		util.FindAllFilesWithName(".", "BUILD.bazel", "vendor"),
	)
	if len(bazelPaths) > 0 {
		// currently not supported
		if emitDiagnostics {
			diagnostics.EmitBazelBuildFilesFound(bazelPaths)
		}
	}

	goWorkspaces, totalModuleFiles := getBuildRoots(emitDiagnostics)
	log.Printf("Found %d go.mod file(s).\n", totalModuleFiles)

	return goWorkspaces
}

// ModMode corresponds to the possible values of the -mod flag for the Go compiler
type ModMode int

const (
	ModUnset ModMode = iota
	ModReadonly
	ModMod
	ModVendor
)

// argsForGoVersion returns the arguments to pass to the Go compiler for the given `ModMode` and
// Go version
func (m ModMode) ArgsForGoVersion(version util.SemVer) []string {
	switch m {
	case ModUnset:
		return []string{}
	case ModReadonly:
		return []string{"-mod=readonly"}
	case ModMod:
		if version.IsOlderThan(toolchain.V1_14) {
			return []string{} // -mod=mod is the default behaviour for go <= 1.13, and is not accepted as an argument
		} else {
			return []string{"-mod=mod"}
		}
	case ModVendor:
		return []string{"-mod=vendor"}
	}
	return nil
}

// Returns the appropriate ModMode for the current project
func getModMode(depMode DependencyInstallerMode, baseDir string) ModMode {
	if depMode == GoGetWithModules {
		// if a vendor/modules.txt file exists, we assume that there are vendored Go dependencies, and
		// skip the dependency installation step and run the extractor with `-mod=vendor`
		if util.FileExists(filepath.Join(baseDir, "vendor", "modules.txt")) {
			return ModVendor
		} else if util.DirExists(filepath.Join(baseDir, "vendor")) {
			return ModMod
		}
	}
	return ModUnset
}

// Tries to open `go.mod` and read a go directive, returning the version and whether it was found.
// The version string is returned in the "1.2.3" format.
func tryReadGoDirective(path string) util.SemVer {
	versionRe := regexp.MustCompile(`(?m)^go[ \t\r]+([0-9]+\.[0-9]+(\.[0-9]+)?)`)
	goMod, err := os.ReadFile(path)
	if err != nil {
		log.Println("Failed to read go.mod to check for missing Go version")
	} else {
		matches := versionRe.FindSubmatch(goMod)
		if matches != nil {
			if len(matches) > 1 {
				return util.NewSemVer(string(matches[1]))
			}
		}
	}
	return nil
}

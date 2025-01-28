package extractor

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"go/ast"
	"go/constant"
	"go/scanner"
	"go/token"
	"go/types"
	"io"
	"log"
	"os"
	"path/filepath"
	"regexp"
	"runtime"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/github/codeql-go/extractor/dbscheme"
	"github.com/github/codeql-go/extractor/diagnostics"
	"github.com/github/codeql-go/extractor/srcarchive"
	"github.com/github/codeql-go/extractor/toolchain"
	"github.com/github/codeql-go/extractor/trap"
	"github.com/github/codeql-go/extractor/util"
	"golang.org/x/tools/go/packages"
)

var MaxGoRoutines int
var typeParamParent map[*types.TypeParam]types.Object = make(map[*types.TypeParam]types.Object)

func init() {
	// this sets the number of threads that the Go runtime will spawn; this is separate
	// from the number of goroutines that the program spawns, which are scheduled into
	// the system threads by the Go runtime scheduler
	threads := os.Getenv("LGTM_THREADS")
	if maxprocs, err := strconv.Atoi(threads); err == nil && maxprocs > 0 {
		log.Printf("Max threads set to %d", maxprocs)
		runtime.GOMAXPROCS(maxprocs)
	} else if threads != "" {
		log.Printf("Warning: LGTM_THREADS value %s is not valid, defaulting to using all available threads.", threads)
	}
	// if the value is empty or not set, use the Go default, which is the number of cores
	// available since Go 1.5, but is subject to change

	var err error
	if MaxGoRoutines, err = strconv.Atoi(util.Getenv(
		"CODEQL_EXTRACTOR_GO_MAX_GOROUTINES",
		"SEMMLE_MAX_GOROUTINES",
	)); err != nil {
		MaxGoRoutines = 32
	} else {
		log.Printf("Max goroutines set to %d", MaxGoRoutines)
	}
}

// Extract extracts the packages specified by the given patterns
func Extract(patterns []string) error {
	return ExtractWithFlags(nil, patterns, false)
}

// ExtractWithFlags extracts the packages specified by the given patterns and build flags
func ExtractWithFlags(buildFlags []string, patterns []string, extractTests bool) error {
	startTime := time.Now()

	extraction := NewExtraction(buildFlags, patterns)
	defer extraction.StatWriter.Close()

	modEnabled := os.Getenv("GO111MODULE") != "off"
	if !modEnabled {
		log.Println("Go module mode disabled.")
	}

	modFlags := make([]string, 0, 1)
	for _, flag := range buildFlags {
		if strings.HasPrefix(flag, "-mod=") {
			modFlags = append(modFlags, flag)
		}
	}

	// If CODEQL_EXTRACTOR_GO_[OPTION_]EXTRACT_VENDOR_DIRS is "true", we extract `vendor` directories;
	// otherwise (the default) is to exclude them from extraction
	includeVendor, oldOptionUsed := util.IsVendorDirExtractionEnabled()

	if oldOptionUsed {
		log.Println("Warning: obsolete option \"CODEQL_EXTRACTOR_GO_EXTRACT_VENDOR_DIRS\" was set. Use \"CODEQL_EXTRACTOR_GO_OPTION_EXTRACT_VENDOR_DIRS\" or pass `--extractor-option extract_vendor_dirs=true` instead.")
	}

	modeNotifications := make([]string, 0, 2)
	if extractTests {
		modeNotifications = append(modeNotifications, "test extraction enabled")
	}
	if includeVendor {
		modeNotifications = append(modeNotifications, "extracting vendor directories")
	}

	modeMessage := strings.Join(modeNotifications, ", ")
	if modeMessage != "" {
		modeMessage = " (" + modeMessage + ")"
	}
	log.Printf("Running packages.Load%s.", modeMessage)

	// This includes test packages if either we're tracing a `go test` command,
	// or if CODEQL_EXTRACTOR_GO_OPTION_EXTRACT_TESTS is set to "true".
	cfg := &packages.Config{
		Mode: packages.NeedName | packages.NeedFiles |
			packages.NeedCompiledGoFiles |
			packages.NeedImports | packages.NeedDeps |
			packages.NeedTypes | packages.NeedTypesSizes |
			packages.NeedTypesInfo | packages.NeedSyntax,
		BuildFlags: buildFlags,
		Tests:      extractTests,
	}
	pkgs, err := packages.Load(cfg, patterns...)
	if err != nil {
		// the toolchain directive is only supported in Go 1.21 and above
		if strings.Contains(err.Error(), "unknown directive: toolchain") {
			diagnostics.EmitNewerSystemGoRequired("1.21.0")
		}
		return err
	}
	log.Println("Done running packages.Load.")

	if len(pkgs) == 0 {
		log.Println("No packages found.")

		wd, err := os.Getwd()
		if err != nil {
			log.Printf("Warning: failed to get working directory: %s\n", err.Error())
		} else if util.FindGoFiles(wd) {
			diagnostics.EmitGoFilesFoundButNotProcessed()
		}
	}

	log.Println("Extracting universe scope.")
	extractUniverseScope()
	log.Println("Done extracting universe scope.")

	// a map of package path to source directory and module root directory
	pkgInfos := make(map[string]toolchain.PkgInfo)
	// root directories of packages that we want to extract
	wantedRoots := make(map[string]bool)

	if os.Getenv("CODEQL_EXTRACTOR_GO_FAST_PACKAGE_INFO") != "false" {
		log.Printf("Running go list to resolve package and module directories.")
		// get all packages information
		pkgInfos, err = toolchain.GetPkgsInfo(patterns, true, extractTests, modFlags...)
		if err != nil {
			log.Fatalf("Error getting dependency package or module directories: %v.", err)
		}
		log.Printf("Done running go list deps: resolved %d packages.", len(pkgInfos))
	}

	pkgsNotFound := make([]string, 0, len(pkgs))

	// Build a map from package paths to their longest IDs--
	// in the context of a `go test -c` compilation, we will see the same package more than
	// once, with IDs like "abc.com/pkgname [abc.com/pkgname.test]" to distinguish the version
	// that contains and is used by test code.
	// For our purposes it is simplest to just ignore the non-test version, since the test
	// version seems to be a superset of it.
	longestPackageIds := make(map[string]string)
	packages.Visit(pkgs, nil, func(pkg *packages.Package) {
		if longestIDSoFar, present := longestPackageIds[pkg.PkgPath]; present {
			if len(pkg.ID) > len(longestIDSoFar) {
				longestPackageIds[pkg.PkgPath] = pkg.ID
			}
		} else {
			longestPackageIds[pkg.PkgPath] = pkg.ID
		}
	})

	// Do a post-order traversal and extract the package scope of each package
	packages.Visit(pkgs, nil, func(pkg *packages.Package) {
		// Note that if test extraction is enabled, we will encounter a package twice here:
		// once as the main package, and once as the test package (with a package ID like
		// "abc.com/pkgname [abc.com/pkgname.test]").
		//
		// We will extract it both times however, because we need to visit the packages
		// in the right order in order to visit used types before their users, and the
		// ordering determined by packages.Visit for the main and the test package may differ.
		//
		// This should only cause some wasted time and not inconsistency because the names for
		// objects seen in this process should be the same each time.

		log.Printf("Processing package %s.", pkg.PkgPath)

		if _, ok := pkgInfos[pkg.PkgPath]; !ok {
			pkgInfos[pkg.PkgPath] = toolchain.GetPkgInfo(pkg.PkgPath, modFlags...)
		}

		log.Printf("Extracting types for package %s.", pkg.PkgPath)

		tw, err := trap.NewWriter(pkg.PkgPath, pkg)
		if err != nil {
			log.Fatal(err)
		}
		defer tw.Close()

		scope := extractPackageScope(tw, pkg)
		extractObjectTypes(tw)
		lbl := tw.Labeler.GlobalID(util.EscapeTrapSpecialChars(pkg.PkgPath) + ";pkg")
		dbscheme.PackagesTable.Emit(tw, lbl, pkg.Name, pkg.PkgPath, scope)

		if len(pkg.Errors) != 0 {
			log.Printf("Warning: encountered errors extracting package `%s`:", pkg.PkgPath)
			for i, err := range pkg.Errors {
				errString := err.Error()
				log.Printf("  %s", errString)

				if strings.Contains(errString, "build constraints exclude all Go files in ") {
					// `err` is a NoGoError from the package cmd/go/internal/load, which we cannot access as it is internal
					diagnostics.EmitPackageDifferentOSArchitecture(pkg.PkgPath)
				} else if strings.Contains(errString, "cannot find package") ||
					strings.Contains(errString, "no required module provides package") {
					pkgsNotFound = append(pkgsNotFound, pkg.PkgPath)
				}
				extraction.extractError(tw, err, lbl, i)
			}
		}

		log.Printf("Done extracting types for package %s.", pkg.PkgPath)
	})

	if len(pkgsNotFound) > 0 {
		diagnostics.EmitCannotFindPackages(pkgsNotFound)
	}

	for _, pkg := range pkgs {
		pkgInfo, ok := pkgInfos[pkg.PkgPath]
		if !ok || pkgInfo.PkgDir == "" {
			log.Fatalf("Unable to get a source directory for input package %s.", pkg.PkgPath)
		}
		wantedRoots[pkgInfo.PkgDir] = true
		if pkgInfo.ModDir != "" {
			wantedRoots[pkgInfo.ModDir] = true
		}
	}

	log.Println("Done processing dependencies.")

	log.Println("Starting to extract packages.")

	sep := regexp.QuoteMeta(string(filepath.Separator))

	// Construct a list of directory segments to exclude from extraction, starting with ".."
	excludedDirs := []string{`\.\.`}

	if !includeVendor {
		excludedDirs = append(excludedDirs, "vendor")
	}

	// If a path matches this regexp, we don't extract this package. It checks whether the path
	// contains one of the `excludedDirs`.
	noExtractRe := regexp.MustCompile(`.*(^|` + sep + `)(` + strings.Join(excludedDirs, "|") + `)($|` + sep + `).*`)

	// extract AST information for all packages
	packages.Visit(pkgs, nil, func(pkg *packages.Package) {

		// If this is a variant of a package that also occurs with a longer ID, skip it;
		// otherwise we would extract the same file more than once including extracting the
		// body of methods twice, causing database inconsistencies.
		//
		// We prefer the version with the longest ID because that is (so far as I know) always
		// the version that defines more entities -- the only case I'm aware of being a test
		// variant of a package, which includes test-only functions in addition to the complete
		// contents of the main variant.
		if pkg.ID != longestPackageIds[pkg.PkgPath] {
			return
		}

		for root := range wantedRoots {
			pkgInfo := pkgInfos[pkg.PkgPath]
			relDir, err := filepath.Rel(root, pkgInfo.PkgDir)
			if err != nil || noExtractRe.MatchString(relDir) {
				// if the path can't be made relative or matches the noExtract regexp skip it
				continue
			}

			extraction.extractPackage(pkg)

			modDir := pkgInfo.ModDir
			if modDir == "" {
				modDir = pkgInfo.PkgDir
			}
			if modDir != "" {
				modPath := filepath.Join(modDir, "go.mod")
				if util.FileExists(modPath) {
					log.Printf("Extracting %s", modPath)
					start := time.Now()

					err := extraction.extractGoMod(modPath)
					if err != nil {
						log.Printf("Failed to extract go.mod: %s", err.Error())
					}

					end := time.Since(start)
					log.Printf("Done extracting %s (%dms)", modPath, end.Nanoseconds()/1000000)
				}
			}

			return
		}

		log.Printf("Skipping dependency package %s.", pkg.PkgPath)
	})

	extraction.WaitGroup.Wait()

	log.Println("Done extracting packages.")

	t := time.Now()
	elapsed := t.Sub(startTime)
	dbscheme.CompilationFinishedTable.Emit(extraction.StatWriter, extraction.Label, 0.0, elapsed.Seconds())

	return nil
}

type Extraction struct {
	// A lock for preventing concurrent writes to maps and the stat trap writer, as they are not
	// thread-safe
	Lock         sync.Mutex
	LabelKey     string
	Label        trap.Label
	StatWriter   *trap.Writer
	WaitGroup    sync.WaitGroup
	GoroutineSem *semaphore
	FdSem        *semaphore
	NextFileId   int
	FileInfo     map[string]*FileInfo
	SeenGoMods   map[string]bool
}

type FileInfo struct {
	Idx     int
	NextErr int
}

func (extraction *Extraction) SeenFile(path string) bool {
	_, ok := extraction.FileInfo[path]
	return ok
}

func (extraction *Extraction) GetFileInfo(path string) *FileInfo {
	if fileInfo, ok := extraction.FileInfo[path]; ok {
		return fileInfo
	}

	extraction.FileInfo[path] = &FileInfo{extraction.NextFileId, 0}
	extraction.NextFileId += 1

	return extraction.FileInfo[path]
}

func (extraction *Extraction) GetFileIdx(path string) int {
	return extraction.GetFileInfo(path).Idx
}

func (extraction *Extraction) GetNextErr(path string) int {
	finfo := extraction.GetFileInfo(path)
	res := finfo.NextErr
	finfo.NextErr += 1
	return res
}

func NewExtraction(buildFlags []string, patterns []string) *Extraction {
	hash := md5.New()
	io.WriteString(hash, "go")
	for _, buildFlag := range buildFlags {
		io.WriteString(hash, " "+buildFlag)
	}
	io.WriteString(hash, " --")
	for _, pattern := range patterns {
		io.WriteString(hash, " "+pattern)
	}
	sum := hash.Sum(nil)

	i := 0
	var path string
	// split compilation files into directories to avoid filling a single directory with too many files
	pathFmt := fmt.Sprintf("compilations/%s/%s_%%d", hex.EncodeToString(sum[:1]), hex.EncodeToString(sum[1:]))
	for {
		path = fmt.Sprintf(pathFmt, i)
		file, err := trap.FileFor(path)
		if err != nil {
			log.Fatalf("Error creating trap file: %s\n", err.Error())
		}
		i++

		if !util.FileExists(file) {
			break
		}
	}

	statWriter, err := trap.NewWriter(path, nil)
	if err != nil {
		log.Fatal(err)
	}
	lblKey := fmt.Sprintf("%s_%d;compilation", hex.EncodeToString(sum), i)
	lbl := statWriter.Labeler.GlobalID(lblKey)

	wd, err := os.Getwd()
	if err != nil {
		log.Fatalf("Unable to determine current directory: %s\n", err.Error())
	}

	dbscheme.CompilationsTable.Emit(statWriter, lbl, wd)
	i = 0
	extractorPath, err := util.GetExtractorPath()
	if err != nil {
		log.Fatalf("Unable to get extractor path: %s\n", err.Error())
	}
	dbscheme.CompilationArgsTable.Emit(statWriter, lbl, 0, extractorPath)
	i++
	for _, flag := range buildFlags {
		dbscheme.CompilationArgsTable.Emit(statWriter, lbl, i, flag)
		i++
	}
	// emit a fake "--" argument to make it clear that what comes after it are patterns
	dbscheme.CompilationArgsTable.Emit(statWriter, lbl, i, "--")
	i++
	for _, pattern := range patterns {
		dbscheme.CompilationArgsTable.Emit(statWriter, lbl, i, pattern)
		i++
	}

	return &Extraction{
		LabelKey:   lblKey,
		Label:      lbl,
		StatWriter: statWriter,
		// this semaphore is used to limit the number of files that are open at once;
		// this is to prevent the extractor from running into issues with caps on the
		// number of open files that can be held by one process
		FdSem: newSemaphore(100),
		// this semaphore is used to limit the number of goroutines spawned, so we
		// don't run into memory issues
		GoroutineSem: newSemaphore(MaxGoRoutines),
		NextFileId:   0,
		FileInfo:     make(map[string]*FileInfo),
		SeenGoMods:   make(map[string]bool),
	}
}

// extractUniverseScope extracts symbol table information for the universe scope
func extractUniverseScope() {
	tw, err := trap.NewWriter("universe", nil)
	if err != nil {
		log.Fatal(err)
	}
	defer tw.Close()

	lbl := tw.Labeler.ScopeID(types.Universe, nil)
	dbscheme.ScopesTable.Emit(tw, lbl, dbscheme.UniverseScopeType.Index())
	extractObjects(tw, types.Universe, lbl)

	// Always extract an empty interface type
	extractType(tw, types.NewInterfaceType([]*types.Func{}, []types.Type{}))
}

// extractObjects extracts all objects declared in the given scope
// For more information on objects, see:
// https://github.com/golang/example/blob/master/gotypes/README.md#objects
func extractObjects(tw *trap.Writer, scope *types.Scope, scopeLabel trap.Label) {
	for _, name := range scope.Names() {
		obj := scope.Lookup(name)
		lbl, exists := tw.Labeler.ScopedObjectID(obj, func() trap.Label { return extractType(tw, obj.Type()) })
		if !exists {
			// Populate type parameter parents for functions. Note that methods
			// do not appear as objects in any scope, so they have to be dealt
			// with separately in extractMethods.
			if funcObj, ok := obj.(*types.Func); ok {
				populateTypeParamParents(funcObj.Type().(*types.Signature).TypeParams(), obj)
				populateTypeParamParents(funcObj.Type().(*types.Signature).RecvTypeParams(), obj)
			}
			// Populate type parameter parents for named types.
			if typeNameObj, ok := obj.(*types.TypeName); ok {
				if tp, ok := typeNameObj.Type().(*types.Named); ok && !typeNameObj.IsAlias() {
					populateTypeParamParents(tp.TypeParams(), obj)
				} else if tp, ok := typeNameObj.Type().(*types.Alias); ok {
					populateTypeParamParents(tp.TypeParams(), obj)
				}
			}
			extractObject(tw, obj, lbl)
		}

		if obj.Parent() != scope {
			// this can happen if a scope is embedded into another with a `.` import.
			continue
		}
		dbscheme.ObjectScopesTable.Emit(tw, lbl, scopeLabel)
	}
}

// extractMethod extracts a method `meth` and emits it to the objects table, then returns its label
func extractMethod(tw *trap.Writer, meth *types.Func) trap.Label {
	// get the receiver type of the method
	recvtyp := meth.Type().(*types.Signature).Recv().Type()
	// ensure receiver type has been extracted
	recvtyplbl := extractType(tw, recvtyp)

	// if the method label does not exist, extract it
	methlbl, exists := tw.Labeler.MethodID(meth, recvtyplbl)
	if !exists {
		// Populate type parameter parents for methods. They do not appear as
		// objects in any scope, so they have to be dealt with separately here.
		populateTypeParamParents(meth.Type().(*types.Signature).TypeParams(), meth)
		populateTypeParamParents(meth.Type().(*types.Signature).RecvTypeParams(), meth)
		extractObject(tw, meth, methlbl)
	}

	return methlbl
}

// extractObject extracts a single object and emits it to the objects table.
// For more information on objects, see:
// https://github.com/golang/example/blob/master/gotypes/README.md#objects
func extractObject(tw *trap.Writer, obj types.Object, lbl trap.Label) {
	checkObjectNotSpecialized(obj)
	name := obj.Name()
	isBuiltin := obj.Parent() == types.Universe
	var kind int
	switch obj.(type) {
	case *types.PkgName:
		kind = dbscheme.PkgObjectType.Index()
	case *types.TypeName:
		if isBuiltin {
			kind = dbscheme.BuiltinTypeObjectType.Index()
		} else {
			kind = dbscheme.DeclTypeObjectType.Index()
		}
	case *types.Const:
		if isBuiltin {
			kind = dbscheme.BuiltinConstObjectType.Index()
		} else {
			kind = dbscheme.DeclConstObjectType.Index()
		}
	case *types.Nil:
		kind = dbscheme.BuiltinConstObjectType.Index()
	case *types.Var:
		kind = dbscheme.DeclVarObjectType.Index()
	case *types.Builtin:
		kind = dbscheme.BuiltinFuncObjectType.Index()
	case *types.Func:
		kind = dbscheme.DeclFuncObjectType.Index()
	case *types.Label:
		kind = dbscheme.LabelObjectType.Index()
	default:
		log.Fatalf("unknown object of type %T", obj)
	}
	dbscheme.ObjectsTable.Emit(tw, lbl, kind, name)

	// for methods, additionally extract information about the receiver
	if sig, ok := obj.Type().(*types.Signature); ok {
		if recv := sig.Recv(); recv != nil {
			recvlbl, exists := tw.Labeler.ReceiverObjectID(recv, lbl)
			if !exists {
				extractObject(tw, recv, recvlbl)
			}
			dbscheme.MethodReceiversTable.Emit(tw, lbl, recvlbl)
		}
	}
}

// extractObjectTypes extracts type and receiver information for all objects
// For more information on objects, see:
// https://github.com/golang/example/blob/master/gotypes/README.md#objects
func extractObjectTypes(tw *trap.Writer) {
	// calling `extractType` on a named type will extract all methods defined
	// on it, which will add new objects. Therefore we need to do this first
	// before we loop over all objects and emit them.
	changed := true
	for changed {
		changed = tw.ForEachObject(extractObjectType)
	}
	changed = tw.ForEachObject(emitObjectType)
	if changed {
		log.Printf("Warning: more objects were labeled while emitting object types")
	}
}

// extractObjectType extracts type and receiver information for a given object
// For more information on objects, see:
// https://github.com/golang/example/blob/master/gotypes/README.md#objects
func extractObjectType(tw *trap.Writer, obj types.Object, lbl trap.Label) {
	if tp := obj.Type(); tp != nil {
		extractType(tw, tp)
	}
}

// emitObjectType emits the type information for a given object
func emitObjectType(tw *trap.Writer, obj types.Object, lbl trap.Label) {
	if tp := obj.Type(); tp != nil {
		dbscheme.ObjectTypesTable.Emit(tw, lbl, extractType(tw, tp))
	}
}

var (
	// file:line:col
	threePartPos = regexp.MustCompile(`^(.+):(\d+):(\d+)$`)
	// file:line
	twoPartPos = regexp.MustCompile(`^(.+):(\d+)$`)
)

// extractError extracts the message and location of a frontend error
func (extraction *Extraction) extractError(tw *trap.Writer, err packages.Error, pkglbl trap.Label, idx int) {
	var (
		lbl       = tw.Labeler.FreshID()
		tag       = dbscheme.ErrorTags[err.Kind]
		kind      = dbscheme.ErrorTypes[err.Kind].Index()
		pos       = err.Pos
		file      = ""
		line, col int
		e         error
	)

	if pos == "" || pos == "-" {
		// extract a dummy file
		wd, e := os.Getwd()
		if e != nil {
			wd = "."
			log.Printf("Warning: failed to get working directory")
		}
		ewd, e := filepath.EvalSymlinks(wd)
		if e != nil {
			ewd = wd
			log.Printf("Warning: failed to evaluate symlinks for %s", wd)
		}
		file = filepath.Join(ewd, "-")
		extraction.extractFileInfo(tw, file, true)
	} else {
		var rawfile string
		if parts := threePartPos.FindStringSubmatch(pos); parts != nil {
			// "file:line:col"
			col, e = strconv.Atoi(parts[3])
			if e != nil {
				log.Printf("Warning: malformed column number `%s`: %v", parts[3], e)
			}
			line, e = strconv.Atoi(parts[2])
			if e != nil {
				log.Printf("Warning: malformed line number `%s`: %v", parts[2], e)
			}
			rawfile = parts[1]
		} else if parts := twoPartPos.FindStringSubmatch(pos); parts != nil {
			// "file:line"
			line, e = strconv.Atoi(parts[2])
			if e != nil {
				log.Printf("Warning: malformed line number `%s`: %v", parts[2], e)
			}
			rawfile = parts[1]
		} else if pos != "" && pos != "-" {
			log.Printf("Warning: malformed error position `%s`", pos)
		}
		afile, e := filepath.Abs(rawfile)
		if e != nil {
			log.Printf("Warning: failed to get absolute path for for %s", file)
			afile = file
		}
		file, e = filepath.EvalSymlinks(afile)
		if e != nil {
			log.Printf("Warning: failed to evaluate symlinks for %s", afile)
			file = afile
		}

		extraction.extractFileInfo(tw, file, false)
	}

	extraction.Lock.Lock()
	flbl := extraction.StatWriter.Labeler.FileLabelFor(file)
	diagLbl := extraction.StatWriter.Labeler.FreshID()
	dbscheme.DiagnosticsTable.Emit(
		extraction.StatWriter, diagLbl, 1, tag, err.Msg, err.Msg,
		emitLocation(extraction.StatWriter, flbl, line, col, line, col))
	dbscheme.DiagnosticForTable.Emit(extraction.StatWriter, diagLbl, extraction.Label, extraction.GetFileIdx(file), extraction.GetNextErr(file))
	extraction.Lock.Unlock()
	transformed := filepath.ToSlash(srcarchive.TransformPath(file))
	dbscheme.ErrorsTable.Emit(tw, lbl, kind, err.Msg, pos, transformed, line, col, pkglbl, idx)
}

// extractPackage extracts AST information for all files in the given package
func (extraction *Extraction) extractPackage(pkg *packages.Package) {
	for _, astFile := range pkg.Syntax {
		extraction.WaitGroup.Add(1)
		extraction.GoroutineSem.acquire(1)
		go func(astFile *ast.File) {
			err := extraction.extractFile(astFile, pkg)
			if err != nil {
				log.Fatal(err)
			}
			extraction.GoroutineSem.release(1)
			extraction.WaitGroup.Done()
		}(astFile)
	}
}

// normalizedPath computes the normalized path (with symlinks resolved) for the given file
func normalizedPath(ast *ast.File, fset *token.FileSet) string {
	file := fset.File(ast.Package).Name()
	path, err := filepath.EvalSymlinks(file)
	if err != nil {
		return file
	}
	return path
}

// extractFile extracts AST information for the given file
func (extraction *Extraction) extractFile(ast *ast.File, pkg *packages.Package) error {
	fset := pkg.Fset
	if ast.Package == token.NoPos {
		log.Printf("Skipping extracting a file without a 'package' declaration")
		return nil
	}
	path := normalizedPath(ast, fset)

	extraction.FdSem.acquire(3)

	log.Printf("Extracting %s", path)
	start := time.Now()

	defer extraction.FdSem.release(1)
	tw, err := trap.NewWriter(path, pkg)
	if err != nil {
		extraction.FdSem.release(2)
		return err
	}
	defer tw.Close()

	err = srcarchive.Add(path)
	extraction.FdSem.release(2)
	if err != nil {
		return err
	}

	extraction.extractFileInfo(tw, path, false)

	extractScopes(tw, ast, pkg)

	extractFileNode(tw, ast)

	extractObjectTypes(tw)

	extractNumLines(tw, path, ast)

	end := time.Since(start)
	log.Printf("Done extracting %s (%dms)", path, end.Nanoseconds()/1000000)

	return nil
}

// extractFileInfo extracts file-system level information for the given file, populating
// the `files` and `containerparent` tables
func (extraction *Extraction) extractFileInfo(tw *trap.Writer, file string, isDummy bool) {
	// We may visit the same file twice because `extractError` calls this function to describe files containing
	// compilation errors. It is also called for user source files being extracted.
	extraction.Lock.Lock()
	if extraction.SeenFile(file) {
		extraction.Lock.Unlock()
		return
	}
	extraction.Lock.Unlock()

	path := filepath.ToSlash(srcarchive.TransformPath(file))
	components := strings.Split(path, "/")
	parentPath := ""
	var parentLbl trap.Label

	for i, component := range components {
		if i == 0 {
			if component == "" {
				path = "/"
			} else {
				path = component
			}
		} else {
			path = parentPath + "/" + component
		}
		if i == len(components)-1 {
			lbl := tw.Labeler.FileLabelFor(file)
			dbscheme.FilesTable.Emit(tw, lbl, path)
			dbscheme.ContainerParentTable.Emit(tw, parentLbl, lbl)
			dbscheme.HasLocationTable.Emit(tw, lbl, emitLocation(tw, lbl, 0, 0, 0, 0))
			extraction.Lock.Lock()
			slbl := extraction.StatWriter.Labeler.FileLabelFor(file)
			if !isDummy {
				dbscheme.CompilationCompilingFilesTable.Emit(extraction.StatWriter, extraction.Label, extraction.GetFileIdx(file), slbl)
			}
			extraction.Lock.Unlock()
			break
		}
		lbl := tw.Labeler.GlobalID(util.EscapeTrapSpecialChars(path) + ";folder")
		dbscheme.FoldersTable.Emit(tw, lbl, path)
		if i > 0 {
			dbscheme.ContainerParentTable.Emit(tw, parentLbl, lbl)
		}
		if path != "/" {
			parentPath = path
		}
		parentLbl = lbl
	}
}

// extractLocation emits a location entity for the given entity
func extractLocation(tw *trap.Writer, entity trap.Label, sl int, sc int, el int, ec int) {
	filelbl := tw.Labeler.FileLabel()
	dbscheme.HasLocationTable.Emit(tw, entity, emitLocation(tw, filelbl, sl, sc, el, ec))
}

// emitLocation emits a location entity
func emitLocation(tw *trap.Writer, filelbl trap.Label, sl int, sc int, el int, ec int) trap.Label {
	locLbl := tw.Labeler.GlobalID(fmt.Sprintf("loc,{%s},%d,%d,%d,%d", filelbl, sl, sc, el, ec))
	dbscheme.LocationsDefaultTable.Emit(tw, locLbl, filelbl, sl, sc, el, ec)

	return locLbl
}

// extractNodeLocation extracts location information for the given node
func extractNodeLocation(tw *trap.Writer, nd ast.Node, lbl trap.Label) {
	if nd == nil {
		return
	}
	fset := tw.Package.Fset
	start, end := fset.Position(nd.Pos()), fset.Position(nd.End())
	extractLocation(tw, lbl, start.Line, start.Column, end.Line, end.Column-1)
}

// extractPackageScope extracts symbol table information for the given package
func extractPackageScope(tw *trap.Writer, pkg *packages.Package) trap.Label {
	pkgScope := pkg.Types.Scope()
	pkgScopeLabel := tw.Labeler.ScopeID(pkgScope, pkg.Types)
	dbscheme.ScopesTable.Emit(tw, pkgScopeLabel, dbscheme.PackageScopeType.Index())
	dbscheme.ScopeNestingTable.Emit(tw, pkgScopeLabel, tw.Labeler.ScopeID(types.Universe, nil))
	extractObjects(tw, pkgScope, pkgScopeLabel)
	return pkgScopeLabel
}

// extractScopeLocation extracts location information for the given scope
func extractScopeLocation(tw *trap.Writer, scope *types.Scope, lbl trap.Label) {
	fset := tw.Package.Fset
	start, end := fset.Position(scope.Pos()), fset.Position(scope.End())
	extractLocation(tw, lbl, start.Line, start.Column, end.Line, end.Column-1)
}

// extractScopes extracts symbol table information for the package scope and all local scopes
// of the given package. Note that this will not encounter methods or struct fields as
// they do not have a parent scope.
func extractScopes(tw *trap.Writer, nd *ast.File, pkg *packages.Package) {
	pkgScopeLabel := extractPackageScope(tw, pkg)
	fileScope := pkg.TypesInfo.Scopes[nd]
	if fileScope != nil {
		extractLocalScope(tw, fileScope, pkgScopeLabel)
	}
}

// extractLocalScope extracts symbol table information for the given scope and all its nested scopes
func extractLocalScope(tw *trap.Writer, scope *types.Scope, parentScopeLabel trap.Label) {
	scopeLabel := tw.Labeler.ScopeID(scope, nil)
	dbscheme.ScopesTable.Emit(tw, scopeLabel, dbscheme.LocalScopeType.Index())
	extractScopeLocation(tw, scope, scopeLabel)
	dbscheme.ScopeNestingTable.Emit(tw, scopeLabel, parentScopeLabel)

	for i := 0; i < scope.NumChildren(); i++ {
		childScope := scope.Child(i)
		extractLocalScope(tw, childScope, scopeLabel)
	}

	extractObjects(tw, scope, scopeLabel)
}

// extractFileNode extracts AST information for the given file and all nodes contained in it
func extractFileNode(tw *trap.Writer, nd *ast.File) {
	lbl := tw.Labeler.FileLabel()

	extractExpr(tw, nd.Name, lbl, 0, false)

	for i, decl := range nd.Decls {
		extractDecl(tw, decl, lbl, i)
	}

	for i, cg := range nd.Comments {
		extractCommentGroup(tw, cg, lbl, i)
	}

	extractDoc(tw, nd.Doc, lbl)
	emitScopeNodeInfo(tw, nd, lbl)
}

// extractDoc extracts information about a doc comment group associated with a given element
func extractDoc(tw *trap.Writer, doc *ast.CommentGroup, elt trap.Label) {
	if doc != nil {
		dbscheme.DocCommentsTable.Emit(tw, elt, tw.Labeler.LocalID(doc))
	}
}

// extractCommentGroup extracts information about a doc comment group
func extractCommentGroup(tw *trap.Writer, cg *ast.CommentGroup, parent trap.Label, idx int) {
	lbl := tw.Labeler.LocalID(cg)
	dbscheme.CommentGroupsTable.Emit(tw, lbl, parent, idx)
	extractNodeLocation(tw, cg, lbl)
	for i, c := range cg.List {
		extractComment(tw, c, lbl, i)
	}
}

// extractComment extracts information about a given comment
func extractComment(tw *trap.Writer, c *ast.Comment, parent trap.Label, idx int) {
	lbl := tw.Labeler.LocalID(c)
	rawText := c.Text
	var kind int
	var text string
	if rawText[:2] == "//" {
		kind = dbscheme.SlashSlashComment.Index()
		text = rawText[2:]
	} else {
		kind = dbscheme.SlashStarComment.Index()
		text = rawText[2 : len(rawText)-2]
	}
	dbscheme.CommentsTable.Emit(tw, lbl, kind, parent, idx, text)
	extractNodeLocation(tw, c, lbl)
}

// emitScopeNodeInfo associates an AST node with its induced scope, if any
func emitScopeNodeInfo(tw *trap.Writer, nd ast.Node, lbl trap.Label) {
	scope, exists := tw.Package.TypesInfo.Scopes[nd]
	if exists {
		dbscheme.ScopeNodesTable.Emit(tw, lbl, tw.Labeler.ScopeID(scope, tw.Package.Types))
	}
}

// extractExpr extracts AST information for the given expression and all its subexpressions
func extractExpr(tw *trap.Writer, expr ast.Expr, parent trap.Label, idx int, skipExtractingValue bool) {
	if expr == nil {
		return
	}

	lbl := tw.Labeler.LocalID(expr)
	extractTypeOf(tw, expr, lbl)

	var kind int
	switch expr := expr.(type) {
	case *ast.BadExpr:
		kind = dbscheme.BadExpr.Index()
	case *ast.Ident:
		if expr == nil {
			return
		}
		kind = dbscheme.IdentExpr.Index()
		dbscheme.LiteralsTable.Emit(tw, lbl, expr.Name, expr.Name)
		def := tw.Package.TypesInfo.Defs[expr]
		// Note that there are some cases where `expr` is in the map but `def`
		// is nil. The docs for `tw.Package.TypesInfo.Defs` give the following
		// examples: the package name in package clauses, or symbolic variables
		// `t` in `t := x.(type)` of type switch headers.
		if def != nil {
			defTyp := extractType(tw, def.Type())
			objlbl, exists := tw.Labeler.LookupObjectID(def, defTyp)
			if objlbl == trap.InvalidLabel {
				log.Printf("Omitting def binding to unknown object %v", def)
			} else {
				if !exists {
					extractObject(tw, def, objlbl)
				}
				dbscheme.DefsTable.Emit(tw, lbl, objlbl)
			}
		}
		use := getObjectBeingUsed(tw, expr)
		if use != nil {
			useTyp := extractType(tw, use.Type())
			objlbl, exists := tw.Labeler.LookupObjectID(use, useTyp)
			if objlbl == trap.InvalidLabel {
				log.Printf("Omitting use binding to unknown object %v", use)
			} else {
				if !exists {
					extractObject(tw, use, objlbl)
				}
				dbscheme.UsesTable.Emit(tw, lbl, objlbl)
			}
		}
	case *ast.Ellipsis:
		if expr == nil {
			return
		}
		kind = dbscheme.EllipsisExpr.Index()
		extractExpr(tw, expr.Elt, lbl, 0, false)
	case *ast.BasicLit:
		if expr == nil {
			return
		}
		value := ""
		switch expr.Kind {
		case token.INT:
			ival, _ := strconv.ParseInt(expr.Value, 0, 64)
			value = strconv.FormatInt(ival, 10)
			kind = dbscheme.IntLitExpr.Index()
		case token.FLOAT:
			value = expr.Value
			kind = dbscheme.FloatLitExpr.Index()
		case token.IMAG:
			value = expr.Value
			kind = dbscheme.ImagLitExpr.Index()
		case token.CHAR:
			value, _ = strconv.Unquote(expr.Value)
			kind = dbscheme.CharLitExpr.Index()
		case token.STRING:
			value, _ = strconv.Unquote(expr.Value)
			kind = dbscheme.StringLitExpr.Index()
		default:
			log.Fatalf("unknown literal kind %v", expr.Kind)
		}
		dbscheme.LiteralsTable.Emit(tw, lbl, value, expr.Value)
	case *ast.FuncLit:
		if expr == nil {
			return
		}
		kind = dbscheme.FuncLitExpr.Index()
		extractExpr(tw, expr.Type, lbl, 0, false)
		extractStmt(tw, expr.Body, lbl, 1)
	case *ast.CompositeLit:
		if expr == nil {
			return
		}
		kind = dbscheme.CompositeLitExpr.Index()
		extractExpr(tw, expr.Type, lbl, 0, false)
		extractExprs(tw, expr.Elts, lbl, 1, 1)
	case *ast.ParenExpr:
		if expr == nil {
			return
		}
		kind = dbscheme.ParenExpr.Index()
		extractExpr(tw, expr.X, lbl, 0, false)
	case *ast.SelectorExpr:
		if expr == nil {
			return
		}
		kind = dbscheme.SelectorExpr.Index()
		extractExpr(tw, expr.X, lbl, 0, false)
		extractExpr(tw, expr.Sel, lbl, 1, false)
	case *ast.IndexExpr:
		if expr == nil {
			return
		}
		typeofx := typeOf(tw, expr.X)
		if typeofx == nil {
			// We are missing type information for `expr.X`, so we cannot
			// determine whether this is a generic function instantiation
			// or not.
			kind = dbscheme.IndexExpr.Index()
		} else {
			if _, ok := typeofx.Underlying().(*types.Signature); ok {
				kind = dbscheme.GenericFunctionInstantiationExpr.Index()
			} else {
				// Can't distinguish between actual index expressions (into a
				// map, array, slice, string or pointer to array) and generic
				// type specialization expression, so we do it later in QL.
				kind = dbscheme.IndexExpr.Index()
			}
		}
		extractExpr(tw, expr.X, lbl, 0, false)
		extractExpr(tw, expr.Index, lbl, 1, false)
	case *ast.IndexListExpr:
		if expr == nil {
			return
		}
		typeofx := typeOf(tw, expr.X)
		if typeofx == nil {
			// We are missing type information for `expr.X`, so we cannot
			// determine whether this is a generic function instantiation
			// or not.
			kind = dbscheme.GenericTypeInstantiationExpr.Index()
		} else {
			if _, ok := typeofx.Underlying().(*types.Signature); ok {
				kind = dbscheme.GenericFunctionInstantiationExpr.Index()
			} else {
				kind = dbscheme.GenericTypeInstantiationExpr.Index()
			}
		}
		extractExpr(tw, expr.X, lbl, 0, false)
		extractExprs(tw, expr.Indices, lbl, 1, 1)
	case *ast.SliceExpr:
		if expr == nil {
			return
		}
		kind = dbscheme.SliceExpr.Index()
		extractExpr(tw, expr.X, lbl, 0, false)
		extractExpr(tw, expr.Low, lbl, 1, false)
		extractExpr(tw, expr.High, lbl, 2, false)
		extractExpr(tw, expr.Max, lbl, 3, false)
	case *ast.TypeAssertExpr:
		if expr == nil {
			return
		}
		kind = dbscheme.TypeAssertExpr.Index()
		extractExpr(tw, expr.X, lbl, 0, false)
		// expr.Type can be `nil` if this is the `x.(type)` in a type switch.
		if expr.Type != nil {
			extractExpr(tw, expr.Type, lbl, 1, false)
		}
	case *ast.CallExpr:
		if expr == nil {
			return
		}
		kind = dbscheme.CallOrConversionExpr.Index()
		extractExpr(tw, expr.Fun, lbl, 0, false)
		extractExprs(tw, expr.Args, lbl, 1, 1)
		if expr.Ellipsis.IsValid() {
			dbscheme.HasEllipsisTable.Emit(tw, lbl)
		}
	case *ast.StarExpr:
		if expr == nil {
			return
		}
		kind = dbscheme.StarExpr.Index()
		extractExpr(tw, expr.X, lbl, 0, false)
	case *ast.KeyValueExpr:
		if expr == nil {
			return
		}
		kind = dbscheme.KeyValueExpr.Index()
		extractExpr(tw, expr.Key, lbl, 0, false)
		extractExpr(tw, expr.Value, lbl, 1, false)
	case *ast.UnaryExpr:
		if expr == nil {
			return
		}
		if expr.Op == token.TILDE {
			kind = dbscheme.TypeSetLiteralExpr.Index()
		} else {
			tp := dbscheme.UnaryExprs[expr.Op]
			if tp == nil {
				log.Fatalf("unsupported unary operator %s", expr.Op)
			}
			kind = tp.Index()
		}
		extractExpr(tw, expr.X, lbl, 0, false)
	case *ast.BinaryExpr:
		if expr == nil {
			return
		}
		_, isUnionType := typeOf(tw, expr).(*types.Union)
		if expr.Op == token.OR && isUnionType {
			kind = dbscheme.TypeSetLiteralExpr.Index()
			flattenBinaryExprTree(tw, expr, lbl, 0)
		} else {
			tp := dbscheme.BinaryExprs[expr.Op]
			if tp == nil {
				log.Fatalf("unsupported binary operator %s", expr.Op)
			}
			kind = tp.Index()
			skipLeft := skipExtractingValueForLeftOperand(tw, expr)
			extractExpr(tw, expr.X, lbl, 0, skipLeft)
			extractExpr(tw, expr.Y, lbl, 1, false)
		}
	case *ast.ArrayType:
		if expr == nil {
			return
		}
		kind = dbscheme.ArrayTypeExpr.Index()
		extractExpr(tw, expr.Len, lbl, 0, false)
		extractExpr(tw, expr.Elt, lbl, 1, false)
	case *ast.StructType:
		if expr == nil {
			return
		}
		kind = dbscheme.StructTypeExpr.Index()
		extractFields(tw, expr.Fields, lbl, 0, 1)
	case *ast.FuncType:
		if expr == nil {
			return
		}
		kind = dbscheme.FuncTypeExpr.Index()
		extractFields(tw, expr.Params, lbl, 0, 1)
		extractFields(tw, expr.Results, lbl, -1, -1)
		emitScopeNodeInfo(tw, expr, lbl)
	case *ast.InterfaceType:
		if expr == nil {
			return
		}
		kind = dbscheme.InterfaceTypeExpr.Index()
		// expr.Methods contains methods, embedded interfaces and type set
		// literals.
		makeTypeSetLiteralsUnionTyped(tw, expr.Methods)
		extractFields(tw, expr.Methods, lbl, 0, 1)
	case *ast.MapType:
		if expr == nil {
			return
		}
		kind = dbscheme.MapTypeExpr.Index()
		extractExpr(tw, expr.Key, lbl, 0, false)
		extractExpr(tw, expr.Value, lbl, 1, false)
	case *ast.ChanType:
		if expr == nil {
			return
		}
		tp := dbscheme.ChanTypeExprs[expr.Dir]
		if tp == nil {
			log.Fatalf("unsupported channel direction %v", expr.Dir)
		}
		kind = tp.Index()
		extractExpr(tw, expr.Value, lbl, 0, false)
	default:
		log.Fatalf("unknown expression of type %T", expr)
	}
	dbscheme.ExprsTable.Emit(tw, lbl, kind, parent, idx)
	extractNodeLocation(tw, expr, lbl)
	if !skipExtractingValue {
		extractValueOf(tw, expr, lbl)
	}
}

// extractExprs extracts AST information for a list of expressions, which are children of
// the given parent
// `idx` is the index of the first child in the list, and `dir` is the index increment of
// each child over its preceding child (usually either 1 for assigning increasing indices, or
// -1 for decreasing indices)
func extractExprs(tw *trap.Writer, exprs []ast.Expr, parent trap.Label, idx int, dir int) {
	for _, expr := range exprs {
		extractExpr(tw, expr, parent, idx, false)
		idx += dir
	}
}

// extractTypeOf looks up the type of `expr`, extracts it if it hasn't previously been
// extracted, and associates it with `expr` in the `type_of` table
func extractTypeOf(tw *trap.Writer, expr ast.Expr, lbl trap.Label) {
	tp := typeOf(tw, expr)
	if tp != nil {
		tplbl := extractType(tw, tp)
		dbscheme.TypeOfTable.Emit(tw, lbl, tplbl)
	}
}

// extractValueOf looks up the value of `expr`, and associates it with `expr` in
// the `consts` table
func extractValueOf(tw *trap.Writer, expr ast.Expr, lbl trap.Label) {
	tpVal := tw.Package.TypesInfo.Types[expr]

	if tpVal.Value != nil {
		// if Value is non-nil, the expression has a constant value

		// note that string literals in import statements do not have an associated
		// Value and so do not get added to the table

		var value string
		exact := tpVal.Value.ExactString()
		switch tpVal.Value.Kind() {
		case constant.String:
			// we need to unquote strings
			value = constant.StringVal(tpVal.Value)
			exact = constant.StringVal(tpVal.Value)
		case constant.Float:
			flval, _ := constant.Float64Val(tpVal.Value)
			value = fmt.Sprintf("%.20g", flval)
		case constant.Complex:
			real, _ := constant.Float64Val(constant.Real(tpVal.Value))
			imag, _ := constant.Float64Val(constant.Imag(tpVal.Value))
			value = fmt.Sprintf("(%.20g + %.20gi)", real, imag)
		default:
			value = tpVal.Value.ExactString()
		}

		dbscheme.ConstValuesTable.Emit(tw, lbl, value, exact)
	} else if tpVal.IsNil() {
		dbscheme.ConstValuesTable.Emit(tw, lbl, "nil", "nil")
	}
}

// extractFields extracts AST information for a list of fields, which are children of
// the given parent
// `idx` is the index of the first child in the list, and `dir` is the index increment of
// each child over its preceding child (usually either 1 for assigning increasing indices, or
// -1 for decreasing indices)
func extractFields(tw *trap.Writer, fields *ast.FieldList, parent trap.Label, idx int, dir int) {
	if fields == nil || fields.List == nil {
		return
	}
	for _, field := range fields.List {
		lbl := tw.Labeler.LocalID(field)
		dbscheme.FieldsTable.Emit(tw, lbl, parent, idx)
		extractNodeLocation(tw, field, lbl)
		if field.Names != nil {
			for i, name := range field.Names {
				extractExpr(tw, name, lbl, i+1, false)
			}
		}
		extractExpr(tw, field.Type, lbl, 0, false)
		extractExpr(tw, field.Tag, lbl, -1, false)
		extractDoc(tw, field.Doc, lbl)
		idx += dir
	}
}

// extractStmt extracts AST information for a given statement and all other statements or expressions
// nested inside it
func extractStmt(tw *trap.Writer, stmt ast.Stmt, parent trap.Label, idx int) {
	if stmt == nil {
		return
	}

	lbl := tw.Labeler.LocalID(stmt)
	var kind int
	switch stmt := stmt.(type) {
	case *ast.BadStmt:
		kind = dbscheme.BadStmtType.Index()
	case *ast.DeclStmt:
		if stmt == nil {
			return
		}
		kind = dbscheme.DeclStmtType.Index()
		extractDecl(tw, stmt.Decl, lbl, 0)
	case *ast.EmptyStmt:
		kind = dbscheme.EmptyStmtType.Index()
	case *ast.LabeledStmt:
		if stmt == nil {
			return
		}
		kind = dbscheme.LabeledStmtType.Index()
		extractExpr(tw, stmt.Label, lbl, 0, false)
		extractStmt(tw, stmt.Stmt, lbl, 1)
	case *ast.ExprStmt:
		if stmt == nil {
			return
		}
		kind = dbscheme.ExprStmtType.Index()
		extractExpr(tw, stmt.X, lbl, 0, false)
	case *ast.SendStmt:
		if stmt == nil {
			return
		}
		kind = dbscheme.SendStmtType.Index()
		extractExpr(tw, stmt.Chan, lbl, 0, false)
		extractExpr(tw, stmt.Value, lbl, 1, false)
	case *ast.IncDecStmt:
		if stmt == nil {
			return
		}
		if stmt.Tok == token.INC {
			kind = dbscheme.IncStmtType.Index()
		} else if stmt.Tok == token.DEC {
			kind = dbscheme.DecStmtType.Index()
		} else {
			log.Fatalf("unsupported increment/decrement operator %v", stmt.Tok)
		}
		extractExpr(tw, stmt.X, lbl, 0, false)
	case *ast.AssignStmt:
		if stmt == nil {
			return
		}
		tp := dbscheme.AssignStmtTypes[stmt.Tok]
		if tp == nil {
			log.Fatalf("unsupported assignment statement with operator %v", stmt.Tok)
		}
		kind = tp.Index()
		extractExprs(tw, stmt.Lhs, lbl, -1, -1)
		extractExprs(tw, stmt.Rhs, lbl, 1, 1)
	case *ast.GoStmt:
		if stmt == nil {
			return
		}
		kind = dbscheme.GoStmtType.Index()
		extractExpr(tw, stmt.Call, lbl, 0, false)
	case *ast.DeferStmt:
		if stmt == nil {
			return
		}
		kind = dbscheme.DeferStmtType.Index()
		extractExpr(tw, stmt.Call, lbl, 0, false)
	case *ast.ReturnStmt:
		kind = dbscheme.ReturnStmtType.Index()
		extractExprs(tw, stmt.Results, lbl, 0, 1)
	case *ast.BranchStmt:
		if stmt == nil {
			return
		}
		switch stmt.Tok {
		case token.BREAK:
			kind = dbscheme.BreakStmtType.Index()
		case token.CONTINUE:
			kind = dbscheme.ContinueStmtType.Index()
		case token.GOTO:
			kind = dbscheme.GotoStmtType.Index()
		case token.FALLTHROUGH:
			kind = dbscheme.FallthroughStmtType.Index()
		default:
			log.Fatalf("unsupported branch statement type %v", stmt.Tok)
		}
		extractExpr(tw, stmt.Label, lbl, 0, false)
	case *ast.BlockStmt:
		if stmt == nil {
			return
		}
		kind = dbscheme.BlockStmtType.Index()
		extractStmts(tw, stmt.List, lbl, 0, 1)
		emitScopeNodeInfo(tw, stmt, lbl)
	case *ast.IfStmt:
		if stmt == nil {
			return
		}
		kind = dbscheme.IfStmtType.Index()
		extractStmt(tw, stmt.Init, lbl, 0)
		extractExpr(tw, stmt.Cond, lbl, 1, false)
		extractStmt(tw, stmt.Body, lbl, 2)
		extractStmt(tw, stmt.Else, lbl, 3)
		emitScopeNodeInfo(tw, stmt, lbl)
	case *ast.CaseClause:
		if stmt == nil {
			return
		}
		kind = dbscheme.CaseClauseType.Index()
		extractExprs(tw, stmt.List, lbl, -1, -1)
		extractStmts(tw, stmt.Body, lbl, 0, 1)
		emitScopeNodeInfo(tw, stmt, lbl)
	case *ast.SwitchStmt:
		if stmt == nil {
			return
		}
		kind = dbscheme.ExprSwitchStmtType.Index()
		extractStmt(tw, stmt.Init, lbl, 0)
		extractExpr(tw, stmt.Tag, lbl, 1, false)
		extractStmt(tw, stmt.Body, lbl, 2)
		emitScopeNodeInfo(tw, stmt, lbl)
	case *ast.TypeSwitchStmt:
		if stmt == nil {
			return
		}
		kind = dbscheme.TypeSwitchStmtType.Index()
		extractStmt(tw, stmt.Init, lbl, 0)
		extractStmt(tw, stmt.Assign, lbl, 1)
		extractStmt(tw, stmt.Body, lbl, 2)
		emitScopeNodeInfo(tw, stmt, lbl)
	case *ast.CommClause:
		if stmt == nil {
			return
		}
		kind = dbscheme.CommClauseType.Index()
		extractStmt(tw, stmt.Comm, lbl, 0)
		extractStmts(tw, stmt.Body, lbl, 1, 1)
		emitScopeNodeInfo(tw, stmt, lbl)
	case *ast.SelectStmt:
		kind = dbscheme.SelectStmtType.Index()
		extractStmt(tw, stmt.Body, lbl, 0)
	case *ast.ForStmt:
		if stmt == nil {
			return
		}
		kind = dbscheme.ForStmtType.Index()
		extractStmt(tw, stmt.Init, lbl, 0)
		extractExpr(tw, stmt.Cond, lbl, 1, false)
		extractStmt(tw, stmt.Post, lbl, 2)
		extractStmt(tw, stmt.Body, lbl, 3)
		emitScopeNodeInfo(tw, stmt, lbl)
	case *ast.RangeStmt:
		if stmt == nil {
			return
		}
		kind = dbscheme.RangeStmtType.Index()
		extractExpr(tw, stmt.Key, lbl, 0, false)
		extractExpr(tw, stmt.Value, lbl, 1, false)
		extractExpr(tw, stmt.X, lbl, 2, false)
		extractStmt(tw, stmt.Body, lbl, 3)
		emitScopeNodeInfo(tw, stmt, lbl)
	default:
		log.Fatalf("unknown statement of type %T", stmt)
	}
	dbscheme.StmtsTable.Emit(tw, lbl, kind, parent, idx)
	extractNodeLocation(tw, stmt, lbl)
}

// extractStmts extracts AST information for a list of statements, which are children of
// the given parent
// `idx` is the index of the first child in the list, and `dir` is the index increment of
// each child over its preceding child (usually either 1 for assigning increasing indices, or
// -1 for decreasing indices)
func extractStmts(tw *trap.Writer, stmts []ast.Stmt, parent trap.Label, idx int, dir int) {
	for _, stmt := range stmts {
		extractStmt(tw, stmt, parent, idx)
		idx += dir
	}
}

// extractDecl extracts AST information for the given declaration
func extractDecl(tw *trap.Writer, decl ast.Decl, parent trap.Label, idx int) {
	lbl := tw.Labeler.LocalID(decl)
	var kind int
	switch decl := decl.(type) {
	case *ast.BadDecl:
		kind = dbscheme.BadDeclType.Index()
	case *ast.GenDecl:
		if decl == nil {
			return
		}
		switch decl.Tok {
		case token.IMPORT:
			kind = dbscheme.ImportDeclType.Index()
		case token.CONST:
			kind = dbscheme.ConstDeclType.Index()
		case token.TYPE:
			kind = dbscheme.TypeDeclType.Index()
		case token.VAR:
			kind = dbscheme.VarDeclType.Index()
		default:
			log.Fatalf("unknown declaration of kind %v", decl.Tok)
		}
		for i, spec := range decl.Specs {
			extractSpec(tw, spec, lbl, i)
		}
		extractDoc(tw, decl.Doc, lbl)
	case *ast.FuncDecl:
		if decl == nil {
			return
		}
		kind = dbscheme.FuncDeclType.Index()
		extractFields(tw, decl.Recv, lbl, -1, -1)
		extractExpr(tw, decl.Name, lbl, 0, false)
		extractExpr(tw, decl.Type, lbl, 1, false)
		extractStmt(tw, decl.Body, lbl, 2)
		extractDoc(tw, decl.Doc, lbl)
		extractTypeParamDecls(tw, decl.Type.TypeParams, lbl)

		// Note that we currently don't extract any kind of declaration for
		// receiver type parameters. There isn't an explicit declaration, but
		// we could consider the index/indices of an IndexExpr/IndexListExpr
		// receiver as declarations.
	default:
		log.Fatalf("unknown declaration of type %T", decl)
	}
	dbscheme.DeclsTable.Emit(tw, lbl, kind, parent, idx)
	extractNodeLocation(tw, decl, lbl)
}

// extractSpec extracts AST information for the given declaration specifier
func extractSpec(tw *trap.Writer, spec ast.Spec, parent trap.Label, idx int) {
	lbl := tw.Labeler.LocalID(spec)
	var kind int
	switch spec := spec.(type) {
	case *ast.ImportSpec:
		if spec == nil {
			return
		}
		kind = dbscheme.ImportSpecType.Index()
		extractExpr(tw, spec.Name, lbl, 0, false)
		extractExpr(tw, spec.Path, lbl, 1, false)
		extractDoc(tw, spec.Doc, lbl)
	case *ast.ValueSpec:
		if spec == nil {
			return
		}
		kind = dbscheme.ValueSpecType.Index()
		for i, name := range spec.Names {
			extractExpr(tw, name, lbl, -(1 + i), false)
		}
		extractExpr(tw, spec.Type, lbl, 0, false)
		extractExprs(tw, spec.Values, lbl, 1, 1)
		extractDoc(tw, spec.Doc, lbl)
	case *ast.TypeSpec:
		if spec == nil {
			return
		}
		if spec.Assign.IsValid() {
			kind = dbscheme.AliasSpecType.Index()
		} else {
			kind = dbscheme.TypeDefSpecType.Index()
		}
		extractExpr(tw, spec.Name, lbl, 0, false)
		extractTypeParamDecls(tw, spec.TypeParams, lbl)
		extractExpr(tw, spec.Type, lbl, 1, false)
		extractDoc(tw, spec.Doc, lbl)
	}
	dbscheme.SpecsTable.Emit(tw, lbl, kind, parent, idx)
	extractNodeLocation(tw, spec, lbl)
}

// Determines whether the given type is an alias.
func isAlias(tp types.Type) bool {
	_, ok := tp.(*types.Alias)
	return ok
}

// If the given type is a type alias, this function resolves it to its underlying type.
func resolveTypeAlias(tp types.Type) types.Type {
	if isAlias(tp) {
		return types.Unalias(tp) // tp.Underlying()
	}
	return tp
}

// extractType extracts type information for `tp` and returns its associated label;
// types are only extracted once, so the second time `extractType` is invoked it simply returns the label
func extractType(tw *trap.Writer, tp types.Type) trap.Label {
	tp = resolveTypeAlias(tp)
	lbl, exists := getTypeLabel(tw, tp)
	if !exists {
		var kind int
		switch tp := tp.(type) {
		case *types.Basic:
			branch := dbscheme.BasicTypes[tp.Kind()]
			if branch == nil {
				log.Fatalf("unknown basic type %v", tp.Kind())
			}
			kind = branch.Index()
		case *types.Array:
			kind = dbscheme.ArrayType.Index()
			dbscheme.ArrayLengthTable.Emit(tw, lbl, fmt.Sprintf("%d", tp.Len()))
			extractElementType(tw, lbl, tp.Elem())
		case *types.Slice:
			kind = dbscheme.SliceType.Index()
			extractElementType(tw, lbl, tp.Elem())
		case *types.Struct:
			kind = dbscheme.StructType.Index()
			for i := 0; i < tp.NumFields(); i++ {
				field := tp.Field(i).Origin()

				// ensure the field is associated with a label - note that
				// struct fields do not have a parent scope, so they are not
				// dealt with by `extractScopes`
				fieldlbl, exists := tw.Labeler.FieldID(field, i, lbl)
				if !exists {
					extractObject(tw, field, fieldlbl)
				}

				dbscheme.FieldStructsTable.Emit(tw, fieldlbl, lbl)

				name := field.Name()
				if field.Embedded() {
					name = ""
				}
				extractComponentType(tw, lbl, i, name, field.Type())
				if tp.Tag(i) != "" {
					dbscheme.StructTagsTable.Emit(tw, lbl, i, tp.Tag(i))
				}
			}
		case *types.Pointer:
			kind = dbscheme.PointerType.Index()
			extractBaseType(tw, lbl, tp.Elem())
		case *types.Interface:
			kind = dbscheme.InterfaceType.Index()
			for i := 0; i < tp.NumMethods(); i++ {
				// Note that methods coming from embedded interfaces can be
				// accessed through `Method(i)`, so there is no need to
				// deal with them separately.
				meth := tp.Method(i).Origin()

				// Note that methods do not have a parent scope, so they are
				// not dealt with by `extractScopes`
				extractMethod(tw, meth)

				extractComponentType(tw, lbl, i, meth.Name(), meth.Type())

				if !meth.Exported() {
					dbscheme.InterfacePrivateMethodIdsTable.Emit(tw, lbl, i, meth.Id())
				}
			}
			for i := 0; i < tp.NumEmbeddeds(); i++ {
				component := tp.EmbeddedType(i)
				if isNonUnionTypeSetLiteral(component) {
					component = createUnionFromType(component)
				}
				extractComponentType(tw, lbl, -(i + 1), "", component)
			}
		case *types.Tuple:
			kind = dbscheme.TupleType.Index()
			for i := 0; i < tp.Len(); i++ {
				extractComponentType(tw, lbl, i, "", tp.At(i).Type())
			}
		case *types.Signature:
			kind = dbscheme.SignatureType.Index()
			params, results := tp.Params(), tp.Results()
			if params != nil {
				for i := 0; i < params.Len(); i++ {
					param := params.At(i)
					extractComponentType(tw, lbl, i+1, "", param.Type())
				}
			}
			if results != nil {
				for i := 0; i < results.Len(); i++ {
					result := results.At(i)
					extractComponentType(tw, lbl, -(i + 1), "", result.Type())
				}
			}
			if tp.Variadic() {
				dbscheme.VariadicTable.Emit(tw, lbl)
			}
		case *types.Map:
			kind = dbscheme.MapType.Index()
			extractKeyType(tw, lbl, tp.Key())
			extractElementType(tw, lbl, tp.Elem())
		case *types.Chan:
			kind = dbscheme.ChanTypes[tp.Dir()].Index()
			extractElementType(tw, lbl, tp.Elem())
		case *types.Named:
			origintp := tp.Origin()
			kind = dbscheme.NamedType.Index()
			dbscheme.TypeNameTable.Emit(tw, lbl, origintp.Obj().Name())
			underlying := origintp.Underlying()
			extractUnderlyingType(tw, lbl, underlying)
			trackInstantiatedStructFields(tw, tp, origintp)

			entitylbl, exists := tw.Labeler.LookupObjectID(origintp.Obj(), lbl)
			if entitylbl == trap.InvalidLabel {
				log.Printf("Omitting type-object binding for unknown object %v.\n", origintp.Obj())
			} else {
				if !exists {
					extractObject(tw, origintp.Obj(), entitylbl)
				}
				dbscheme.TypeObjectTable.Emit(tw, lbl, entitylbl)
			}

			// ensure all methods have labels - note that methods do not have a
			// parent scope, so they are not dealt with by `extractScopes`
			for i := 0; i < origintp.NumMethods(); i++ {
				meth := origintp.Method(i).Origin()

				extractMethod(tw, meth)
			}

			underlyingInterface, underlyingIsInterface := underlying.(*types.Interface)
			_, underlyingIsPointer := underlying.(*types.Pointer)

			// associate all methods of underlying interface with this type
			if underlyingIsInterface {
				for i := 0; i < underlyingInterface.NumMethods(); i++ {
					methlbl := extractMethod(tw, underlyingInterface.Method(i).Origin())
					dbscheme.MethodHostsTable.Emit(tw, methlbl, lbl)
				}
			}

			// If `underlying` is not a pointer or interface then methods can
			// be defined on `origintp`. In this case we must ensure that
			// `*origintp` is in the database, so that Method.hasQualifiedName
			// correctly includes methods with receiver type `*origintp`.
			if !underlyingIsInterface && !underlyingIsPointer {
				extractType(tw, types.NewPointer(origintp))
			}
		case *types.TypeParam:
			kind = dbscheme.TypeParamType.Index()
			parentlbl := getTypeParamParentLabel(tw, tp)
			constraintLabel := extractType(tw, tp.Constraint())
			dbscheme.TypeParamTable.Emit(tw, lbl, tp.Obj().Name(), constraintLabel, parentlbl, tp.Index())
		case *types.Union:
			kind = dbscheme.TypeSetLiteral.Index()
			for i := 0; i < tp.Len(); i++ {
				term := tp.Term(i)
				tildeStr := ""
				if term.Tilde() {
					tildeStr = "~"
				}
				extractComponentType(tw, lbl, i, tildeStr, term.Type())
			}
		default:
			log.Fatalf("unexpected type %T", tp)
		}
		dbscheme.TypesTable.Emit(tw, lbl, kind)
	}
	return lbl
}

// getTypeLabel looks up the label associated with `tp`, creating a new label if
// it does not have one yet; the second result indicates whether the label
// already existed
//
// Type labels refer to global keys to ensure that if the same type is
// encountered during the extraction of different files it is still ultimately
// mapped to the same entity. In particular, this means that keys for compound
// types refer to the labels of their component types. For named types, the key
// is constructed from their globally unique ID. This prevents cyclic type keys
// since type recursion in Go always goes through named types.
func getTypeLabel(tw *trap.Writer, tp types.Type) (trap.Label, bool) {
	tp = resolveTypeAlias(tp)
	lbl, exists := tw.Labeler.TypeLabels[tp]
	if !exists {
		switch tp := tp.(type) {
		case *types.Basic:
			lbl = tw.Labeler.GlobalID(fmt.Sprintf("%d;basictype", tp.Kind()))
		case *types.Array:
			len := tp.Len()
			elem := extractType(tw, tp.Elem())
			lbl = tw.Labeler.GlobalID(fmt.Sprintf("%d,{%s};arraytype", len, elem))
		case *types.Slice:
			elem := extractType(tw, tp.Elem())
			lbl = tw.Labeler.GlobalID(fmt.Sprintf("{%s};slicetype", elem))
		case *types.Struct:
			var b strings.Builder
			for i := 0; i < tp.NumFields(); i++ {
				field := tp.Field(i)
				fieldTypeLbl := extractType(tw, field.Type())
				if i > 0 {
					b.WriteString(",")
				}
				name := field.Name()
				if field.Embedded() {
					name = ""
				}
				fmt.Fprintf(&b, "%s,{%s},%s", name, fieldTypeLbl, util.EscapeTrapSpecialChars(tp.Tag(i)))
			}
			lbl = tw.Labeler.GlobalID(fmt.Sprintf("%s;structtype", b.String()))
		case *types.Pointer:
			base := extractType(tw, tp.Elem())
			lbl = tw.Labeler.GlobalID(fmt.Sprintf("{%s};pointertype", base))
		case *types.Interface:
			var b strings.Builder
			for i := 0; i < tp.NumMethods(); i++ {
				meth := tp.Method(i).Origin()
				methLbl := extractType(tw, meth.Type())
				if i > 0 {
					b.WriteString(",")
				}
				fmt.Fprintf(&b, "%s,{%s}", meth.Id(), methLbl)
			}
			b.WriteString(";")
			for i := 0; i < tp.NumEmbeddeds(); i++ {
				if i > 0 {
					b.WriteString(",")
				}
				fmt.Fprintf(&b, "{%s}", extractType(tw, tp.EmbeddedType(i)))
			}
			// We note whether the interface is comparable so that we can
			// distinguish the underlying type of `comparable` from an
			// empty interface.
			if tp.IsComparable() {
				b.WriteString(";comparable")
			}
			lbl = tw.Labeler.GlobalID(fmt.Sprintf("%s;interfacetype", b.String()))
		case *types.Tuple:
			var b strings.Builder
			for i := 0; i < tp.Len(); i++ {
				compLbl := extractType(tw, tp.At(i).Type())
				if i > 0 {
					b.WriteString(",")
				}
				fmt.Fprintf(&b, "{%s}", compLbl)
			}
			lbl = tw.Labeler.GlobalID(fmt.Sprintf("%s;tupletype", b.String()))
		case *types.Signature:
			var b strings.Builder
			params, results := tp.Params(), tp.Results()
			if params != nil {
				for i := 0; i < params.Len(); i++ {
					paramLbl := extractType(tw, params.At(i).Type())
					if i > 0 {
						b.WriteString(",")
					}
					fmt.Fprintf(&b, "{%s}", paramLbl)
				}
			}
			b.WriteString(";")
			if results != nil {
				for i := 0; i < results.Len(); i++ {
					resultLbl := extractType(tw, results.At(i).Type())
					if i > 0 {
						b.WriteString(",")
					}
					fmt.Fprintf(&b, "{%s}", resultLbl)
				}
			}
			if tp.Variadic() {
				b.WriteString(";variadic")
			}
			lbl = tw.Labeler.GlobalID(fmt.Sprintf("%s;signaturetype", b.String()))
		case *types.Map:
			key := extractType(tw, tp.Key())
			value := extractType(tw, tp.Elem())
			lbl = tw.Labeler.GlobalID(fmt.Sprintf("{%s},{%s};maptype", key, value))
		case *types.Chan:
			dir := tp.Dir()
			elem := extractType(tw, tp.Elem())
			lbl = tw.Labeler.GlobalID(fmt.Sprintf("%v,{%s};chantype", dir, elem))
		case *types.Named:
			origintp := tp.Origin()
			entitylbl, exists := tw.Labeler.LookupObjectID(origintp.Obj(), lbl)
			if entitylbl == trap.InvalidLabel {
				panic(fmt.Sprintf("Cannot construct label for named type %v (underlying object is %v).\n", origintp, origintp.Obj()))
			}
			if !exists {
				extractObject(tw, origintp.Obj(), entitylbl)
			}
			lbl = tw.Labeler.GlobalID(fmt.Sprintf("{%s};namedtype", entitylbl))
		case *types.TypeParam:
			parentlbl := getTypeParamParentLabel(tw, tp)
			idx := tp.Index()
			lbl = tw.Labeler.GlobalID(fmt.Sprintf("{%v},%d,%s;typeparamtype", parentlbl, idx, tp.Obj().Name()))
		case *types.Union:
			var b strings.Builder
			for i := 0; i < tp.Len(); i++ {
				compLbl := extractType(tw, tp.Term(i).Type())
				if i > 0 {
					b.WriteString("|")
				}
				if tp.Term(i).Tilde() {
					b.WriteString("~")
				}
				fmt.Fprintf(&b, "{%s}", compLbl)
			}
			lbl = tw.Labeler.GlobalID(fmt.Sprintf("%s;typesetliteraltype", b.String()))
		default:
			log.Fatalf("(getTypeLabel) unexpected type %T", tp)
		}
		tw.Labeler.TypeLabels[tp] = lbl
	}
	return lbl, exists
}

// extractKeyType extracts `key` as the key type of the map type `mp`
func extractKeyType(tw *trap.Writer, mp trap.Label, key types.Type) {
	dbscheme.KeyTypeTable.Emit(tw, mp, extractType(tw, key))
}

// extractElementType extracts `element` as the element type of the container type `container`
func extractElementType(tw *trap.Writer, container trap.Label, element types.Type) {
	dbscheme.ElementTypeTable.Emit(tw, container, extractType(tw, element))
}

// extractBaseType extracts `base` as the base type of the pointer type `ptr`
func extractBaseType(tw *trap.Writer, ptr trap.Label, base types.Type) {
	dbscheme.BaseTypeTable.Emit(tw, ptr, extractType(tw, base))
}

// extractUnderlyingType extracts `underlying` as the underlying type of the
// named type `named`
func extractUnderlyingType(tw *trap.Writer, named trap.Label, underlying types.Type) {
	dbscheme.UnderlyingTypeTable.Emit(tw, named, extractType(tw, underlying))
}

// extractComponentType extracts `component` as the `idx`th component type of `parent` with name `name`
func extractComponentType(tw *trap.Writer, parent trap.Label, idx int, name string, component types.Type) {
	dbscheme.ComponentTypesTable.Emit(tw, parent, idx, name, extractType(tw, component))
}

// extractNumLines extracts lines-of-code and lines-of-comments information for the
// given file
func extractNumLines(tw *trap.Writer, fileName string, ast *ast.File) {
	f := tw.Package.Fset.File(ast.Pos())

	lineCount := f.LineCount()

	// count lines of code by tokenizing
	linesOfCode := 0
	src, err := os.ReadFile(fileName)
	if err != nil {
		log.Fatalf("Unable to read file %s.", fileName)
	}
	var s scanner.Scanner
	lastCodeLine := -1
	s.Init(f, src, nil, 0)
	for {
		pos, tok, lit := s.Scan()
		if tok == token.EOF {
			break
		} else if tok != token.ILLEGAL && !(tok == token.SEMICOLON && lit == "\n") {
			// specifically exclude newlines that are treated as semicolons
			tkStartLine := f.Position(pos).Line
			tkEndLine := tkStartLine + strings.Count(lit, "\n")
			if tkEndLine > lastCodeLine {
				if tkStartLine <= lastCodeLine {
					// if the start line is the same as the last code line we've seen we don't want to double
					// count it
					// note tkStartLine < lastCodeLine should not be possible
					linesOfCode += tkEndLine - lastCodeLine
				} else {
					linesOfCode += tkEndLine - tkStartLine + 1
				}
				lastCodeLine = tkEndLine
			}
		}
	}

	// count lines of comments by iterating over ast.Comments
	linesOfComments := 0
	for _, cg := range ast.Comments {
		for _, g := range cg.List {
			fset := tw.Package.Fset
			startPos, endPos := fset.Position(g.Pos()), fset.Position(g.End())
			linesOfComments += endPos.Line - startPos.Line + 1
		}
	}

	dbscheme.NumlinesTable.Emit(tw, tw.Labeler.FileLabel(), lineCount, linesOfCode, linesOfComments)
}

// For a type `t` which is the type of a field of an interface type, return
// whether `t` a type set literal which is not a union type. Note that a field
// of an interface must be a method signature, an embedded interface type or a
// type set literal.
func isNonUnionTypeSetLiteral(t types.Type) bool {
	if t == nil {
		return false
	}
	switch t.Underlying().(type) {
	case *types.Interface, *types.Union, *types.Signature:
		return false
	default:
		return true
	}
}

// Given a type `t`, return a union with a single term that is `t` without a
// tilde.
func createUnionFromType(t types.Type) *types.Union {
	return types.NewUnion([]*types.Term{types.NewTerm(false, t)})
}

// Go through a `FieldList` and update the types of all type set literals which
// are not already union types to be union types. We do this by changing the
// types stored in `tw.Package.TypesInfo.Types`. Type set literals can only
// occur in two places: a type parameter declaration or a type in an interface.
func makeTypeSetLiteralsUnionTyped(tw *trap.Writer, fields *ast.FieldList) {
	if fields == nil || fields.List == nil {
		return
	}
	for i := 0; i < len(fields.List); i++ {
		x := fields.List[i].Type
		if _, alreadyOverridden := tw.TypesOverride[x]; !alreadyOverridden {
			xtp := typeOf(tw, x)
			if isNonUnionTypeSetLiteral(xtp) {
				tw.TypesOverride[x] = createUnionFromType(xtp)
			}
		}
	}
}

func typeOf(tw *trap.Writer, e ast.Expr) types.Type {
	if val, ok := tw.TypesOverride[e]; ok {
		return val
	}
	return tw.Package.TypesInfo.TypeOf(e)
}

func flattenBinaryExprTree(tw *trap.Writer, e ast.Expr, parent trap.Label, idx int) int {
	binaryexpr, ok := e.(*ast.BinaryExpr)
	if ok {
		idx = flattenBinaryExprTree(tw, binaryexpr.X, parent, idx)
		idx = flattenBinaryExprTree(tw, binaryexpr.Y, parent, idx)
	} else {
		extractExpr(tw, e, parent, idx, false)
		idx = idx + 1
	}
	return idx
}

func extractTypeParamDecls(tw *trap.Writer, fields *ast.FieldList, parent trap.Label) {
	if fields == nil || fields.List == nil {
		return
	}

	// Type set literals can occur as the type in a type parameter declaration,
	// so we ensure that they are union typed.
	makeTypeSetLiteralsUnionTyped(tw, fields)

	idx := 0
	for _, field := range fields.List {
		lbl := tw.Labeler.LocalID(field)
		dbscheme.TypeParamDeclsTable.Emit(tw, lbl, parent, idx)
		extractNodeLocation(tw, field, lbl)
		if field.Names != nil {
			for i, name := range field.Names {
				extractExpr(tw, name, lbl, i+1, false)
			}
		}
		extractExpr(tw, field.Type, lbl, 0, false)
		extractDoc(tw, field.Doc, lbl)
		idx += 1
	}
}

// populateTypeParamParents sets `parent` as the parent of the elements of `typeparams`
func populateTypeParamParents(typeparams *types.TypeParamList, parent types.Object) {
	if typeparams != nil {
		for idx := 0; idx < typeparams.Len(); idx++ {
			setTypeParamParent(typeparams.At(idx), parent)
		}
	}
}

// getobjectBeingUsed looks up `ident` in `tw.Package.TypesInfo.Uses` and makes
// some changes to the object to avoid returning objects relating to instantiated
// types.
func getObjectBeingUsed(tw *trap.Writer, ident *ast.Ident) types.Object {
	switch obj := tw.Package.TypesInfo.Uses[ident].(type) {
	case *types.Var:
		return obj.Origin()
	case *types.Func:
		return obj.Origin()
	default:
		return obj
	}
}

// trackInstantiatedStructFields tries to give the fields of an instantiated
// struct type underlying `tp` the same labels as the corresponding fields of
// the generic struct type. This is so that when we come across the
// instantiated field in `tw.Package.TypesInfo.Uses` we will get the label for
// the generic field instead.
func trackInstantiatedStructFields(tw *trap.Writer, tp, origintp *types.Named) {
	if tp == origintp {
		return
	}

	if instantiatedStruct, ok := tp.Underlying().(*types.Struct); ok {
		genericStruct, ok2 := origintp.Underlying().(*types.Struct)
		if !ok2 {
			log.Fatalf(
				"Error: underlying type of instantiated type is a struct but underlying type of generic type is %s",
				origintp.Underlying())
		}

		if instantiatedStruct.NumFields() != genericStruct.NumFields() {
			log.Fatalf(
				"Error: instantiated struct %s has different number of fields than the generic version %s (%d != %d)",
				instantiatedStruct, genericStruct, instantiatedStruct.NumFields(), genericStruct.NumFields())
		}

		for i := 0; i < instantiatedStruct.NumFields(); i++ {
			tw.ObjectsOverride[instantiatedStruct.Field(i)] = genericStruct.Field(i)
		}
	}
}

func getTypeParamParentLabel(tw *trap.Writer, tp *types.TypeParam) trap.Label {
	parent, exists := typeParamParent[tp]
	if !exists {
		log.Fatalf("Parent of type parameter does not exist: %s %s", tp.String(), tp.Constraint().String())
	}
	parentlbl, _ := tw.Labeler.ScopedObjectID(parent, func() trap.Label {
		log.Fatalf("getTypeLabel() called for parent of type parameter %s", tp.String())
		return trap.InvalidLabel
	})
	return parentlbl
}

func setTypeParamParent(tp *types.TypeParam, newobj types.Object) {
	obj, exists := typeParamParent[tp]
	if !exists {
		typeParamParent[tp] = newobj
	} else if newobj != obj {
		log.Fatalf("Parent of type parameter '%s %s' being set to a different value: '%s' vs '%s'", tp.String(), tp.Constraint().String(), obj, newobj)
	}
}

// skipExtractingValueForLeftOperand returns true if the left operand of `be`
// should not have its value extracted because it is an intermediate value in a
// string concatenation - specifically that the right operand is a string
// literal
func skipExtractingValueForLeftOperand(tw *trap.Writer, be *ast.BinaryExpr) bool {
	// check `be` has string type
	tpVal := tw.Package.TypesInfo.Types[be]
	if tpVal.Value == nil || tpVal.Value.Kind() != constant.String {
		return false
	}
	// check that the right operand of `be` is a basic literal
	if _, isBasicLit := be.Y.(*ast.BasicLit); !isBasicLit {
		return false
	}
	// check that the left operand of `be` is not a basic literal
	if _, isBasicLit := be.X.(*ast.BasicLit); isBasicLit {
		return false
	}
	return true
}

// checkObjectNotSpecialized exits the program if `obj` is specialized. Note
// that specialization is only possible for function objects and variable
// objects.
func checkObjectNotSpecialized(obj types.Object) {
	if funcObj, ok := obj.(*types.Func); ok && funcObj != funcObj.Origin() {
		log.Fatalf("Encountered unexpected specialization %s of generic function object %s", funcObj.FullName(), funcObj.Origin().FullName())
	}
	if varObj, ok := obj.(*types.Var); ok && varObj != varObj.Origin() {
		log.Fatalf("Encountered unexpected specialization %s of generic variable object %s", varObj.String(), varObj.Origin().String())
	}
	if typeNameObj, ok := obj.(*types.TypeName); ok {
		if namedType, ok := typeNameObj.Type().(*types.Named); ok && namedType != namedType.Origin() {
			log.Fatalf("Encountered type object for specialization %s of named type %s", namedType.String(), namedType.Origin().String())
		}
	}
}

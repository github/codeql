package main

import (
	"fmt"
	"log"
	"os"
	"runtime"
	"runtime/pprof"
	"strings"

	"github.com/github/codeql-go/extractor"
	"github.com/github/codeql-go/extractor/diagnostics"
	"github.com/github/codeql-go/extractor/util"
)

var cpuprofile, memprofile string

func usage() {
	fmt.Fprintf(os.Stderr, "%s is a program for building a snapshot of a Go code base.\n\n", os.Args[0])
	fmt.Fprintf(os.Stderr, "Usage:\n\n  %s [<flag>...] [<buildflag>...] [--] <file>...\n\n", os.Args[0])
	fmt.Fprintf(os.Stderr, "Flags:\n\n")
	fmt.Fprintf(os.Stderr, "--help                Print this help.\n")
}

// extractTests is set (a) if we were manually commanded to extract tests via the relevant
// environment variable / extractor option, or (b) we're mimicking a `go test` command.
func parseFlags(args []string, mimic bool, extractTests bool) ([]string, []string, bool, string) {
	i := 0
	buildFlags := []string{}
	var sourceRoot string
	for ; i < len(args) && strings.HasPrefix(args[i], "-"); i++ {
		if args[i] == "--" {
			i++
			break
		}

		if !mimic {
			// we're not in mimic mode, try to parse our arguments
			switch args[i] {
			case "--help":
				usage()
				os.Exit(0)
			case "--mimic":
				if i+1 < len(args) {
					i++
					compiler := args[i]
					log.Printf("Compiler: %s", compiler)
					if i+1 < len(args) {
						i++
						command := args[i]
						if command == "build" || command == "install" || command == "run" || command == "test" {
							log.Printf("Intercepting build for %s command", command)
							return parseFlags(args[i+1:], true, command == "test")
						} else {
							log.Printf("Non-build command '%s'; skipping", strings.Join(args[1:], " "))
							os.Exit(0)
						}
					} else {
						log.Printf("Non-build command '%s'; skipping", strings.Join(args[1:], " "))
						os.Exit(0)
					}
				} else {
					log.Fatalf("--mimic requires an argument, e.g. --mimic go")
				}
			case "--source-root":
				// The extractor can be called by the autobuilder with the working directory set to
				// the directory containing the workspace we're extracting, and this may be a
				// subdirectory of the actual source root. This argument lets us resolve paths that
				// are relative to that source root, e.g. for the list of overlay changed files.
				if i+1 < len(args) {
					i++
					sourceRoot = args[i]
					log.Printf("Source root is %s", sourceRoot)
				} else {
					log.Fatalf("--source-root requires an argument, e.g. --source-root /path/to/root")
				}
			}
		}

		// parse go build flags
		switch args[i] {
		// skip `-o output`, `-i` and `-c`, if applicable
		case "-o":
			if i+1 < len(args) {
				i++
			}
		case "-i", "-c":
		case "-p", "-asmflags", "-buildmode", "-compiler", "-gccgoflags", "-gcflags", "-installsuffix",
			"-ldflags", "-mod", "-modfile", "-pkgdir", "-tags", "-toolexec", "-overlay":
			if i+1 < len(args) {
				buildFlags = append(buildFlags, args[i], args[i+1])
				i++
			} else {
				buildFlags = append(buildFlags, args[i])
			}
		default:
			if strings.HasPrefix(args[i], "-") {
				buildFlags = append(buildFlags, args[i])
			} else {
				// stop parsing if the argument is not a flag (and so is positional)
				break
			}
		}
	}

	cpuprofile = os.Getenv("CODEQL_EXTRACTOR_GO_CPU_PROFILE")
	memprofile = os.Getenv("CODEQL_EXTRACTOR_GO_MEM_PROFILE")

	return buildFlags, args[i:], extractTests, sourceRoot
}

func main() {
	util.SetLogLevel()

	extractTestsDefault := os.Getenv("CODEQL_EXTRACTOR_GO_OPTION_EXTRACT_TESTS") == "true"
	buildFlags, patterns, extractTests, sourceRoot := parseFlags(os.Args[1:], false, extractTestsDefault)

	if cpuprofile != "" {
		f, err := os.Create(cpuprofile)
		if err != nil {
			log.Fatalf("Unable to create CPU profile: %v.", err)
		}
		defer f.Close()
		if err := pprof.StartCPUProfile(f); err != nil {
			log.Fatalf("Unable to start CPU profile: %v.", err)
		}
		defer pprof.StopCPUProfile()
	}

	if len(patterns) == 0 {
		log.Println("No packages explicitly provided, adding '.'")
		patterns = []string{"."}
	}

	log.Printf("Build flags: '%s'; patterns: '%s'\n", strings.Join(buildFlags, " "), strings.Join(patterns, " "))
	err := extractor.ExtractWithFlags(buildFlags, patterns, extractTests, sourceRoot)
	if err != nil {
		errString := err.Error()
		if strings.Contains(errString, "unexpected directory layout:") {
			diagnostics.EmitRelativeImportPaths()
		}

		log.Fatalf("Error running go tooling: %s\n", errString)
	}

	if memprofile != "" {
		f, err := os.Create(memprofile)
		if err != nil {
			log.Fatalf("Unable to create memory profile: %v", err)
		}
		defer f.Close()
		runtime.GC() // get up-to-date statistics
		if err := pprof.WriteHeapProfile(f); err != nil {
			log.Fatal("Unable to write memory profile: ", err)
		}
	}
}

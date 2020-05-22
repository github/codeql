package main

import (
	"fmt"
	"log"
	"os"
	"runtime"
	"runtime/pprof"
	"strings"

	"github.com/github/codeql-go/extractor"
)

var cpuprofile, memprofile string

func usage() {
	fmt.Fprintf(os.Stderr, "%s is a program for building a snapshot of a Go code base.\n\n", os.Args[0])
	fmt.Fprintf(os.Stderr, "Usage:\n\n  %s [<flag>...] [<buildflag>...] [--] <file>...\n\n", os.Args[0])
	fmt.Fprintf(os.Stderr, "Flags:\n\n")
	fmt.Fprintf(os.Stderr, "--help                Print this help.\n")
}

func parseFlags(args []string) ([]string, []string) {
	i := 0
	buildFlags := []string{}
	for i < len(args) && strings.HasPrefix(args[i], "-") {
		if args[i] == "--" {
			i++
			break
		}

		if args[i] == "--help" {
			usage()
			os.Exit(0)
		} else {
			buildFlags = append(buildFlags, args[i])
		}

		i++
	}

	cpuprofile = os.Getenv("CODEQL_EXTRACTOR_GO_CPU_PROFILE")
	memprofile = os.Getenv("CODEQL_EXTRACTOR_GO_MEM_PROFILE")

	return buildFlags, args[i:]
}

func main() {
	buildFlags, patterns := parseFlags(os.Args[1:])

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
		log.Println("Nothing to extract.")
	} else {
		err := extractor.ExtractWithFlags(buildFlags, patterns)
		if err != nil {
			log.Fatal(err)
		}
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

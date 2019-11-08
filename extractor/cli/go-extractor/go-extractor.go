package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/Semmle/go/extractor/dbscheme"

	"github.com/Semmle/go/extractor"
)

func usage() {
	fmt.Fprintf(os.Stderr, "%s is a program for building a snapshot of a Go code base.\n\n", os.Args[0])
	fmt.Fprintf(os.Stderr, "Usage:\n\n  %s [<flag>...] [<buildflag>...] [--] <file>...\n\n", os.Args[0])
	fmt.Fprintf(os.Stderr, "Flags:\n\n")
	fmt.Fprintf(os.Stderr, "--help                Print this help.\n")
	fmt.Fprintf(os.Stderr, "--dbscheme string     Write dbscheme to this file.\n")
}

func parseFlags(args []string) ([]string, []string, string) {
	i := 0
	var dumpDbscheme string
	buildFlags := []string{}
	for i < len(args) && strings.HasPrefix(args[i], "-") {
		if args[i] == "--" {
			i += 1
			break
		}

		if strings.HasPrefix(args[i], "--dbscheme=") {
			dumpDbscheme = strings.TrimPrefix(args[i], "--dbscheme=")
		} else if args[i] == "--dbscheme" {
			i += 1
			dumpDbscheme = args[i]
		} else if args[i] == "--help" {
			usage()
			os.Exit(0)
		} else {
			buildFlags = append(buildFlags, args[i])
		}

		i += 1
	}

	return buildFlags, args[i:], dumpDbscheme
}

func main() {
	buildFlags, patterns, dumpDbscheme := parseFlags(os.Args[1:])

	if dumpDbscheme != "" {
		f, err := os.Create(dumpDbscheme)
		if err != nil {
			log.Fatalf("Unable to open file %s for writing.", dumpDbscheme)
		}
		dbscheme.PrintDbScheme(f)
		f.Close()
		log.Printf("Dbscheme written to file %s.", dumpDbscheme)
	}

	if len(patterns) == 0 {
		log.Println("Nothing to extract.")
	} else {
		err := extractor.ExtractWithFlags(buildFlags, patterns)
		if err != nil {
			log.Fatal(err)
		}
	}
}

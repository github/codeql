package main

import (
	"fmt"
	"os"

	"github.com/github/codeql-go/extractor/dbscheme"
)

func usage() {
	fmt.Fprintf(os.Stderr, "%s is a program for generating the dbscheme for CodeQL Go databases.\n\n", os.Args[0])
	fmt.Fprintf(os.Stderr, "Usage:\n\n  %s <output file>\n\n", os.Args[0])
}

func main() {
	if len(os.Args) != 2 {
		usage()
		os.Exit(2)
	}

	out := os.Args[1]

	f, err := os.Create(out)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to open file %s for writing.\n", out)
		os.Exit(1)
	}
	dbscheme.PrintDbScheme(f)
	f.Close()
	fmt.Printf("Dbscheme written to file %s.\n", out)
}

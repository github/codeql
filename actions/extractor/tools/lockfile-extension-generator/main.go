package main

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/github/actions-lockfile/go/pkg/lockfile"
)

// main reads a repository's Actions lockfile and writes the corresponding
// `pinnedByLockfileDataModel` data extension.
//
// Usage:
//
//	lockfile-extension-generator <source-root> [output-file]
//
// `<source-root>` is the root of the repository to scan; the lockfile is read
// from `<source-root>/.github/workflows/actions.lock`. When `[output-file]` is
// omitted the extension is written to stdout. If the repository has no lockfile
// the generator exits successfully without writing anything, so it is safe to
// run unconditionally.
func main() {
	if len(os.Args) < 2 || len(os.Args) > 3 {
		fmt.Fprintf(os.Stderr, "usage: %s <source-root> [output-file]\n", filepath.Base(os.Args[0]))
		os.Exit(2)
	}
	sourceRoot := os.Args[1]

	lockPath := filepath.Join(sourceRoot, filepath.FromSlash(lockfile.Path))
	contents, err := os.ReadFile(lockPath)
	if err != nil {
		if os.IsNotExist(err) {
			// No lockfile: nothing to pin. A clean no-op keeps this safe to run
			// against every repository.
			return
		}
		fmt.Fprintf(os.Stderr, "error: reading %s: %v\n", lockPath, err)
		os.Exit(1)
	}

	rows, err := rowsFromLockfile(contents)
	if err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}

	out := renderExtension(rows)
	if len(os.Args) == 3 {
		if err := os.WriteFile(os.Args[2], []byte(out), 0o644); err != nil {
			fmt.Fprintf(os.Stderr, "error: writing %s: %v\n", os.Args[2], err)
			os.Exit(1)
		}
		return
	}
	fmt.Print(out)
}

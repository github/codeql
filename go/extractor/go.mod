module github.com/github/codeql-go/extractor

go 1.24

toolchain go1.24.0

// when updating this, run
//    bazel run @rules_go//go -- mod tidy
// when adding or removing dependencies, run
//    bazel mod tidy
require (
	golang.org/x/mod v0.24.0
	golang.org/x/tools v0.31.0
)

require golang.org/x/sync v0.12.0 // indirect

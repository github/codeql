module github.com/github/codeql-go/extractor

go 1.23

toolchain go1.23.1

// when updating this, run
//    bazel run @rules_go//go -- mod tidy
// when adding or removing dependencies, run
//    bazel mod tidy
require (
	golang.org/x/mod v0.21.0
	golang.org/x/tools v0.25.0
)

require golang.org/x/sync v0.8.0 // indirect

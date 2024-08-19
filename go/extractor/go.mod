module github.com/github/codeql-go/extractor

go 1.22.0

// when updating this, run
//    bazel run @rules_go//go -- mod tidy
// when adding or removing dependencies, run
//    bazel mod tidy
require (
	golang.org/x/mod v0.20.0
	golang.org/x/tools v0.24.0
)

require golang.org/x/sync v0.8.0 // indirect

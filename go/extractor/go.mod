module github.com/github/codeql-go/extractor

go 1.22.0

// when updating this, run
//    bazel run @rules_go//go -- mod tidy
// when adding or removing dependencies, run
//    bazel mod tidy
require (
	golang.org/x/mod v0.16.0
	golang.org/x/tools v0.18.0
)

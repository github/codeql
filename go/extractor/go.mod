module github.com/github/codeql-go/extractor

go 1.27

toolchain go1.27.0

// when updating this, run
//    bazel run @rules_go//go -- mod tidy
// when adding or removing dependencies, run
//    bazel mod tidy
require (
	github.com/stretchr/testify v1.11.1
	golang.org/x/mod v0.40.0
	golang.org/x/sys v0.47.0
	golang.org/x/tools v0.49.0
)

require (
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	golang.org/x/sync v0.22.0 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)

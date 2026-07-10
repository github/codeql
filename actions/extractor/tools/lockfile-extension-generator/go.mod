module github.com/github/codeql/actions/extractor/tools/lockfile-extension-generator

go 1.23

require github.com/github/actions-lockfile/go v0.0.0-00010101000000-000000000000

require gopkg.in/yaml.v3 v3.0.1 // indirect

// LOCAL TESTING ONLY: github.com/github/actions-lockfile is not yet public, so it
// cannot be fetched by the module proxy. Point this at a local clone of the
// repository to build and test the generator:
//
//   go mod edit -replace github.com/github/actions-lockfile/go=/path/to/actions-lockfile/go
//
// Remove this replace directive once actions-lockfile is published.

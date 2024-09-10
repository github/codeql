## 1.1.5

### Bug Fixes

* Fixed an issue where `io/ioutil.WriteFile`'s non-path arguments incorrectly generated `go/path-injection` alerts when untrusted data was written to a file, or controlled the file's mode.

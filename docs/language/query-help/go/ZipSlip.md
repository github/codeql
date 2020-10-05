# Arbitrary file write during zip extraction ("zip slip")

```
ID: go/zipslip
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-022

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql-go/tree/main/ql/src/Security/CWE-022/ZipSlip.ql)

Extracting files from a malicious zip archive without validating that the destination file path is within the destination directory can cause files outside the destination directory to be overwritten, due to the possible presence of directory traversal elements (`..`) in archive paths.

Zip archives contain archive entries representing each file in the archive. These entries include a file path for the entry, but these file paths are not restricted and may contain unexpected special elements such as the directory traversal element (`..`). If these file paths are used to determine which output file the contents of an archive item should be written to, then the file may be written to an unexpected location. This can result in sensitive information being revealed or deleted, or an attacker being able to influence behavior by modifying unexpected files.

For example, if a zip file contains a file entry `..\sneaky-file`, and the zip file is extracted to the directory `c:\output`, then naively combining the paths would result in an output file path of `c:\output\..\sneaky-file`, which would cause the file to be written to `c:\sneaky-file`.


## Recommendation
Ensure that output paths constructed from zip archive entries are validated to prevent writing files to unexpected locations.

The recommended way of writing an output file from a zip archive entry is to check that "`..`" does not occur in the path.


## Example
In this example an archive is extracted without validating file paths. If `archive.zip` contained relative paths (for instance, if it were created by something like `zip archive.zip ../file.txt`) then executing this code could write to locations outside the destination directory.


```go
package main

import (
	"archive/zip"
	"io/ioutil"
	"path/filepath"
)

func unzip(f string) {
	r, _ := zip.OpenReader(f)
	for _, f := range r.File {
		p, _ := filepath.Abs(f.Name)
		// BAD: This could overwrite any file on the file system
		ioutil.WriteFile(p, []byte("present"), 0666)
	}
}

```
To fix this vulnerability, we need to check that the path does not contain any "`..`" elements in it.


```go
package main

import (
	"archive/zip"
	"io/ioutil"
	"path/filepath"
	"strings"
)

func unzipGood(f string) {
	r, _ := zip.OpenReader(f)
	for _, f := range r.File {
		p, _ := filepath.Abs(f.Name)
		// GOOD: Check that path does not contain ".." before using it
		if !strings.Contains(p, "..") {
			ioutil.WriteFile(p, []byte("present"), 0666)
		}
	}
}

```

## References
* Snyk: [Zip Slip Vulnerability](https://snyk.io/research/zip-slip-vulnerability).
* OWASP: [Path Traversal](https://www.owasp.org/index.php/Path_traversal).
* Common Weakness Enumeration: [CWE-22](https://cwe.mitre.org/data/definitions/22.html).
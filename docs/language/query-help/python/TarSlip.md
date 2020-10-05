# Arbitrary file write during tarfile extraction

```
ID: py/tarslip
Kind: path-problem
Severity: error
Precision: medium
Tags: security external/cwe/cwe-022

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-022/TarSlip.ql)

Extracting files from a malicious tar archive without validating that the destination file path is within the destination directory can cause files outside the destination directory to be overwritten, due to the possible presence of directory traversal elements (`..`) in archive paths.

Tar archives contain archive entries representing each file in the archive. These entries include a file path for the entry, but these file paths are not restricted and may contain unexpected special elements such as the directory traversal element (`..`). If these file paths are used to determine an output file to write the contents of the archive item to, then the file may be written to an unexpected location. This can result in sensitive information being revealed or deleted, or an attacker being able to influence behavior by modifying unexpected files.

For example, if a tar archive contains a file entry `..\sneaky-file`, and the tar archive is extracted to the directory `c:\output`, then naively combining the paths would result in an output file path of `c:\output\..\sneaky-file`, which would cause the file to be written to `c:\sneaky-file`.


## Recommendation
Ensure that output paths constructed from tar archive entries are validated to prevent writing files to unexpected locations.

The recommended way of writing an output file from a tar archive entry is to check that `".."` does not occur in the path.


## Example
In this example an archive is extracted without validating file paths. If `archive.tar` contained relative paths (for instance, if it were created by something like `tar -cf archive.tar ../file.txt`) then executing this code could write to locations outside the destination directory.


```python

import tarfile

with tarfile.open('archive.zip') as tar:
    #BAD : This could write any file on the filesystem.
    for entry in tar:
        tar.extract(entry, "/tmp/unpack/")

```
To fix this vulnerability, we need to check that the path does not contain any `".."` elements in it.


```python

import tarfile
import os.path

with tarfile.open('archive.zip') as tar:
    for entry in tar:
        #GOOD: Check that entry is safe
        if os.path.isabs(entry.name) or ".." in entry.name:
            raise ValueError("Illegal tar archive entry")
        tar.extract(entry, "/tmp/unpack/")

```

## References
* Snyk: [Zip Slip Vulnerability](https://snyk.io/research/zip-slip-vulnerability).
* OWASP: [Path Traversal](https://www.owasp.org/index.php/Path_traversal).
* Python Library Reference: [TarFile.extract](https://docs.python.org/3/library/tarfile.html#tarfile.TarFile.extract).
* Python Library Reference: [TarFile.extractall](https://docs.python.org/3/library/tarfile.html#tarfile.TarFile.extractall).
* Common Weakness Enumeration: [CWE-22](https://cwe.mitre.org/data/definitions/22.html).
# Insecure temporary file

```
ID: py/insecure-temporary-file
Kind: problem
Severity: error
Precision: high
Tags: external/cwe/cwe-377 security

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-377/InsecureTemporaryFile.ql)

Functions that create temporary file names (such as `tempfile.mktemp` and `os.tempnam`) are fundamentally insecure, as they do not ensure exclusive access to a file with the temporary name they return. The file name returned by these functions is guaranteed to be unique on creation but the file must be opened in a separate operation. There is no guarantee that the creation and open operations will happen atomically. This provides an opportunity for an attacker to interfere with the file before it is opened.

Note that `mktemp` has been deprecated since Python 2.3.


## Recommendation
Replace the use of `mktemp` with some of the more secure functions in the `tempfile` module, such as `TemporaryFile`. If the file is intended to be accessed from other processes, consider using the `NamedTemporaryFile` function.


## Example
The following piece of code opens a temporary file and writes a set of results to it. Because the file name is created using `mktemp`, another process may access this file before it is opened using `open`.


```python
from tempfile import mktemp

def write_results(results):
    filename = mktemp()
    with open(filename, "w+") as f:
        f.write(results)
    print("Results written to", filename)

```
By changing the code to use `NamedTemporaryFile` instead, the file is opened immediately.


```python
from tempfile import NamedTemporaryFile

def write_results(results):
    with NamedTemporaryFile(mode="w+", delete=False) as f:
        f.write(results)
    print("Results written to", f.name)

```

## References
* Python Standard Library: [tempfile.mktemp](https://docs.python.org/3/library/tempfile.html#tempfile.mktemp).
* Common Weakness Enumeration: [CWE-377](https://cwe.mitre.org/data/definitions/377.html).
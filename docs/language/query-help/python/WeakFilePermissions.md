# Overly permissive file permissions

```
ID: py/overly-permissive-file
Kind: problem
Severity: warning
Precision: medium
Tags: external/cwe/cwe-732 security

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-732/WeakFilePermissions.ql)

When creating a file, POSIX systems allow permissions to be specified for owner, group and others separately. Permissions should be kept as strict as possible, preventing access to the files contents by other users.


## Recommendation
Restrict the file permissions of files to prevent any but the owner being able to read or write to that file


## References
* Wikipedia: [File system permissions](https://en.wikipedia.org/wiki/File_system_permissions).
* Common Weakness Enumeration: [CWE-732](https://cwe.mitre.org/data/definitions/732.html).
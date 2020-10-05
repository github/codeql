# File created without restricting permissions

```
ID: cpp/world-writable-file-creation
Kind: problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-732

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-732/DoNotCreateWorldWritable.ql)

When you create a file, take care to give it the most restrictive permissions possible. A typical mistake is to create the file with world-writable permissions. This can allow an attacker to write to the file, which can give them unexpected control over the program.


## Recommendation
Files should usually be created with write permissions only for the current user. If broader permissions are needed, including the users' group should be sufficient. It is very rare that a file needs to be world-writable, and care should be taken not to make assumptions about the contents of any such file.

On Unix systems, it is possible for the user who runs the program to restrict file creation permissions using `umask`. However, a program should not assume that the user will set an `umask`, and should still set restrictive permissions by default.


## Example
This example shows two ways of writing a default configuration file. Software often does this to provide the user with a convenient starting point for defining their own configuration. However, configuration files can also control important aspects of the software's behavior, so it is important that they cannot be controlled by an attacker.

The first example creates the default configuration file with the usual "default" Unix permissions, `0666`. This makes the file world-writable, so that an attacker could write in their own configuration that would be read by the program. The second example uses more restrictive permissions: a combination of the standard Unix constants `S_IWUSR` and `S_IRUSR` which means that only the current user will have read and write access to the file.


```c
int write_default_config_bad() {
	// BAD - this is world-writable so any user can overwrite the config
	FILE* out = creat(OUTFILE, 0666);
	fprintf(out, DEFAULT_CONFIG);
}

int write_default_config_good() {
	// GOOD - this allows only the current user to modify the file
	FILE* out = creat(OUTFILE, S_IWUSR | S_IRUSR);
	fprintf(out, DEFAULT_CONFIG);
}

```

## References
* The CERT Oracle Secure Coding Standard for C: [ FIO06-C. Create files with appropriate access permissions ](https://www.securecoding.cert.org/confluence/display/c/FIO06-C.+Create+files+with+appropriate+access+permissions).
* Common Weakness Enumeration: [CWE-732](https://cwe.mitre.org/data/definitions/732.html).
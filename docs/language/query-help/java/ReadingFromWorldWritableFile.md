# Reading from a world writable file

```
ID: java/world-writable-file-read
Kind: problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-732

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-732/ReadingFromWorldWritableFile.ql)

Reading from a world-writable file is dangerous on a multi-user system because other users may be able to affect program execution by modifying or deleting the file.


## Recommendation
Do not make files explicitly world writable unless the file is intended to be written by multiple users on a multi-user system. In many cases, the file may only need to be writable for the current user.

For some file systems, there may be alternatives to setting the file to be world writable. For example, POSIX file systems support "groups" which may be used to ensure that only subset of all the users can write to the file. Access Control Lists (ACLs) are available for many operating system and file system combinations, and can provide fine-grained read and write support without resorting to world writable permissions.


## Example
In the following example, we are loading some configuration parameters from a file:

```java

private void readConfig(File configFile) {
  if (!configFile.exists()) {
    // Create an empty config file
    configFile.createNewFile();
    // Make the file writable for all
    configFile.setWritable(true, false);
  }
  // Now read the config
  loadConfig(configFile);
}

```
If the configuration file does not yet exist, an empty file is created. Creating an empty file can simplify the later code and is a convenience for the user. However, by setting the file to be world writable, we allow any user on the system to modify the configuration, not just the current user. If there may be untrusted users on the system, this is potentially dangerous.


## References
* The CERT Oracle Secure Coding Standard for Java: [FIO01-J. Create files with appropriate access permissions](https://www.securecoding.cert.org/confluence/display/java/FIO01-J.+Create+files+with+appropriate+access+permissions).
* Common Weakness Enumeration: [CWE-732](https://cwe.mitre.org/data/definitions/732.html).
# Executing a command with a relative path

```
ID: java/relative-path-command
Kind: problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-078 external/cwe/cwe-088

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-078/ExecRelative.ql)

When a command is executed with a relative path, the runtime uses the PATH environment variable to find which executable to run. Therefore, any user who can change the PATH environment variable can cause the software to run a different, malicious executable.


## Recommendation
In most cases, simply use a command that has an absolute path instead of a relative path.

In some cases, the location of the executable might be different on different installations. In such cases, consider specifying the location of key executables with some form of configuration. When using this approach, be careful that the configuration system is not itself vulnerable to malicious modifications.


## Example

```java
class Test {
    public static void main(String[] args) {
        // BAD: relative path
        Runtime.getRuntime().exec("make");
        
        // GOOD: absolute path
        Runtime.getRuntime().exec("/usr/bin/make");

        // GOOD: build an absolute path from known values
        Runtime.getRuntime().exec(Paths.MAKE_PREFIX + "/bin/make");
    }
}
```

## References
* Common Weakness Enumeration: [CWE-78](https://cwe.mitre.org/data/definitions/78.html).
* Common Weakness Enumeration: [CWE-88](https://cwe.mitre.org/data/definitions/88.html).
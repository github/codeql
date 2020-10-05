# Uncontrolled data used in path expression

```
ID: cpp/path-injection
Kind: path-problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-022 external/cwe/cwe-023 external/cwe/cwe-036 external/cwe/cwe-073

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-022/TaintedPath.ql)

Accessing paths controlled by users can allow an attacker to access unexpected resources. This can result in sensitive information being revealed or deleted, or an attacker being able to influence behavior by modifying unexpected files.

Paths that are naively constructed from data controlled by a user may contain unexpected special characters, such as "..". Such a path may potentially point to any directory on the filesystem.


## Recommendation
Validate user input before using it to construct a filepath. Ideally, follow these rules:

* Do not allow more than a single "." character.
* Do not allow directory separators such as "/" or "\" (depending on the filesystem).
* Do not rely on simply replacing problematic sequences such as "../". For example, after applying this filter to ".../...//" the resulting string would still be "../".
* Ideally use a whitelist of known good patterns.

## Example
In this example, a username and file are read from the arguments to main and then used to access a file in the user's home directory. However, a malicious user could enter a filename which contains special characters. For example, the string "../../etc/passwd" will result in the code reading the file located at "/home/[user]/../../etc/passwd", which is the system's password file. This could potentially allow them to access all the system's passwords.


```c
int main(int argc, char** argv) {
  char *userAndFile = argv[2];
  
  {
    char fileBuffer[FILENAME_MAX] = "/home/";
    char *fileName = fileBuffer;
    size_t len = strlen(fileName);
    strncat(fileName+len, userAndFile, FILENAME_MAX-len-1);
    // BAD: a string from the user is used in a filename
    fopen(fileName, "wb+");
  }

  {
    char fileBuffer[FILENAME_MAX] = "/home/";
    char *fileName = fileBuffer;
    size_t len = strlen(fileName);
    // GOOD: use a fixed file
    char* fixed = "jim/file.txt";
    strncat(fileName+len, fixed, FILENAME_MAX-len-1);
    fopen(fileName, "wb+");
  }
}

```

## References
* OWASP: [Path Traversal](https://www.owasp.org/index.php/Path_traversal).
* Common Weakness Enumeration: [CWE-22](https://cwe.mitre.org/data/definitions/22.html).
* Common Weakness Enumeration: [CWE-23](https://cwe.mitre.org/data/definitions/23.html).
* Common Weakness Enumeration: [CWE-36](https://cwe.mitre.org/data/definitions/36.html).
* Common Weakness Enumeration: [CWE-73](https://cwe.mitre.org/data/definitions/73.html).
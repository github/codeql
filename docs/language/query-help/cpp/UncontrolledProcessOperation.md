# Uncontrolled process operation

```
ID: cpp/uncontrolled-process-operation
Kind: path-problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-114

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-114/UncontrolledProcessOperation.ql)

The code passes user input directly to `system`, `dlopen`, `LoadLibrary` or some other process or library routine. As a result, the user can cause execution of arbitrary code.


## Recommendation
If possible, use hard-coded string literals for the command to run or library to load. Instead of passing the user input directly to the process or library function, examine the user input and then choose among hard-coded string literals.

If the applicable libraries or commands cannot be determined at compile time, then add code to verify that the user-input string is safe before using it.


## Example

```c
int main(int argc, char** argv) {
  char *lib = argv[2];
  
  // BAD: the user can cause arbitrary code to be loaded
  void* handle = dlopen(lib, RTLD_LAZY);
  
  // GOOD: only hard-coded libraries can be loaded
  void* handle2;

  if (!strcmp(lib, "inmem")) {
    handle2 = dlopen("/usr/share/dbwrap/inmem", RTLD_LAZY);
  } else if (!strcmp(lib, "mysql")) {
    handle2 = dlopen("/usr/share/dbwrap/mysql", RTLD_LAZY);
  } else {
    die("Invalid library specified\n");
  }
}

```

## References
* Common Weakness Enumeration: [CWE-114](https://cwe.mitre.org/data/definitions/114.html).
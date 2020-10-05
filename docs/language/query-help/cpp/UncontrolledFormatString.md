# Uncontrolled format string

```
ID: cpp/tainted-format-string
Kind: path-problem
Severity: warning
Precision: high
Tags: reliability security external/cwe/cwe-134

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-134/UncontrolledFormatString.ql)

The program uses input from the user as a format string for `printf` style functions. This can lead to buffer overflows or data representation problems. An attacker can exploit this weakness to crash the program, disclose information or even execute arbitrary code.

The results of this rule do not include inputs from the user that are transferred through global variables. Those can be found in the related rule "Uncontrolled format string (through global variable)".


## Recommendation
Use constant expressions as the format strings. If you need to print a value from the user, use `printf("%s", value_from_user)`.


## Example

```c
#include <stdio.h>

void printWrapper(char *str) {
	printf(str);
}

int main(int argc, char **argv) {
	// This should be avoided
	printf(argv[1]);

	// This should be avoided too, because it has the same effect
	printWrapper(argv[1]);

	// This is fine
	printf("%s", argv[1]);
}
```

## References
* CERT C Coding Standard: [FIO30-C. Exclude user input from format strings](https://www.securecoding.cert.org/confluence/display/c/FIO30-C.+Exclude+user+input+from+format+strings).
* Common Weakness Enumeration: [CWE-134](https://cwe.mitre.org/data/definitions/134.html).
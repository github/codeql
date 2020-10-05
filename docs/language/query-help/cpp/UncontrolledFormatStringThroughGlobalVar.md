# Uncontrolled format string (through global variable)

```
ID: cpp/tainted-format-string-through-global
Kind: path-problem
Severity: warning
Precision: high
Tags: reliability security external/cwe/cwe-134

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-134/UncontrolledFormatStringThroughGlobalVar.ql)

The program uses input from the user, propagated via a global variable, as a format string for `printf` style functions. This can lead to buffer overflows or data representation problems. An attacker can exploit this weakness to crash the program, disclose information or even execute arbitrary code.

This rule only identifies inputs from the user that are transferred through global variables before being used in `printf` style functions. Analyzing the flow of data through global variables is more prone to errors and so this rule may identify some examples of code where the input is not really from the user. For example, when a global variable is set in two places, one that comes from the user and one that does not. In this case we would mark all usages of the global variable as input from the user, but the input from the user may always came after the call to the `printf` style functions.

The results of this rule should be considered alongside the related rule "Uncontrolled format string" which tracks the flow of the values input by a user, excluding global variables, until the values are used as the format argument for a `printf` like function call.


## Recommendation
Use constant expressions as the format strings. If you need to print a value from the user, use `printf("%s", value_from_user)`.


## Example

```c
#include <stdio.h>

char *copy;

void copyArgv(char **argv) {
	copy = argv[1];
}

void printWrapper(char *str) {
	printf(str);
}

int main(int argc, char **argv) {
	copyArgv(argv);

	// This should be avoided
	printf(copy);

	// This should be avoided too, because it has the same effect
	printWrapper(copy);

	// This is fine
	printf("%s", copy);
}

```

## References
* CERT C Coding Standard: [FIO30-C. Exclude user input from format strings](https://www.securecoding.cert.org/confluence/display/c/FIO30-C.+Exclude+user+input+from+format+strings).
* Common Weakness Enumeration: [CWE-134](https://cwe.mitre.org/data/definitions/134.html).
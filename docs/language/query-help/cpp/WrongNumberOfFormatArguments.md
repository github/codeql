# Too few arguments to formatting function

```
ID: cpp/wrong-number-format-arguments
Kind: problem
Severity: error
Precision: high
Tags: reliability correctness security external/cwe/cwe-685

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Likely%20Bugs/Format/WrongNumberOfFormatArguments.ql)

Each call to the `printf` function, or a related function, should include the number of arguments defined by the format. Passing the function more arguments than required is harmless (although it may be indicative of other defects). However, passing the function fewer arguments than are defined by the format can be a security vulnerability since the function will process the next item on the stack as the missing arguments.

This might lead to an information leak if a sensitive value from the stack is printed. It might cause a crash if a value on the stack is interpreted as a pointer and leads to accessing unmapped memory. Finally, it may lead to a follow-on vulnerability if an attacker can use this problem to cause the output string to be too long or have unexpected contents.


## Recommendation
Review the format and arguments expected by the highlighted function calls. Update either the format or the arguments so that the expected number of arguments are passed to the function.


## Example

```cpp
int main() {
  printf("%d, %s\n", 42); // Will crash or print garbage
  return 0;
}

```

## References
* CERT C Coding Standard: [FIO30-C. Exclude user input from format strings](https://www.securecoding.cert.org/confluence/display/c/FIO30-C.+Exclude+user+input+from+format+strings).
* cplusplus.com: [C++ Functions](http://www.tutorialspoint.com/cplusplus/cpp_functions.htm).
* Microsoft C Runtime Library Reference: [printf, wprintf](https://docs.microsoft.com/en-us/cpp/c-runtime-library/reference/printf-printf-l-wprintf-wprintf-l).
* Common Weakness Enumeration: [CWE-685](https://cwe.mitre.org/data/definitions/685.html).
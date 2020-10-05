# Non-constant format string

```
ID: cpp/non-constant-format
Kind: problem
Severity: recommendation
Precision: high
Tags: maintainability correctness security external/cwe/cwe-134

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Likely%20Bugs/Format/NonConstantFormat.ql)

The `printf` function, related functions like `sprintf` and `fprintf`, and other functions built atop `vprintf` all accept a format string as one of their arguments. When such format strings are literal constants, it is easy for the programmer (and static analysis tools) to verify that the format specifiers (such as `%s` and `%02x`) in the format string are compatible with the trailing arguments of the function call. When such format strings are not literal constants, it is more difficult to maintain the program: programmers (and static analysis tools) must perform non-local data-flow analysis to deduce what values the format string argument might take.


## Recommendation
If the argument passed as a format string is meant to be a plain string rather than a format string, then pass `%s` as the format string, and pass the original argument as the sole trailing argument.

If the argument passed as a format string is a parameter to the enclosing function, then consider redesigning the enclosing function's API to be less brittle.


## Example
The following program is meant to echo its command line arguments:


```c
#include <stdio.h>
int main(int argc, char** argv) {
  for(int i = 1; i < argc; ++i) {
    printf(argv[i]);
  }
}
```
The above program behaves as expected in most cases, but breaks when one of its command line arguments contains a percent character. In such cases, the behavior of the program is undefined: it might echo garbage, it might crash, or it might give a malicious attacker root access. One way of addressing the problem is to use a constant `%s` format string, as in the following program:


```c
#include <stdio.h>
int main(int argc, char** argv) {
  for(int i = 1; i < argc; ++i) {
    printf("%s", argv[i]);
  }
}
```

## Example
The following program defines a `log_with_timestamp` function:


```c
void log_with_timestamp(const char* message) {
  struct tm now;
  time(&now);
  printf("[%s] ", asctime(now));
  printf(message);
}

int main(int argc, char** argv) {
  log_with_timestamp("Application is starting...\n");
  /* ... */
  log_with_timestamp("Application is closing...\n");
  return 0;
}
```
In the code that is visible, the reader can verify that `log_with_timestamp` is never called with a log message containing a percent character, but even if all current calls are correct, this presents an ongoing maintenance burden to ensure that newly-introduced calls don't contain percent characters. As in the previous example, one solution is to make the log message a trailing argument of the function call:


```c
void log_with_timestamp(const char* message) {
  struct tm now;
  time(&now);
  printf("[%s] %s", asctime(now), message);
}

int main(int argc, char** argv) {
  log_with_timestamp("Application is starting...\n");
  /* ... */
  log_with_timestamp("Application is closing...\n");
  return 0;
}
```
An alternative solution is to allow `log_with_timestamp` to accept format arguments:


```c
void log_with_timestamp(const char* message, ...) {
  va_list args;
  va_start(args, message);
  struct tm now;
  time(&now);
  printf("[%s] ", asctime(now));
  vprintf(message, args);
  va_end(args);
}

int main(int argc, char** argv) {
  log_with_timestamp("%s is starting...\n", argv[0]);
  /* ... */
  log_with_timestamp("%s is closing...\n", argv[0]);
  return 0;
}
```
In this formulation, the non-constant format string to `printf` has been replaced with a non-constant format string to `vprintf`. Semmle will no longer consider the body of `log_with_timestamp` to be a problem, and will instead check that every call to `log_with_timestamp` passes a constant format string.


## References
* CERT C Coding Standard: [FIO30-C. Exclude user input from format strings](https://www.securecoding.cert.org/confluence/display/c/FIO30-C.+Exclude+user+input+from+format+strings).
* M. Howard, D. Leblanc, J. Viega, *19 Deadly Sins of Software Security: Programming Flaws and How to Fix Them*.
* Common Weakness Enumeration: [CWE-134](https://cwe.mitre.org/data/definitions/134.html).
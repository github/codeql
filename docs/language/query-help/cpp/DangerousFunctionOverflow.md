# Use of dangerous function

```
ID: cpp/dangerous-function-overflow
Kind: problem
Severity: error
Precision: very-high
Tags: reliability security external/cwe/cwe-242

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-676/DangerousFunctionOverflow.ql)

This rule finds calls to the `gets` function, which is dangerous and should not be used. See **Related rules** below for rules that identify other dangerous functions.

The `gets` function is one of the vulnerabilities exploited by the Internet Worm of 1988, one of the first computer worms to spread through the Internet. The `gets` function provides no way to limit the amount of data that is read and stored, so without prior knowledge of the input it is impossible to use it safely with any size of buffer.


## Recommendation
Replace calls to `gets` with `fgets`, specifying the maximum length to copy. This will prevent the buffer overflow.


## Example
The following example gets a string from standard input in two ways:


```c
#define BUFFERSIZE (1024)

// BAD: using gets
void echo_bad() {
    char buffer[BUFFERSIZE];
    gets(buffer);
    printf("Input was: '%s'\n", buffer);
}

// GOOD: using fgets
void echo_good() {
    char buffer[BUFFERSIZE];
    fgets(buffer, BUFFERSIZE, stdin);
    printf("Input was: '%s'\n", buffer);
}

```
The first version uses `gets` and will overflow if the input is longer than the buffer. The second version of the code uses `fgets` and will not overflow, because the amount of data written is limited by the length parameter.


## Related rules
Other dangerous functions identified by CWE-676 ("Use of Potentially Dangerous Function") include `strcpy` and `strcat`. Use of these functions is highlighted by rules for the following CWEs:

* [CWE-120 Classic Buffer Overflow](https://cwe.mitre.org/data/definitions/120.html).
* [CWE-131 Incorrect Calculation of Buffer Size](https://cwe.mitre.org/data/definitions/131.html).

## References
* Wikipedia: [Morris worm](http://en.wikipedia.org/wiki/Morris_worm).
* E. Spafford. *The Internet Worm Program: An Analysis*. Purdue Technical Report CSD-TR-823, [(online)](http://www.textfiles.com/100/tr823.txt), 1988.
* Common Weakness Enumeration: [CWE-242](https://cwe.mitre.org/data/definitions/242.html).
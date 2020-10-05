# Possibly wrong buffer size in string copy

```
ID: cpp/bad-strncpy-size
Kind: problem
Severity: warning
Precision: medium
Tags: reliability correctness security external/cwe/cwe-676 external/cwe/cwe-119 external/cwe/cwe-251

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Likely%20Bugs/Memory%20Management/StrncpyFlippedArgs.ql)

The standard library function `strncpy` copies a source string to a destination buffer. The third argument defines the maximum number of characters to copy and should be less than or equal to the size of the destination buffer. Calls of the form `strncpy(dest, src, strlen(src))` or `strncpy(dest, src, sizeof(src))` incorrectly set the third argument to the size of the source buffer. Executing a call of this type may cause a buffer overflow. Buffer overflows can lead to anything from a segmentation fault to a security vulnerability.


## Recommendation
Check the highlighted function calls carefully, and ensure that the size parameter is derived from the size of the destination buffer, not the source buffer.


## Example

```cpp
strncpy(dest, src, sizeof(src)); //wrong: size of dest should be used
strncpy(dest, src, strlen(src)); //wrong: size of dest should be used

```

## References
* cplusplus.com: [strncpy](http://www.cplusplus.com/reference/clibrary/cstring/strncpy/).
* I. Gerg. *An Overview and Example of the Buffer-Overflow Exploit*. IANewsletter vol 7 no 4. 2005.
* M. Donaldson. *Inside the Buffer Overflow Attack: Mechanism, Method & Prevention*. SANS Institute InfoSec Reading Room. 2002.
* Common Weakness Enumeration: [CWE-676](https://cwe.mitre.org/data/definitions/676.html).
* Common Weakness Enumeration: [CWE-119](https://cwe.mitre.org/data/definitions/119.html).
* Common Weakness Enumeration: [CWE-251](https://cwe.mitre.org/data/definitions/251.html).
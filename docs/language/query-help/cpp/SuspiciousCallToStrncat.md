# Potentially unsafe call to strncat

```
ID: cpp/unsafe-strncat
Kind: problem
Severity: warning
Precision: medium
Tags: reliability correctness security external/cwe/cwe-676 external/cwe/cwe-119 external/cwe/cwe-251

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Likely%20Bugs/Memory%20Management/SuspiciousCallToStrncat.ql)

The standard library function `strncat` appends a source string to a target string. The third argument defines the maximum number of characters to append and should be less than or equal to the remaining space in the destination buffer. Calls of the form `strncat(dest, src, strlen(dest))` or `strncat(dest, src, sizeof(dest))` set the third argument to the entire size of the destination buffer. Executing a call of this type may cause a buffer overflow unless the buffer is known to be empty. Buffer overflows can lead to anything from a segmentation fault to a security vulnerability.


## Recommendation
Check the highlighted function calls carefully to ensure that no buffer overflow is possible. For a more robust solution, consider updating the function call to include the remaining space in the destination buffer.


## Example

```cpp
strncat(dest, src, strlen(dest)); //wrong: should use remaining size of dest

strncat(dest, src, sizeof(dest)); //wrong: should use remaining size of dest. 
                                  //Also fails if dest is a pointer and not an array.

```

## References
* cplusplus.com: [strncat](http://www.cplusplus.com/reference/clibrary/cstring/strncat/), [strncpy](http://www.cplusplus.com/reference/clibrary/cstring/strncpy/).
* I. Gerg, *An Overview and Example of the Buffer-Overflow Exploit*. IANewsletter vol 7 no 4, 2005.
* M. Donaldson, *Inside the Buffer Overflow Attack: Mechanism, Method & Prevention*. SANS Institute InfoSec Reading Room, 2002.
* Common Weakness Enumeration: [CWE-676](https://cwe.mitre.org/data/definitions/676.html).
* Common Weakness Enumeration: [CWE-119](https://cwe.mitre.org/data/definitions/119.html).
* Common Weakness Enumeration: [CWE-251](https://cwe.mitre.org/data/definitions/251.html).
# Badly bounded write

```
ID: cpp/badly-bounded-write
Kind: problem
Severity: error
Precision: high
Tags: reliability security external/cwe/cwe-120 external/cwe/cwe-787 external/cwe/cwe-805

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-120/BadlyBoundedWrite.ql)

The program performs a buffer copy or write operation with an incorrect upper limit on the size of the copy. A sufficiently long input will overflow the target buffer. In addition to causing program instability, techniques exist which may allow an attacker to use this vulnerability to execute arbitrary code.


## Recommendation
Use preprocessor defines to specify the size of buffers, and use the same defines as arguments to `strncpy`, `snprintf` etc. This technique will ensure that buffer sizes are always specified correctly so that no overflow occurs.


## Example

```c
void congratulateUser(const char *userName)
{
	char buffer[80];

	// BAD: even though snprintf is used, this could overflow the buffer
	// because the size specified is too large.
	snprintf(buffer, 256, "Congratulations, %s!", userName);

	MessageBox(hWnd, buffer, "New Message", MB_OK);
}
```
In this example, the developer has used `snprintf` to control the maximum number of characters that can be written to `buffer`. Unfortunately, perhaps due to modifications since the code was first written, a limited buffer overrun can still occur because the size argument to `snprintf` is larger than the actual size of the buffer.

To fix the problem, either the second argument to `snprintf` should be changed to 80, or the buffer extended to 256 characters. A further improvement is to use a preprocessor define so that the size is only specified in one place, potentially preventing future recurrence of this issue.


## References
* Common Weakness Enumeration: [CWE-120](https://cwe.mitre.org/data/definitions/120.html).
* Common Weakness Enumeration: [CWE-787](https://cwe.mitre.org/data/definitions/787.html).
* Common Weakness Enumeration: [CWE-805](https://cwe.mitre.org/data/definitions/805.html).
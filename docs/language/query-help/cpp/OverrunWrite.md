# Potentially overrunning write

```
ID: cpp/overrunning-write
Kind: problem
Severity: error
Precision: medium
Tags: reliability security external/cwe/cwe-120 external/cwe/cwe-787 external/cwe/cwe-805

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-120/OverrunWrite.ql)

The program performs a buffer copy or write operation with no upper limit on the size of the copy, and it appears that certain inputs will cause a buffer overflow to occur in this case. In addition to causing program instability, techniques exist which may allow an attacker to use this vulnerability to execute arbitrary code.


## Recommendation
Always control the length of buffer copy and buffer write operations. `strncpy` should be used over `strcpy`, `snprintf` over `sprintf`, and in other cases 'n-variant' functions should be preferred.


## Example

```c
void sayHello()
{
	char buffer[10];

	// BAD: this message overflows the buffer
	strcpy(buffer, "Hello, world!");

	MessageBox(hWnd, buffer, "New Message", MB_OK);
}
```
In this example, the call to `strcpy` copies a message of 14 characters (including the terminating null) into a buffer with space for just 10 characters. As such, the last four characters overflow the buffer resulting in undefined behavior.

To fix this issue three changes should be made:

* Control the size of the buffer using a preprocessor define.
* Replace the call to `strcpy` with `strncpy`, specifying the define as the maximum length to copy. This will prevent the buffer overflow.
* Consider increasing the buffer size, say to 20 characters, so that the message is displayed correctly.

## References
* CERT C Coding Standard: [STR31-C. Guarantee that storage for strings has sufficient space for character data and the null terminator](https://www.securecoding.cert.org/confluence/display/c/STR31-C.+Guarantee+that+storage+for+strings+has+sufficient+space+for+character+data+and+the+null+terminator).
* Common Weakness Enumeration: [CWE-120](https://cwe.mitre.org/data/definitions/120.html).
* Common Weakness Enumeration: [CWE-787](https://cwe.mitre.org/data/definitions/787.html).
* Common Weakness Enumeration: [CWE-805](https://cwe.mitre.org/data/definitions/805.html).
# Unbounded write

```
ID: cpp/unbounded-write
Kind: path-problem
Severity: error
Precision: medium
Tags: reliability security external/cwe/cwe-120 external/cwe/cwe-787 external/cwe/cwe-805

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-120/UnboundedWrite.ql)

The program performs a buffer copy or write operation with no upper limit on the size of the copy. An unexpectedly long input that reaches this code will cause the buffer to overflow. In addition to causing program instability, techniques exist which may allow an attacker to use this vulnerability to execute arbitrary code.


## Recommendation
Always control the length of buffer copy and buffer write operations. `strncpy` should be used over `strcpy`, `snprintf` over `sprintf` etc. In general 'n-variant' functions should be preferred.


## Example

```c
void congratulateUser(const char *userName)
{
	char buffer[80];

	// BAD: this could overflow the buffer if the UserName is long
	sprintf(buffer, "Congratulations, %s!", userName);

	MessageBox(hWnd, buffer, "New Message", MB_OK);
}
```
In this example, the call to `sprintf` may overflow `buffer`. This occurs if the argument `userName` is very long, such that the resulting string is more than the 80 characters allowed.

To fix the problem the call to `sprintf` should be replaced with `snprintf`, specifying a maximum length of 80 characters.


## References
* CERT C++ Coding Standard: [STR50-CPP. Guarantee that storage for strings has sufficient space for character data and the null terminator](https://www.securecoding.cert.org/confluence/display/cplusplus/STR50-CPP.+Guarantee+that+storage+for+strings+has+sufficient+space+for+character+data+and+the+null+terminator).
* Common Weakness Enumeration: [CWE-120](https://cwe.mitre.org/data/definitions/120.html).
* Common Weakness Enumeration: [CWE-787](https://cwe.mitre.org/data/definitions/787.html).
* Common Weakness Enumeration: [CWE-805](https://cwe.mitre.org/data/definitions/805.html).
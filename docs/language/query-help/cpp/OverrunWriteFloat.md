# Potentially overrunning write with float to string conversion

```
ID: cpp/overrunning-write-with-float
Kind: problem
Severity: error
Precision: medium
Tags: reliability security external/cwe/cwe-120 external/cwe/cwe-787 external/cwe/cwe-805

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-120/OverrunWriteFloat.ql)

The program performs a buffer copy or write operation that includes one or more float to string conversions (i.e. the %f format specifier), which may overflow the destination buffer if extreme inputs are given. In addition to causing program instability, techniques exist which may allow an attacker to use this vulnerability to execute arbitrary code.


## Recommendation
Always control the length of buffer copy and buffer write operations. `strncpy` should be used over `strcpy`, `snprintf` over `sprintf`, and in other cases 'n-variant' functions should be preferred.


## Example

```c
void displayValue(double value)
{
	char buffer[256];

	// BAD: extreme values may overflow the buffer
	sprintf(buffer, "%f", value);

	MessageBox(hWnd, buffer, "A Number", MB_OK);
}
```
In this example, the call to `sprintf` contains a %f format specifier. Though a 256 character buffer has been allowed, it is not sufficient for the most extreme floating point inputs. For example the representation of double value 1e304 (that is 1 with 304 zeroes after it) will overflow a buffer of this length.

To fix this issue three changes should be made:

* Control the size of the buffer using a preprocessor define.
* Replace the call to `sprintf` with `snprintf`, specifying the define as the maximum length to copy. This will prevent the buffer overflow.
* Consider using the %g format specifier instead of %f.

## References
* CERT C Coding Standard: [STR31-C. Guarantee that storage for strings has sufficient space for character data and the null terminator](https://www.securecoding.cert.org/confluence/display/c/STR31-C.+Guarantee+that+storage+for+strings+has+sufficient+space+for+character+data+and+the+null+terminator).
* Common Weakness Enumeration: [CWE-120](https://cwe.mitre.org/data/definitions/120.html).
* Common Weakness Enumeration: [CWE-787](https://cwe.mitre.org/data/definitions/787.html).
* Common Weakness Enumeration: [CWE-805](https://cwe.mitre.org/data/definitions/805.html).
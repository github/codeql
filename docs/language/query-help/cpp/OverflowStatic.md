# Static array access may cause overflow

```
ID: cpp/static-buffer-overflow
Kind: problem
Severity: warning
Precision: medium
Tags: reliability security external/cwe/cwe-119 external/cwe/cwe-131

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Critical/OverflowStatic.ql)

When you use static arrays you must ensure that you do not exceed the size of the array during write and access operations. If an operation attempts to write to or access an element that is outside the range of the array then this results in a buffer overflow. Buffer overflows can lead to anything from a segmentation fault to a security vulnerability.


## Recommendation
Check the offsets and sizes used in the highlighted operations to ensure that a buffer overflow will not occur.


## Example

```cpp
#define SIZE 30

int f(char * s) {
	char buf[20]; //buf not set to use SIZE macro

	strncpy(buf, s, SIZE); //wrong: copy may exceed size of buf

	for (int i = 0; i < SIZE; i++) { //wrong: upper limit that is higher than array size
		cout << array[i];
	}
}

```

## References
* I. Gerg. *An Overview and Example of the Buffer-Overflow Exploit*. IANewsletter vol 7 no 4. 2005.
* M. Donaldson. *Inside the Buffer Overflow Attack: Mechanism, Method & Prevention*. SANS Institute InfoSec Reading Room. 2002.
* Common Weakness Enumeration: [CWE-119](https://cwe.mitre.org/data/definitions/119.html).
* Common Weakness Enumeration: [CWE-131](https://cwe.mitre.org/data/definitions/131.html).
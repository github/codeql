# Potentially uninitialized local variable

```
ID: cpp/uninitialized-local
Kind: problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-665 external/cwe/cwe-457

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Likely%20Bugs/Memory%20Management/UninitializedLocal.ql)

A local non-static variable of a non-class type has an undefined value before it is initialized. For example, it is incorrect to rely on an uninitialized integer to have the value `0`.


## Recommendation
Review the code and consider whether the variable should have an initializer or whether some path through the program lacks an assignment to the variable.


## Example
The function `absWrong` does not initialize the variable `j` in the case where `i = 0`. Functions `absCorrect1` and `absCorrect2` remedy this deficiency by adding an initializer and adding an assignment to one of the paths through the program, respectively.


```cpp
int absWrong(int i) {
	int j;
	if (i > 0) {
		j = i;
	} else if (i < 0) {
		j = -i;
	}
	return j; // wrong: j may not be initialized before use
}

int absCorrect1(int i) {
	int j = 0;
	if (i > 0) {
		j = i;
	} else if (i < 0) {
		j = -i;
	}
	return j; // correct: j always initialized before use
}

int absCorrect2(int i) {
	int j;
	if (i > 0) {
		j = i;
	} else if (i < 0) {
		j = -i;
	} else {
		j = 0;
	}
	return j; // correct: j always initialized before use
}
```

## References
* ISO/IEC 9899:2011: [Programming languages - C (Section 6.3.2.1)](https://www.iso.org/standard/57853.html).
* Common Weakness Enumeration: [CWE-665](https://cwe.mitre.org/data/definitions/665.html).
* Common Weakness Enumeration: [CWE-457](https://cwe.mitre.org/data/definitions/457.html).
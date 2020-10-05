# Suspicious 'sizeof' use

```
ID: cpp/suspicious-sizeof
Kind: problem
Severity: warning
Precision: medium
Tags: reliability correctness security external/cwe/cwe-467

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Likely%20Bugs/Memory%20Management/SuspiciousSizeof.ql)

This rule finds expressions that take the size of a function parameter of array type. In C, function parameters of array type are treated as if they had the corresponding pointer type, so their size is always the size of the pointer type (typically either four or eight). In particular, one cannot determine the size of a memory buffer passed as a parameter in this way. Using the `sizeof` operator on pointer types will produce unexpected results if the developer intended to get the size of an array instead of the pointer.


## Recommendation
Modify the function to take an extra argument indicating the buffer size.


## Example

```cpp
void f(char s[]) {
	int size = sizeof(s); //wrong: s is now a char*, not an array. 
	                      //sizeof(s) will evaluate to sizeof(char *)
}

```

## References
* Comp.lang.c, Frequently Asked Questions: [Question 6.3: So what is meant by the "equivalence of pointers and arrays" in C?](http://c-faq.com/aryptr/aryptrequiv.html).
* Common Weakness Enumeration: [CWE-467](https://cwe.mitre.org/data/definitions/467.html).
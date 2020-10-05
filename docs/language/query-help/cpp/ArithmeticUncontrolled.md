# Uncontrolled data in arithmetic expression

```
ID: cpp/uncontrolled-arithmetic
Kind: path-problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-190 external/cwe/cwe-191

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-190/ArithmeticUncontrolled.ql)

Performing calculations on uncontrolled data can result in integer overflows unless the input is validated.

If the data is not under your control, and can take extremely large values, even arithmetic operations that would usually result in a small change in magnitude may result in overflows.


## Recommendation
Always guard against overflow in arithmetic operations on uncontrolled data by doing one of the following:

* Validate the data.
* Define a guard on the arithmetic expression, so that the operation is performed only if the result can be known to be less than, or equal to, the maximum value for the type, for example `INT_MAX`.
* Use a wider type, so that larger input values do not cause overflow.

## Example
In this example, a random integer is generated. Because the value is not controlled by the programmer, it could be extremely large. Performing arithmetic operations on this value could therefore cause an overflow. To avoid this happening, the example shows how to perform a check before performing an arithmetic operation.


```c
int main(int argc, char** argv) {
	int i = rand();
	// BAD: potential overflow
	int j = i + 1000;

	// ...

	int n = rand();
	int k;
	// GOOD: use a guard to prevent overflow
	if (n < INT_MAX-1000)
		k = n + 1000;
	else
		k = INT_MAX;
}

```

## References
* Common Weakness Enumeration: [CWE-190](https://cwe.mitre.org/data/definitions/190.html).
* Common Weakness Enumeration: [CWE-191](https://cwe.mitre.org/data/definitions/191.html).
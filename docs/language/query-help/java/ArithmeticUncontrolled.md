# Uncontrolled data in arithmetic expression

```
ID: java/uncontrolled-arithmetic
Kind: path-problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-190 external/cwe/cwe-191

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-190/ArithmeticUncontrolled.ql)

Performing calculations on uncontrolled data can result in integer overflows unless the input is validated.

If the data is not under your control, and can take extremely large values, even arithmetic operations that would usually result in a small change in magnitude may result in overflows.


## Recommendation
Always guard against overflow in arithmetic operations on uncontrolled data by doing one of the following:

* Validate the data.
* Define a guard on the arithmetic expression, so that the operation is performed only if the result can be known to be less than, or equal to, the maximum value for the type, for example `MAX_VALUE`.
* Use a wider type, so that larger input values do not cause overflow.

## Example
In this example, a random integer is generated. Because the value is not controlled by the programmer, it could be extremely large. Performing arithmetic operations on this value could therefore cause an overflow. To avoid this happening, the example shows how to perform a check before performing a multiplication.


```java
class Test {
	public static void main(String[] args) {
		{
			int data = (new java.security.SecureRandom()).nextInt();

			// BAD: may overflow if data is large
			int scaled = data * 10;

			// ...

			// GOOD: use a guard to ensure no overflows occur
			int scaled2;
			if (data < Integer.MAX_VALUE/10)
				scaled2 = data * 10;
			else 
				scaled2 = Integer.MAX_VALUE;
		}
	}
}
```

## References
* The CERT Oracle Secure Coding Standard for Java: [NUM00-J. Detect or prevent integer overflow](https://www.securecoding.cert.org/confluence/display/java/NUM00-J.+Detect+or+prevent+integer+overflow).
* Common Weakness Enumeration: [CWE-190](https://cwe.mitre.org/data/definitions/190.html).
* Common Weakness Enumeration: [CWE-191](https://cwe.mitre.org/data/definitions/191.html).
# Implicit narrowing conversion in compound assignment

```
ID: java/implicit-cast-in-compound-assignment
Kind: problem
Severity: warning
Precision: very-high
Tags: reliability security external/cwe/cwe-190 external/cwe/cwe-192 external/cwe/cwe-197 external/cwe/cwe-681

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Likely%20Bugs/Arithmetic/InformationLoss.ql)

Compound assignment statements of the form `x += y` or `x *= y` perform an implicit narrowing conversion if the type of `x` is narrower than the type of `y`. For example, `x += y` is equivalent to `x = (T)(x + y)`, where `T` is the type of `x`. This can result in information loss and numeric errors such as overflows.


## Recommendation
Ensure that the type of the left-hand side of the compound assignment statement is at least as wide as the type of the right-hand side.


## Example
If `x` is of type `short` and `y` is of type `int`, the expression `x + y` is of type `int`. However, the expression `x += y` is equivalent to `x = (short) (x + y)`. The expression `x + y` is cast to the type of the left-hand side of the assignment: `short`, possibly leading to information loss.

To avoid implicitly narrowing the type of `x + y`, change the type of `x` to `int`. Then the types of `x` and `x + y` are both `int` and there is no need for an implicit cast.


## References
* J. Bloch and N. Gafter, *Java Puzzlers: Traps, Pitfalls, and Corner Cases*, Puzzle 9. Addison-Wesley, 2005.
* The Java Language Specification: [Compound Assignment Operators](http://docs.oracle.com/javase/specs/jls/se7/html/jls-15.html#jls-15.26.2), [Narrowing Primitive Conversion](http://docs.oracle.com/javase/specs/jls/se7/html/jls-5.html#jls-5.1.3).
* The CERT Oracle Secure Coding Standard for Java: [NUM00-J. Detect or prevent integer overflow](https://www.securecoding.cert.org/confluence/display/java/NUM00-J.+Detect+or+prevent+integer+overflow).
* Common Weakness Enumeration: [CWE-190](https://cwe.mitre.org/data/definitions/190.html).
* Common Weakness Enumeration: [CWE-192](https://cwe.mitre.org/data/definitions/192.html).
* Common Weakness Enumeration: [CWE-197](https://cwe.mitre.org/data/definitions/197.html).
* Common Weakness Enumeration: [CWE-681](https://cwe.mitre.org/data/definitions/681.html).
# Comparison of narrow type with wide type in loop condition

```
ID: java/comparison-with-wider-type
Kind: problem
Severity: warning
Precision: medium
Tags: reliability security external/cwe/cwe-190 external/cwe/cwe-197

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-190/ComparisonWithWiderType.ql)

In a loop condition, comparison of a value of a narrow type with a value of a wide type may always evaluate to `true` if the wider value is sufficiently large (or small). This is because the narrower value may overflow. This can lead to an infinite loop.


## Recommendation
Change the types of the compared values so that the value on the narrower side of the comparison is at least as wide as the value it is being compared with.


## Example
In this example, `bytesReceived` is compared against `MAXGET` in a `while` loop. However, `bytesReceived` is a `short`, and `MAXGET` is a `long`. Because `MAXGET` is larger than `Short.MAX_VALUE`, the loop condition is always `true`, so the loop never terminates.

This problem is avoided in the 'GOOD' case because `bytesReceived2` is a `long`, which is as wide as the type of `MAXGET`.


```java
class Test {
	public static void main(String[] args) {
		
		{		
			int BIGNUM = Integer.MAX_VALUE;
			long MAXGET = Short.MAX_VALUE + 1;
			
			char[] buf = new char[BIGNUM];

			short bytesReceived = 0;
			
			// BAD: 'bytesReceived' is compared with a value of wider type.
			// 'bytesReceived' overflows before reaching MAXGET,
			// causing an infinite loop.
			while (bytesReceived < MAXGET) {
				bytesReceived += getFromInput(buf, bytesReceived);
			}
		}
		
		{
			long bytesReceived2 = 0;
			
			// GOOD: 'bytesReceived2' has a type at least as wide as MAXGET.
			while (bytesReceived2 < MAXGET) {
				bytesReceived2 += getFromInput(buf, bytesReceived2);
			}
		}
		
	}
	
	public static int getFromInput(char[] buf, short pos) {
		// write to buf
		// ...
		return 1;
	}
}
```

## References
* The CERT Oracle Secure Coding Standard for Java: [NUM00-J. Detect or prevent integer overflow](https://www.securecoding.cert.org/confluence/display/java/NUM00-J.+Detect+or+prevent+integer+overflow).
* Common Weakness Enumeration: [CWE-190](https://cwe.mitre.org/data/definitions/190.html).
* Common Weakness Enumeration: [CWE-197](https://cwe.mitre.org/data/definitions/197.html).
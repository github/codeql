# User-controlled data in numeric cast

```
ID: java/tainted-numeric-cast
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-197 external/cwe/cwe-681

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-681/NumericCastTainted.ql)

Casting a user-controlled numeric value to a narrower type can result in truncated values unless the input is validated.

Narrowing conversions may cause potentially unintended results. For example, casting the positive integer value `128` to type `byte` yields the negative value `-128`.


## Recommendation
Guard against unexpected truncation of user-controlled arithmetic data by doing one of the following:

* Validate the user input.
* Define a guard on the cast expression, so that the cast is performed only if the input is known to be within the range of the resulting type.
* Avoid casting to a narrower type, and instead continue to use a wider type.

## Example
In this example, a value is read from standard input into a `long`. Because the value is a user-controlled value, it could be extremely large. Casting this value to a narrower type could therefore cause unexpected truncation. The `scaled2` example uses a guard to avoid this problem and checks the range of the input before performing the cast. If the value is too large to cast to type `int` it is rejected as invalid.


```java
class Test {
	public static void main(String[] args) throws IOException {
		{
			long data;

			BufferedReader readerBuffered = new BufferedReader(
					new InputStreamReader(System.in, "UTF-8"));
			String stringNumber = readerBuffered.readLine();
			if (stringNumber != null) {
				data = Long.parseLong(stringNumber.trim());
			} else {
				data = 0;
			}

			// AVOID: potential truncation if input data is very large,
			// for example 'Long.MAX_VALUE'
			int scaled = (int)data;

			//...

			// GOOD: use a guard to ensure no truncation occurs
			int scaled2;
			if (data > Integer.MIN_VALUE && data < Integer.MAX_VALUE)
				scaled2 = (int)data;
			else
				throw new IllegalArgumentException("Invalid input");
		}
	}
}
```

## References
* The CERT Oracle Secure Coding Standard for Java: [NUM12-J. Ensure conversions of numeric types to narrower types do not result in lost or misinterpreted data](https://www.securecoding.cert.org/confluence/display/java/NUM12-J.+Ensure+conversions+of+numeric+types+to+narrower+types+do+not+result+in+lost+or+misinterpreted+data).
* Common Weakness Enumeration: [CWE-197](https://cwe.mitre.org/data/definitions/197.html).
* Common Weakness Enumeration: [CWE-681](https://cwe.mitre.org/data/definitions/681.html).
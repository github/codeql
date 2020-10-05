# Unterminated variadic call

```
ID: cpp/unterminated-variadic-call
Kind: problem
Severity: warning
Precision: medium
Tags: reliability security external/cwe/cwe-121

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-121/UnterminatedVarargsCall.ql)

The program calls a function that expects the variable argument list to be terminated with a sentinel value (typically NULL, 0 or -1). In this case, the sentinel value has been omitted as a final argument. This defect may result in incorrect behavior of the function and unintended stack memory access, leading to incorrect program results, instability, and even vulnerability to buffer overflow style attacks.


## Recommendation
Each description of a defect highlighted by this rule includes a suggested value for the terminator. Check that this value is correct, then add it to the end of the call.


## Example

```cpp
#include <stdarg.h>

void pushStrings(char *firstString, ...)
{
	va_list args;
	char *arg;

	va_start(args, firstString);

	// process inputs, beginning with firstString, ending when NULL is reached
	arg = firstString;
	while (arg != NULL)
	{
		// push the string
		pushString(arg);
	
		// move on to the next input
		arg = va_arg(args, char *);
	}

	va_end(args);
}

void badFunction()
{
	pushStrings("hello", "world", NULL); // OK
	
	pushStrings("apple", "pear", "banana", NULL); // OK

	pushStrings("car", "bus", "train"); // BAD, not terminated with the expected NULL
}
```
In this example, the third call to `pushStrings` is not correctly terminated. This call should be updated to include `NULL` as the fourth and final argument to this call.


## References
* Common Weakness Enumeration: [CWE-121](https://cwe.mitre.org/data/definitions/121.html).
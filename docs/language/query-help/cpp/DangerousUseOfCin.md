# Dangerous use of 'cin'

```
ID: cpp/dangerous-cin
Kind: problem
Severity: error
Precision: high
Tags: reliability security external/cwe/cwe-676

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-676/DangerousUseOfCin.ql)

This rule finds calls to `std::istream::operator>>` on `std::cin` without a preceding call to `cin.width`. Consuming input from `cin` without specifying the length of the input is dangerous due to the possibility of buffer overflows.


## Recommendation
Always specify the length of any input expected from `cin` by calling `cin.width` before consuming the input.


## Example
The following example shows both a dangerous and a safe way to consume input from `cin`.


```cpp
#define BUFFER_SIZE 20

void bad()
{
	char buffer[BUFFER_SIZE];
	// BAD: Use of 'cin' without specifying the length of the input.
	cin >> buffer;
	buffer[BUFFER_SIZE-1] = '\0';
}

void good()
{
	char buffer[BUFFER_SIZE];
	// GOOD: Specifying the length of the input before using 'cin'.
	cin.width(BUFFER_SIZE);
	cin >> buffer;
	buffer[BUFFER_SIZE-1] = '\0';
}

```

## References
* Common Weakness Enumeration: [CWE-676](https://cwe.mitre.org/data/definitions/676.html).
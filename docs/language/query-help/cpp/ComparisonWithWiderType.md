# Comparison of narrow type with wide type in loop condition

```
ID: cpp/comparison-with-wider-type
Kind: problem
Severity: warning
Precision: high
Tags: reliability security external/cwe/cwe-190 external/cwe/cwe-197 external/cwe/cwe-835

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-190/ComparisonWithWiderType.ql)

In a loop condition, comparison of a value of a narrow type with a value of a wide type may result in unexpected behavior if the wider value is sufficiently large (or small). This is because the narrower value may overflow. This can lead to an infinite loop.


## Recommendation
Change the types of the compared values so that the value on the narrower side of the comparison is at least as wide as the value it is being compared with.


## Example
In this example, `bytes_received` is compared against `max_get` in a `while` loop. However, `bytes_received` is an `int16_t`, and `max_get` is an `int32_t`. Because `max_get` is larger than `INT16_MAX`, the loop condition is always `true`, so the loop never terminates.

This problem is avoided in the 'GOOD' case because `bytes_received2` is an `int32_t`, which is as wide as the type of `max_get`.


```c
void main(int argc, char **argv) {
	uint32_t big_num = INT32_MAX;
	char buf[big_num];
	int16_t bytes_received = 0;
	int max_get = INT16_MAX + 1;

	// BAD: 'bytes_received' is compared with a value of a wider type.
	// 'bytes_received' overflows before  reaching 'max_get',
	// causing an infinite loop
	while (bytes_received < max_get)
		bytes_received += get_from_input(buf, bytes_received);
	}

	uint32_t bytes_received = 0;

	// GOOD: 'bytes_received2' has a type  at least as wide as 'max_get'
	while (bytes_received < max_get) {
		bytes_received += get_from_input(buf, bytes_received);
	}

}


int getFromInput(char *buf, short pos) {
	// write to buf
	// ...
	return 1;
}

```

## References
* [Data type ranges](https://docs.microsoft.com/en-us/cpp/cpp/data-type-ranges)
* [INT18-C. Evaluate integer expressions in a larger size before comparing or assigning to that size ](https://wiki.sei.cmu.edu/confluence/display/c/INT18-C.+Evaluate+integer+expressions+in+a+larger+size+before+comparing+or+assigning+to+that+size)
* Common Weakness Enumeration: [CWE-190](https://cwe.mitre.org/data/definitions/190.html).
* Common Weakness Enumeration: [CWE-197](https://cwe.mitre.org/data/definitions/197.html).
* Common Weakness Enumeration: [CWE-835](https://cwe.mitre.org/data/definitions/835.html).
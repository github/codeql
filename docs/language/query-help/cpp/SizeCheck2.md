# Not enough memory allocated for array of pointer type

```
ID: cpp/suspicious-allocation-size
Kind: problem
Severity: warning
Precision: medium
Tags: reliability security external/cwe/cwe-131 external/cwe/cwe-122

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Critical/SizeCheck2.ql)

When you allocate an array from memory using `malloc`, `calloc` or `realloc`, you should ensure that you allocate enough memory to contain a multiple of the size of the required pointer type. Calls that are assigned to a non-void pointer variable, but do not allocate enough memory will cause a buffer overflow when a field accessed on the pointer points to memory that is beyond the allocated array. Buffer overflows can lead to anything from a segmentation fault to a security vulnerability.


## Recommendation
The highlighted call allocates memory that is not a multiple of the size of the pointer type, which can cause a memory overrun. Use the `sizeof` operator to ensure that the function call allocates enough memory for that type.


## Example

```cpp
#define RECORD_SIZE 30  //incorrect or outdated size for record
typedef struct {
	char name[30];
	int status;
} Record;

void f() {
	Record* p = malloc(RECORD_SIZE * 4); //wrong: not a multiple of the size of Record
	p[3].status = 1; //will most likely segfault
	...
}

```

## References
* I. Gerg. *An Overview and Example of the Buffer-Overflow Exploit*. IANewsletter vol 7 no 4. 2005.
* M. Donaldson. *Inside the Buffer Overflow Attack: Mechanism, Method & Prevention*. SANS Institute InfoSec Reading Room. 2002.
* Common Weakness Enumeration: [CWE-131](https://cwe.mitre.org/data/definitions/131.html).
* Common Weakness Enumeration: [CWE-122](https://cwe.mitre.org/data/definitions/122.html).
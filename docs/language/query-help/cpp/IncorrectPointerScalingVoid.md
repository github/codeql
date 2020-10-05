# Suspicious pointer scaling to void

```
ID: cpp/suspicious-pointer-scaling-void
Kind: problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-468

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-468/IncorrectPointerScalingVoid.ql)

Casting arbitrary pointers into `void*` and then accessing their contents should be done with care. The results may not be portable.

This query finds pointer arithmetic expressions where a pointer to `void` (or similar) is then cast to another type and dereferenced.


## Recommendation
1. Whenever possible, use the array subscript operator rather than pointer arithmetic. For example, replace `*(p+k)` with `p[k]`.
1. Cast to the correct type before using pointer arithmetic. For example, if the type of `p` is `void*` but it really points to an array of type `double[]` then use the syntax `(double*)p + k` to get a pointer to the `k`'th element of the array.
1. If pointer arithmetic must be done with a single-byte width, prefer `char *` to `void *`, as pointer arithmetic on `void *` is a nonstandard GNU extension.

## Example

```cpp
char example1(int i) {
  int intArray[5] = { 1, 2, 3, 4, 5 };
  void *voidPointer = (void *)intArray;
  // BAD: the pointer arithmetic uses type void*, so the offset
  // is not scaled by sizeof(int).
  return *(voidPointer + i);
}

int example2(int i) {
  int intArray[10] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
  int *intPointer = intArray;
  // GOOD: the offset is automatically scaled by sizeof(int).
  return *(intPointer + i);
}

```

## References
* Common Weakness Enumeration: [CWE-468](https://cwe.mitre.org/data/definitions/468.html).
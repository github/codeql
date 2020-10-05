# Suspicious pointer scaling

```
ID: cpp/suspicious-pointer-scaling
Kind: problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-468

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-468/IncorrectPointerScaling.ql)

Pointer arithmetic in C and C++ is automatically scaled according to the size of the data type. For example, if the type of `p` is `T*` and `sizeof(T) == 4` then the expression `p+1` adds 4 bytes to `p`. This can cause a buffer overflow condition if the programmer forgets that they are adding a multiple of `sizeof(T)`, rather than a number of bytes.

This query finds pointer arithmetic expressions where it appears likely that the programmer has forgotten that the offset is automatically scaled.


## Recommendation
1. Whenever possible, use the array subscript operator rather than pointer arithmetic. For example, replace `*(p+k)` with `p[k]`.
1. Cast to the correct type before using pointer arithmetic. For example, if the type of `p` is `int*` but it really points to an array of type `double[]` then use the syntax `(double*)p + k` to get a pointer to the `k`'th element of the array.

## Example

```cpp
int example1(int i) {
  int intArray[10] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
  int *intPointer = intArray;
  // BAD: the offset is already automatically scaled by sizeof(int),
  // so this code will compute the wrong offset.
  return *(intPointer + (i * sizeof(int)));
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
# Suspicious add with sizeof

```
ID: cpp/suspicious-add-sizeof
Kind: problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-468

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-468/SuspiciousAddWithSizeof.ql)

Pointer arithmetic in C and C++ is automatically scaled according to the size of the data type. For example, if the type of `p` is `T*` and `sizeof(T) == 4` then the expression `p+1` adds 4 bytes to `p`.

This query finds code of the form `p + k*sizeof(T)`. Such code is usually a mistake because there is no need to manually scale the offset by `sizeof(T)`.


## Recommendation
1. Whenever possible, use the array subscript operator rather than pointer arithmetic. For example, replace `*(p+k)` with `p[k]`.
1. Cast to the correct type before using pointer arithmetic. For example, if the type of `p` is `char*` but it really points to an array of type `double[]` then use the syntax `(double*)p + k` to get a pointer to the `k`'th element of the array.

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
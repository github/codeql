# Pointer overflow check

```
ID: cpp/pointer-overflow-check
Kind: problem
Severity: error
Precision: high
Tags: reliability security

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Likely%20Bugs/Memory%20Management/PointerOverflow.ql)

When checking for integer overflow, you may often write tests like `p + i < p`. This works fine if `p` and `i` are unsigned integers, since any overflow in the addition will cause the value to simply "wrap around." However, using this pattern when `p` is a pointer is problematic because pointer overflow has undefined behavior according to the C and C++ standards. If the addition overflows and has an undefined result, the comparison will likewise be undefined; it may produce an unintended result, or may be deleted entirely by an optimizing compiler.


## Recommendation
To check whether an index `i` is less than the length of an array, simply compare these two numbers as unsigned integers: `i < ARRAY_LENGTH`. If the length of the array is defined as the difference between two pointers `ptr` and `p_end`, write `i < p_end - ptr`. If `i` is signed, cast it to unsigned in order to guard against negative `i`. For example, write `(size_t)i < p_end - ptr`.


## Example
An invalid check for pointer overflow is most often seen as part of checking whether a number `a` is too large by checking first if adding the number to `ptr` goes past the end of an allocation and then checking if adding it to `ptr` creates a pointer so large that it overflows and wraps around.


```cpp
bool not_in_range(T *ptr, T *ptr_end, size_t i) {
    return ptr + i >= ptr_end || ptr + i < ptr; // BAD
}

```
In both of these checks, the operations are performed in the wrong order. First, an expression that may cause undefined behavior is evaluated (`ptr + i`), and then the result is checked for being in range. But once undefined behavior has happened in the pointer addition, it cannot be recovered from: it's too late to perform the range check after a possible pointer overflow.

While it's not the subject of this query, the expression `ptr + i < ptr_end` is also an invalid range check. It's undefined behavor in C/C++ to create a pointer that points more than one past the end of an allocation.

The next example shows how to portably check whether an unsigned number is outside the range of an allocation between `ptr` and `ptr_end`.


```cpp
bool not_in_range(T *ptr, T *ptr_end, size_t i) {
    return i >= ptr_end - ptr; // GOOD
}
```

## References
* Embedded in Academia: [Pointer Overflow Checking](https://blog.regehr.org/archives/1395).
* LWN: [GCC and pointer overflows](https://lwn.net/Articles/278137/).
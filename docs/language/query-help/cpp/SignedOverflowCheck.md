# Signed overflow check

```
ID: cpp/signed-overflow-check
Kind: problem
Severity: warning
Precision: high
Tags: correctness security

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Likely%20Bugs/Arithmetic/SignedOverflowCheck.ql)

When checking for integer overflow, you may often write tests like `a + b < a`. This works fine if `a` or `b` are unsigned integers, since any overflow in the addition will cause the value to simply "wrap around." However, using *signed* integers is problematic because signed overflow has undefined behavior according to the C and C++ standards. If the addition overflows and has an undefined result, the comparison will likewise be undefined; it may produce an unintended result, or may be deleted entirely by an optimizing compiler.


## Recommendation
Solutions to this problem can be thought of as falling into one of two categories:

1. Rewrite the signed expression so that overflow cannot occur but the signedness remains.
1. Change the variables and all their uses to be unsigned.
The following cases all fall into the first category.

1. Given `unsigned short n1, delta` and `n1 + delta < n1`, it is possible to rewrite it as `(unsigned short)(n1 + delta)&nbsp;<&nbsp;n1`. Note that `n1 + delta` does not actually overflow, due to `int` promotion.
1. Given `unsigned short n1, delta` and `n1 + delta < n1`, it is also possible to rewrite it as `n1 > USHORT_MAX - delta`. The `limits.h` or `climits` header must then be included.
1. Given `int n1, delta` and `n1 + delta < n1`, it is possible to rewrite it as `n1 > INT_MAX - delta`. It must be true that `delta >= 0` and the `limits.h` or `climits` header has been included.

## Example
In the following example, even though `delta` has been declared `unsigned short`, C/C++ type promotion rules require that its type is promoted to the larger type used in the addition and comparison, namely a `signed int`. Addition is performed on signed integers, and may have undefined behavior if an overflow occurs. As a result, the entire (comparison) expression may also have an undefined result.


```cpp
bool foo(int n1, unsigned short delta) {
    return n1 + delta < n1; // BAD
}

```
The following example builds upon the previous one. Instead of performing an addition (which could overflow), we have re-framed the solution so that a subtraction is used instead. Since `delta` is promoted to a `signed int` and `INT_MAX` denotes the largest possible positive value for an `signed int`, the expression `INT_MAX - delta` can never be less than zero or more than `INT_MAX`. Hence, any overflow and underflow are avoided.


```cpp
#include <limits.h>
bool foo(int n1, unsigned short delta) {
    return n1 > INT_MAX - delta; // GOOD
}

```
In the following example, even though both `n` and `delta` have been declared `unsigned short`, both are promoted to `signed int` prior to addition. Because we started out with the narrower `short` type, the addition is guaranteed not to overflow and is therefore defined. But the fact that `n1 + delta` never overflows means that the condition `n1 + delta < n1` will never hold true, which likely is not what the programmer intended. (see also the `cpp/bad-addition-overflow-check` query).


```cpp
bool bar(unsigned short n1, unsigned short delta) {
    // NB: Comparison is always false
    return n1 + delta < n1; // GOOD (but misleading)
}

```
The next example provides a solution to the previous one. Even though `n1 + delta` does not overflow, casting it to an `unsigned short` truncates the addition modulo 2^16, so that `unsigned short` "wrap around" may now be observed. Furthermore, since the left-hand side is now of type `unsigned short`, the right-hand side does not need to be promoted to a `signed int`.


```cpp
bool bar(unsigned short n1, unsigned short delta) {
    return (unsigned short)(n1 + delta) < n1; // GOOD
}

```

## References
* [comp.lang.c FAQ list · Question 3.19 (Preserving rules)](http://c-faq.com/expr/preservingrules.html)
* [INT31-C. Ensure that integer conversions do not result in lost or misinterpreted data](https://wiki.sei.cmu.edu/confluence/display/c/INT31-C.+Ensure+that+integer+conversions+do+not+result+in+lost+or+misinterpreted+data)
* W. Dietz, P. Li, J. Regehr, V. Adve. [Understanding Integer Overflow in C/C++](https://www.cs.utah.edu/~regehr/papers/overflow12.pdf)
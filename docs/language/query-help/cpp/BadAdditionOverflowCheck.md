# Bad check for overflow of integer addition

>ID: cpp/bad-addition-overflow-check
>
>Kind: problem
>
>Severity: error
>
>Precision: very-high
>Tags: reliability correctness security external/cwe/cwe-190 external/cwe/cwe-192

[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Likely%20Bugs/Arithmetic/BadAdditionOverflowCheck.ql)

Checking for overflow of integer addition needs to be done with care, because automatic type promotion can prevent the check from working as intended, with the same value (`true` or `false`) always being returned.


## Recommendation
Use an explicit cast to make sure that the result of the addition is not implicitly converted to a larger type.


## Example

```cpp
bool checkOverflow(unsigned short x, unsigned short y) {
  // BAD: comparison is always false due to type promotion
  return (x + y < x);  
}

```
On a typical architecture where `short` is 16 bits and `int` is 32 bits, the operands of the addition are automatically promoted to `int`, so it cannot overflow and the result of the comparison is always false.

The code below implements the check correctly, by using an explicit cast to make sure that the result of the addition is `unsigned short` (which may overflow, in which case the comparison would evaluate to `true`).


```cpp
bool checkOverflow(unsigned short x, unsigned short y) {
  return ((unsigned short)(x + y) < x);  // GOOD: explicit cast
}

```

## References
* [Preserving Rules](http://c-faq.com/expr/preservingrules.html)
* [Understand integer conversion rules](https://www.securecoding.cert.org/confluence/plugins/servlet/mobile#content/view/20086942)
* Common Weakness Enumeration: [CWE-190](https://cwe.mitre.org/data/definitions/190.html).
* Common Weakness Enumeration: [CWE-192](https://cwe.mitre.org/data/definitions/192.html).
# Multiplication result converted to larger type

```
ID: cpp/integer-multiplication-cast-to-long
Kind: problem
Severity: warning
Precision: high
Tags: reliability security correctness types external/cwe/cwe-190 external/cwe/cwe-192 external/cwe/cwe-197 external/cwe/cwe-681

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Likely%20Bugs/Arithmetic/IntMultToLong.ql)

This rule finds code that converts the result of an integer multiplication to a larger type. Since the conversion applies *after* the multiplication, arithmetic overflow may still occur.

The rule flags every multiplication of two non-constant integer expressions that is (explicitly or implicitly) converted to a larger integer type. The conversion is an indication that the expression would produce a result that would be too large to fit in the smaller integer type.


## Recommendation
Use a cast to ensure that the multiplication is done using the larger integer type to avoid overflow.


## Example

```cpp
int i = 2000000000;
long j = i * i; //Wrong: due to overflow on the multiplication between ints, 
                //will result to j being -1651507200, not 4000000000000000000

long k = (long) i * i; //Correct: the multiplication is done on longs instead of ints, 
                       //and will not overflow

```

## References
* MSDN Library: [Multiplicative Operators: *, /, and %](http://msdn.microsoft.com/en-us/library/ty2ax9z9%28v=vs.71%29.aspx).
* Cplusplus.com: [Integer overflow](http://www.cplusplus.com/articles/DE18T05o/).
* Common Weakness Enumeration: [CWE-190](https://cwe.mitre.org/data/definitions/190.html).
* Common Weakness Enumeration: [CWE-192](https://cwe.mitre.org/data/definitions/192.html).
* Common Weakness Enumeration: [CWE-197](https://cwe.mitre.org/data/definitions/197.html).
* Common Weakness Enumeration: [CWE-681](https://cwe.mitre.org/data/definitions/681.html).
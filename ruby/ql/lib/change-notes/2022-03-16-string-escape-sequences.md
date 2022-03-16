---
category: minorAnalysis
---
* `getConstantValue()` now returns the contents of strings and symbols after escape sequences have been interpreted. For example, for the Ruby string literal `"\n"`, `getConstantValue().getString()` previously returned a QL string with two characters, a backslash followed by `n`; now it returns the single-character string "\n" (U+000A, known as newline).
* `getConstantValue().getInt()` previously returned incorrect values for integers larger than 2<sup>31</sup>-1 (the largest value that can be represented by the QL `int` type). It now returns no result in those cases.

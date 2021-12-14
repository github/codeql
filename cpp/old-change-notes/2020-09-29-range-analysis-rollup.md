lgtm,codescanning
* The `SimpleRangeAnalysis` library has gained support for several language
  constructs it did not support previously. These improvements primarily affect
  the queries `cpp/constant-comparison`, `cpp/comparison-with-wider-type`, and
  `cpp/integer-multiplication-cast-to-long`. The newly supported language
  features are:
    * Multiplication of unsigned numbers.
    * Multiplication by a constant.
    * Reference-typed function parameters.
    * Comparing a variable not equal to an endpoint of its range, thus narrowing the range by one.
    * Using `if (x)` or `if (!x)` or similar to test for equality to zero.
* The `SimpleRangeAnalysis` library can now be extended with custom rules. See
  examples in
  `cpp/ql/src/experimental/semmle/code/cpp/rangeanalysis/extensions/`.

# 'input' function used in Python 2

```
ID: py/use-of-input
Kind: problem
Severity: error
Precision: high
Tags: security correctness

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Expressions/UseofInput.ql)

In Python 2, a call to the `input()` function, `input(prompt)` is equivalent to `eval(raw_input(prompt))`. Evaluating user input without any checking can be a serious security flaw.


## Recommendation
Get user input with `raw_input(prompt)` and then validate that input before evaluating. If the expected input is a number or string, then `ast.literal_eval()` can always be used safely.


## References
* Python Standard Library: [input](http://docs.python.org/2/library/functions.html#input), [ast.literal_eval](http://docs.python.org/2/library/ast.html#ast.literal_eval).
* Wikipedia: [Data validation](http://en.wikipedia.org/wiki/Data_validation).
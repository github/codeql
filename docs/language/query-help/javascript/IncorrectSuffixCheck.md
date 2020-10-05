# Incorrect suffix check

```
ID: js/incorrect-suffix-check
Kind: problem
Severity: error
Precision: high
Tags: security correctness external/cwe/cwe-020

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-020/IncorrectSuffixCheck.ql)

The `indexOf` and `lastIndexOf` methods are sometimes used to check if a substring occurs at a certain position in a string. However, if the returned index is compared to an expression that might evaluate to -1, the check may pass in some cases where the substring was not found at all.

Specifically, this can easily happen when implementing `endsWith` using `indexOf`.


## Recommendation
Use `String.prototype.endsWith` if it is available. Otherwise, explicitly handle the -1 case, either by checking the relative lengths of the strings, or by checking if the returned index is -1.


## Example
The following example uses `lastIndexOf` to determine if the string `x` ends with the string `y`:


```javascript
function endsWith(x, y) {
  return x.lastIndexOf(y) === x.length - y.length;
}

```
However, if `y` is one character longer than `x`, the right-hand side `x.length - y.length` becomes -1, which then equals the return value of `lastIndexOf`. This will make the test pass, even though `x` does not end with `y`.

To avoid this, explicitly check for the -1 case:


```javascript
function endsWith(x, y) {
  let index = x.lastIndexOf(y);
  return index !== -1 && index === x.length - y.length;
}

```

## References
* MDN: [String.prototype.endsWith](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/endsWith)
* MDN: [String.prototype.indexOf](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/indexOf)
* Common Weakness Enumeration: [CWE-20](https://cwe.mitre.org/data/definitions/20.html).
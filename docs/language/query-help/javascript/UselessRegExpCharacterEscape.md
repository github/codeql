# Useless regular-expression character escape

```
ID: js/useless-regexp-character-escape
Kind: problem
Severity: error
Precision: high
Tags: correctness security external/cwe/cwe-20

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-020/UselessRegExpCharacterEscape.ql)

When a character in a string literal or regular expression literal is preceded by a backslash, it is interpreted as part of an escape sequence. For example, the escape sequence `\n` in a string literal corresponds to a single `newline` character, and not the `\` and `n` characters. However, not all characters change meaning when used in an escape sequence. In this case, the backslash just makes the character appear to mean something else, and the backslash actually has no effect. For example, the escape sequence `\k` in a string literal just means `k`. Such superfluous escape sequences are usually benign, and do not change the behavior of the program.

The set of characters that change meaning when in escape sequences is different for regular expression literals and string literals. This can be problematic when a regular expression literal is turned into a regular expression that is built from one or more string literals. The problem occurs when a regular expression escape sequence loses its special meaning in a string literal.


## Recommendation
Ensure that the right amount of backslashes is used when escaping characters in strings, template literals and regular expressions. Pay special attention to the number of backslashes when rewriting a regular expression as a string literal.


## Example
The following example code checks that a string is `"my-marker"`, possibly surrounded by white space:


```javascript
let regex = new RegExp('(^\s*)my-marker(\s*$)'),
    isMyMarkerText = regex.test(text);

```
However, the check does not work properly for white space as the two `\s` occurrences are semantically equivalent to just `s`, meaning that the check will succeed for strings like `"smy-markers"` instead of `" my-marker "`. Address these shortcomings by either using a regular expression literal (`/(^\s*)my-marker(\s*$)/`), or by adding extra backslashes (`'(^\\s*)my-marker(\\s*$)'`).


## References
* MDN: [Regular expression escape notation](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions#Escaping)
* MDN: [String escape notation](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String#Escape_notation)
* Common Weakness Enumeration: [CWE-20](https://cwe.mitre.org/data/definitions/20.html).
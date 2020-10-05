# Polynomial regular expression used on uncontrolled data

```
ID: js/polynomial-redos
Kind: path-problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-730 external/cwe/cwe-400

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Performance/PolynomialReDoS.ql)

Some regular expressions take a long time to match certain input strings to the point where the time it takes to match a string of length *n* is proportional to *n<sup>k</sup>* or even *2<sup>n</sup>*. Such regular expressions can negatively affect performance, or even allow a malicious user to perform a Denial of Service ("DoS") attack by crafting an expensive input string for the regular expression to match.

The regular expression engines provided by many popular JavaScript platforms use backtracking non-deterministic finite automata to implement regular expression matching. While this approach is space-efficient and allows supporting advanced features like capture groups, it is not time-efficient in general. The worst-case time complexity of such an automaton can be polynomial or even exponential, meaning that for strings of a certain shape, increasing the input length by ten characters may make the automaton about 1000 times slower.

Typically, a regular expression is affected by this problem if it contains a repetition of the form `r*` or `r+` where the sub-expression `r` is ambiguous in the sense that it can match some string in multiple ways. More information about the precise circumstances can be found in the references.


## Recommendation
Modify the regular expression to remove the ambiguity, or ensure that the strings matched with the regular expression are short enough that the time-complexity does not matter.


## Example
Consider this use of a regular expression, which removes all leading and trailing whitespace in a string:

```javascript

			text.replace(/^\s+|\s+$/g, ''); // BAD
		
```
The sub-expression `"\s+$"` will match the whitespace characters in `text` from left to right, but it can start matching anywhere within a whitespace sequence. This is problematic for strings that do **not** end with a whitespace character. Such a string will force the regular expression engine to process each whitespace sequence once per whitespace character in the sequence.

This ultimately means that the time cost of trimming a string is quadratic in the length of the string. So a string like `"a b"` will take milliseconds to process, but a similar string with a million spaces instead of just one will take several minutes.

Avoid this problem by rewriting the regular expression to not contain the ambiguity about when to start matching whitespace sequences. For instance, by using a negative look-behind (`/^\s+|(?<!\s)\s+$/g`), or just by using the built-in trim method (`text.trim()`).

Note that the sub-expression `"^\s+"` is **not** problematic as the `^` anchor restricts when that sub-expression can start matching, and as the regular expression engine matches from left to right.


## Example
As a similar, but slightly subtler problem, consider the regular expression that matches lines with numbers, possibly written using scientific notation:

```javascript

			^0\.\d+E?\d+$ // BAD
		
```
The problem with this regular expression is in the sub-expression `\d+E?\d+` because the second `\d+` can start matching digits anywhere after the first match of the first `\d+` if there is no `E` in the input string.

This is problematic for strings that do **not** end with a digit. Such a string will force the regular expression engine to process each digit sequence once per digit in the sequence, again leading to a quadratic time complexity.

To make the processing faster, the regular expression should be rewritten such that the two `\d+` sub-expressions do not have overlapping matches: `^0\.\d+(E\d+)?$`.


## References
* OWASP: [Regular expression Denial of Service - ReDoS](https://www.owasp.org/index.php/Regular_expression_Denial_of_Service_-_ReDoS).
* Wikipedia: [ReDoS](https://en.wikipedia.org/wiki/ReDoS).
* Wikipedia: [Time complexity](https://en.wikipedia.org/wiki/Time_complexity).
* James Kirrage, Asiri Rathnayake, Hayo Thielecke: [Static Analysis for Regular Expression Denial-of-Service Attack](http://www.cs.bham.ac.uk/~hxt/research/reg-exp-sec.pdf).
* Common Weakness Enumeration: [CWE-730](https://cwe.mitre.org/data/definitions/730.html).
* Common Weakness Enumeration: [CWE-400](https://cwe.mitre.org/data/definitions/400.html).
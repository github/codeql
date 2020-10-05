# Inefficient regular expression

```
ID: js/redos
Kind: problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-730 external/cwe/cwe-400

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Performance/ReDoS.ql)

Some regular expressions take a long time to match certain input strings to the point where the time it takes to match a string of length *n* is proportional to *n<sup>k</sup>* or even *2<sup>n</sup>*. Such regular expressions can negatively affect performance, or even allow a malicious user to perform a Denial of Service ("DoS") attack by crafting an expensive input string for the regular expression to match.

The regular expression engines provided by many popular JavaScript platforms use backtracking non-deterministic finite automata to implement regular expression matching. While this approach is space-efficient and allows supporting advanced features like capture groups, it is not time-efficient in general. The worst-case time complexity of such an automaton can be polynomial or even exponential, meaning that for strings of a certain shape, increasing the input length by ten characters may make the automaton about 1000 times slower.

Typically, a regular expression is affected by this problem if it contains a repetition of the form `r*` or `r+` where the sub-expression `r` is ambiguous in the sense that it can match some string in multiple ways. More information about the precise circumstances can be found in the references.


## Recommendation
Modify the regular expression to remove the ambiguity, or ensure that the strings matched with the regular expression are short enough that the time-complexity does not matter.


## Example
Consider this regular expression:

```javascript

			/^_(__|.)+_$/
		
```
Its sub-expression `"(__|.)+?"` can match the string `"__"` either by the first alternative `"__"` to the left of the `"|"` operator, or by two repetitions of the second alternative `"."` to the right. Thus, a string consisting of an odd number of underscores followed by some other character will cause the regular expression engine to run for an exponential amount of time before rejecting the input.

This problem can be avoided by rewriting the regular expression to remove the ambiguity between the two branches of the alternative inside the repetition:

```javascript

			/^_(__|[^_])+_$/
		
```

## References
* OWASP: [Regular expression Denial of Service - ReDoS](https://www.owasp.org/index.php/Regular_expression_Denial_of_Service_-_ReDoS).
* Wikipedia: [ReDoS](https://en.wikipedia.org/wiki/ReDoS).
* Wikipedia: [Time complexity](https://en.wikipedia.org/wiki/Time_complexity).
* James Kirrage, Asiri Rathnayake, Hayo Thielecke: [Static Analysis for Regular Expression Denial-of-Service Attack](http://www.cs.bham.ac.uk/~hxt/research/reg-exp-sec.pdf).
* Common Weakness Enumeration: [CWE-730](https://cwe.mitre.org/data/definitions/730.html).
* Common Weakness Enumeration: [CWE-400](https://cwe.mitre.org/data/definitions/400.html).
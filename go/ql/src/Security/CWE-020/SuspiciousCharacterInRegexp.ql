/**
 * @name Suspicious characters in a regular expression
 * @description If a literal bell character or backspace appears in a regular expression, the start of text or word boundary may have been intended.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id go/suspicious-character-in-regex
 * @tags correctness
 *       security
 *       external/cwe/cwe-20
 */

import go

/**
 * Holds if `source` corresponds to a string literal that contains an escaped `character`.
 *
 * `character` must be `"a"` or `"b"`, the only interesting escapes for this query.
 */
predicate containsEscapedCharacter(DataFlow::Node source, string character) {
  character in ["a", "b"] and
  exists(StringLit s | s = source.asExpr() |
    // Search for `character` preceded by an odd number of backslashes:
    exists(s.getText().regexpFind("(?<=(^|[^\\\\])\\\\(\\\\{2}){0,10})" + character, _, _)) and
    not s.isRaw()
  )
}

module SuspiciousCharacterInRegexpConfig implements DataFlow::ConfigSig {
  additional predicate isSourceString(DataFlow::Node source, string report) {
    containsEscapedCharacter(source, "a") and
    report =
      "the bell character \\a; did you mean \\\\a, the Vim alphabetic character class (use [[:alpha:]] instead) or \\\\A, the beginning of text?"
    or
    containsEscapedCharacter(source, "b") and
    report = "a literal backspace \\b; did you mean \\\\b, a word boundary?"
  }

  predicate isSource(DataFlow::Node source) { isSourceString(source, _) }

  predicate isSink(DataFlow::Node sink) { sink instanceof RegexpPattern }
}

/**
 * Tracks data flow from strings containing suspicious escape sequences to a
 * use as a regular expression.
 */
module Flow = DataFlow::Global<SuspiciousCharacterInRegexpConfig>;

import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink, string report
where
  Flow::flowPath(source, sink) and
  SuspiciousCharacterInRegexpConfig::isSourceString(source.getNode(), report)
select source, source, sink, "This string literal that is $@ contains " + report, sink,
  "used as a regular expression"

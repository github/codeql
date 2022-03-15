/**
 * @name RegexpInsteadOfPattern
 * @description The `matches` builtin predicate takes a special pattern format as an input, not a regular expression.
 * @kind problem
 * @problem.severity warning
 * @id ql/rexexp-pattern
 * @precision medium
 */

import ql

/**
 * Gets a regular expression pattern that matches the syntax of likely regular expressions.
 */
private string getALikelyRegExpPattern() {
  result =
    [
      "/.*/[gimuy]{1,5}", // pattern with at least one flag: /foo/i
      "/\\^.*/[gimuy]{0,5}", // pattern with anchor: /^foo/
      "/.*\\$/[gimuy]{0,5}", // pattern with anchor: /foo$/
      "\\^.*\\$", // pattern body with anchors: ^foo$
      ".*(?<!\\\\)\\\\[dDwWsSB].*", // contains a builtin character class: \s
      ".*(?<!\\\\)\\\\[\\[\\]()*+?{}|^$.].*", // contains an escaped meta-character: \(
      ".*\\[\\^?[\\p{Alnum}\\p{Blank}_-]+\\][*+].*" // contains a quantified custom character class: [^a-zA-Z123]+
    ]
}

predicate isMatchesCall(MemberCall c) { c.getMemberName() = "matches" }

from Call c, String arg
where
  isMatchesCall(c) and
  c.getArgument(0) = arg and
  arg.getValue().regexpMatch(getALikelyRegExpPattern())
select c,
  "Argument \"$@\" looks like a reguar expression, but will be interpreted as a SQL 'LIKE' pattern.",
  arg, arg.getValue()

/**
 * @name Missing regular expression anchor
 * @description Regular expressions without anchors can be vulnerable to bypassing.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id go/regex/missing-regexp-anchor
 * @tags correctness
 *       security
 *       external/cwe/cwe-20
 */

import go

/**
 * Holds if `src` is a pattern for a collection of alternatives where
 * only the first or last alternative is anchored, indicating a
 * precedence mistake explained by `msg`.
 *
 * The canonical example of such a mistake is: `^a|b|c`, which is
 * parsed as `(^a)|(b)|(c)`.
 */
bindingset[re]
predicate isInterestingSemiAnchoredRegexpString(string re, string msg) {
  exists(string str, string maybeGroupedStr, string regex, string anchorPart, string escapedDot |
    // a dot that might be escaped in a regular expression, for example `regexp.Compile("\\.")`
    escapedDot = "\\\\[.]" and
    // a string that is mostly free from special reqular expression symbols
    str = "(?:(?:" + escapedDot + ")|[a-z:/.?_,@0-9 -])+" and
    // the string may be wrapped in parentheses
    maybeGroupedStr = "(?:" + str + "|\\(" + str + "\\))" and
    (
      // a problematic pattern: `^a|b|...|x`
      regex = "(?i)(\\^" + maybeGroupedStr + ")(?:\\|" + maybeGroupedStr + ")+"
      or
      // a problematic pattern: `a|b|...|x$`
      regex = "(?i)(?:" + maybeGroupedStr + "\\|)+(" + maybeGroupedStr + "\\$)"
    ) and
    anchorPart = re.regexpCapture(regex, 1) and
    anchorPart.regexpMatch("(?i).*[a-z].*") and
    msg =
      "Misleading operator precedence. The subexpression '" + anchorPart +
        "' is anchored, but the other parts of this regular expression are not."
  )
}

/**
 * Holds if `src` is an unanchored pattern for a URL, indicating a
 * mistake explained by `msg`.
 */
bindingset[re]
predicate isInterestingUnanchoredRegexpString(string re, string msg) {
  // a substring sequence of a protocol and subdomains, perhaps with some regex characters mixed in, followed by a known TLD
  re.regexpMatch("(?i)[():|?a-z0-9-\\\\./]+[.]" + commonTLD() + "([/#?():]\\S*)?") and
  // without any anchors
  not re.regexpMatch(".*(\\$|\\^|\\\\A|\\\\z).*") and
  msg =
    "When this is used as a regular expression on a URL, it may match anywhere, and arbitrary " +
      "hosts may come before or after it."
}

class Config extends DataFlow::Configuration {
  Config() { this = "MissingRegexpAnchor::Config" }

  predicate isSource(DataFlow::Node source, string msg) {
    exists(Expr e | e = source.asExpr() |
      isInterestingUnanchoredRegexpString(e.getStringValue(), msg)
      or
      isInterestingSemiAnchoredRegexpString(e.getStringValue(), msg)
    )
  }

  override predicate isSource(DataFlow::Node source) { isSource(source, _) }

  override predicate isSink(DataFlow::Node sink) { sink instanceof RegexpPattern }
}

from Config c, DataFlow::PathNode source, string msg
where c.hasFlowPath(source, _) and c.isSource(source.getNode(), msg)
select source.getNode(), msg

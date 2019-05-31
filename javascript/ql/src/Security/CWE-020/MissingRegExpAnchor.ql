/**
 * @name Missing regular expression anchor
 * @description Regular expressions without anchors can be vulnerable to bypassing.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id js/regex/missing-regexp-anchor
 * @tags correctness
 *       security
 *       external/cwe/cwe-20
 */

import javascript

/**
 * Holds if `src` is a pattern for a collection of alternatives where
 * only the first or last alternative is anchored, indicating a
 * precedence mistake explained by `msg`.
 *
 * The canonical example of such a mistake is: `^a|b|c`, which is
 * parsed as `(^a)|(b)|(c)`.
 */
predicate isAnInterestingSemiAnchoredRegExpString(RegExpPatternSource src, string msg) {
  exists(string str, string maybeGroupedStr, string regex, string anchorPart, string posString, string escapedDot |
    // a dot that might be escaped in a regular expression, for example `/\./` or new `RegExp('\\.')`
    escapedDot = "\\\\\\\\?[.]" and
    // a string that is mostly free from special reqular expression symbols
    str = "(?:(?:" + escapedDot + ")|[a-z:/.?_,@0-9 -])+" and
    // the string may be wrapped in parentheses
    maybeGroupedStr = "(?:" + str + "|\\(" + str + "\\))" and
    (
      // a problematic pattern: `^a|b|...|x`
      regex = "(?i)(\\^" + maybeGroupedStr + ")(?:\\|" + maybeGroupedStr + ")+" and
      posString = "beginning"
      or
      // a problematic pattern: `a|b|...|x$`
      regex = "(?i)(?:" + maybeGroupedStr + "\\|)+(" + maybeGroupedStr + "\\$)" and
      posString = "end"
    ) and
    anchorPart = src.getPattern().regexpCapture(regex, 1) and
    anchorPart.regexpMatch("(?i).*[a-z].*") and
    msg = "The alternative '" + anchorPart + "' uses an anchor to match from the " + posString +
        " of a string, but the other alternatives of this regular expression do not use anchors."
  )
}

/**
 * Holds if `src` is an unanchored pattern for a URL, indicating a
 * mistake explained by `msg`.
 */
predicate isAnInterestingUnanchoredRegExpString(RegExpPatternSource src, string msg) {
  exists(string pattern | pattern = src.getPattern() |
    // a substring sequence of a protocol and subdomains, perhaps with some regex characters mixed in, followed by a known TLD
    pattern
        .regexpMatch("(?i)[():|?a-z0-9-\\\\./]+[.]" + RegExpPatterns::commonTLD() +
            "([/#?():]\\S*)?") and
    // without any anchors
    pattern.regexpMatch("[^$^]+") and
    // that is not used for capture or replace
    not exists(DataFlow::MethodCallNode mcn, string name | name = mcn.getMethodName() |
      name = "exec" and
      mcn = src.getARegExpObject().getAMethodCall() and
      exists(mcn.getAPropertyRead())
      or
      exists(DataFlow::Node arg |
        arg = mcn.getArgument(0) and
        (
          src.getARegExpObject().flowsTo(arg) or
          src.(StringRegExpPatternSource).getAUse() = arg
        )
      |
        name = "replace"
        or
        name = "match" and exists(mcn.getAPropertyRead())
      )
    ) and
    msg = "When this is used as a regular expression on a URL, it may match anywhere, and arbitrary hosts may come before or after it."
  )
}

from DataFlow::Node nd, string msg
where
  isAnInterestingUnanchoredRegExpString(nd, msg)
  or
  isAnInterestingSemiAnchoredRegExpString(nd, msg)
select nd, msg

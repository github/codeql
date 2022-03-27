/**
 * @name Missing regular expression anchor
 * @description Regular expressions without anchors can be vulnerable to bypassing.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision medium
 * @id rb/regex/missing-regexp-anchor
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 */

import HostnameRegexpShared
import codeql.ruby.DataFlow
import codeql.ruby.security.performance.RegExpTreeView

/**
 * Holds if `term` is a final term, that is, no term will match anything after this one.
 */
predicate isFinalRegExpTerm(RegExpTerm term) {
  term.isRootTerm()
  or
  exists(RegExpSequence seq |
    isFinalRegExpTerm(seq) and
    term = seq.getLastChild()
  )
  or
  exists(RegExpTerm parent |
    isFinalRegExpTerm(parent) and
    term = parent.getAChild() and
    not parent instanceof RegExpSequence and
    not parent instanceof RegExpQuantifier
  )
}

/**
 * Holds if `src` contains a hostname pattern that uses the `^/$` line anchors
 * rather than `\A/\z` which match the start/end of the whole string.
 */
predicate isLineAnchoredHostnameRegExp(RegExpPatternSource src, string msg) {
  not isSemiAnchoredHostnameRegExp(src, msg) and // avoid double reporting
  exists(RegExpTerm term, RegExpSequence tld, int i | term = src.getRegExpTerm() |
    not isConstantInvalidInsideOrigin(term.getAChild*()) and
    tld = term.getAChild*() and
    hasTopLevelDomainEnding(tld, i) and
    isFinalRegExpTerm(tld.getChild(i)) and // nothing is matched after the TLD
    (
      tld.getChild(0).(RegExpCaret).getChar() = "^" or
      tld.getLastChild().(RegExpDollar).getChar() = "$"
    ) and
    msg =
      "This hostname pattern uses anchors such as '^' and '$', which match the start and end of a line, not the whole string. Use '\\A' and '\\z' instead."
  )
}

/**
 * Holds if `src` contains a hostname pattern that is missing a `$` anchor.
 */
predicate isSemiAnchoredHostnameRegExp(RegExpPatternSource src, string msg) {
  // not hasMisleadingAnchorPrecedence(src, _) and // avoid double reporting
  exists(RegExpTerm term, RegExpSequence tld, int i | term = src.getRegExpTerm() |
    not isConstantInvalidInsideOrigin(term.getAChild*()) and
    tld = term.getAChild*() and
    hasTopLevelDomainEnding(tld, i) and
    isFinalRegExpTerm(tld.getChild(i)) and // nothing is matched after the TLD
    tld.getChild(0) instanceof RegExpCaret and
    msg =
      "This hostname pattern may match any domain name, as it is missing a '\\z' or '/' at the end."
  )
}

/**
 * Holds if `src` is an unanchored pattern for a URL, indicating a
 * mistake explained by `msg`.
 */
predicate isUnanchoredHostnameRegExp(RegExpPatternSource src, string msg) {
  exists(RegExpTerm term, RegExpSequence tld | term = src.getRegExpTerm() |
    alwaysMatchesHostname(term) and
    tld = term.getAChild*() and
    hasTopLevelDomainEnding(tld) and
    not isConstantInvalidInsideOrigin(term.getAChild*()) and
    not term.getAChild*() instanceof RegExpAnchor and
    // that is not used for capture or replace
    not exists(DataFlow::CallNode mcn, DataFlow::Node arg, string name |
      name = mcn.getMethodName() and
      arg = mcn.getArgument(0)
    |
      (
        src.getAParse().(DataFlow::LocalSourceNode).flowsTo(arg) or
        src.getAParse() = arg
      ) and
      name = ["sub", "sub!", "gsub", "gsub!"]
    ) and
    msg =
      "When this is used as a regular expression on a URL, it may match anywhere, and arbitrary hosts may come before or after it."
  )
}

from DataFlow::Node nd, string msg
where
  isUnanchoredHostnameRegExp(nd, msg) or
  isSemiAnchoredHostnameRegExp(nd, msg) or
  isLineAnchoredHostnameRegExp(nd, msg)
select nd, msg

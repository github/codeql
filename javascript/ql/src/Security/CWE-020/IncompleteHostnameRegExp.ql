/**
 * @name Incomplete regular expression for hostnames
 * @description Matching a URL or hostname against a regular expression that contains an unescaped dot as part of the hostname might match more hostnames than expected.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/incomplete-hostname-regexp
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 */

import javascript
import semmle.javascript.CharacterEscapes
import HostnameRegexpShared

/**
 * Holds if `term` occurs inside a quantifier or alternative (and thus
 * can not be expected to correspond to a unique match), or as part of
 * a lookaround assertion (which are rarely used for capture groups).
 */
predicate isInsideChoiceOrSubPattern(RegExpTerm term) {
  exists(RegExpParent parent | parent = term.getParent() |
    parent instanceof RegExpAlt
    or
    parent instanceof RegExpQuantifier
    or
    parent instanceof RegExpSubPattern
    or
    isInsideChoiceOrSubPattern(parent)
  )
}

/**
 * Holds if `group` is likely to be used as a capture group.
 */
predicate isLikelyCaptureGroup(RegExpGroup group) {
  group.isCapture() and
  not isInsideChoiceOrSubPattern(group)
}

/**
 * Holds if `seq` contains two consecutive dots `..` or escaped dots.
 *
 * At least one of these dots is not intended to be a subdomain separator,
 * so we avoid flagging the pattern in this case.
 */
predicate hasConsecutiveDots(RegExpSequence seq) {
  exists(int i |
    isDotLike(seq.getChild(i)) and
    isDotLike(seq.getChild(i + 1))
  )
}

predicate isIncompleteHostNameRegExpPattern(RegExpTerm regexp, RegExpSequence seq, string msg) {
  seq = regexp.getAChild*() and
  exists(RegExpDot unescapedDot, int i, string hostname |
    hasTopLevelDomainEnding(seq, i) and
    not isConstantInvalidInsideOrigin(seq.getChild([0 .. i - 1]).getAChild*()) and
    not isLikelyCaptureGroup(seq.getChild([i .. seq.getNumChild() - 1]).getAChild*()) and
    unescapedDot = seq.getChild([0 .. i - 1]).getAChild*() and
    unescapedDot != seq.getChild(i - 1) and // Should not be the '.' immediately before the TLD
    not hasConsecutiveDots(unescapedDot.getParent()) and
    hostname =
      seq.getChild(i - 2).getRawValue() + seq.getChild(i - 1).getRawValue() +
        seq.getChild(i).getRawValue()
  |
    if unescapedDot.getParent() instanceof RegExpQuantifier
    then
      // `.*\.example.com` can match `evil.com/?x=.example.com`
      //
      // This problem only occurs when the pattern is applied against a full URL, not just a hostname/origin.
      // We therefore check if the pattern includes a suffix after the TLD, such as `.*\.example.com/`.
      // Note that a post-anchored pattern (`.*\.example.com$`) will usually fail to match a full URL,
      // and patterns with neither a suffix nor an anchor fall under the purview of MissingRegExpAnchor.
      seq.getChild(0) instanceof RegExpCaret and
      not seq.getAChild() instanceof RegExpDollar and
      seq.getChild([i .. i + 1]).(RegExpConstant).getValue().regexpMatch(".*[/?#].*") and
      msg =
        "has an unrestricted wildcard '" + unescapedDot.getParent().(RegExpQuantifier).getRawValue()
          + "' which may cause '" + hostname +
          "' to be matched anywhere in the URL, outside the hostname."
    else
      msg =
        "has an unescaped '.' before '" + hostname +
          "', so it might match more hosts than expected."
  )
}

from
  RegExpPatternSource re, RegExpTerm regexp, RegExpSequence hostSequence, string msg, string kind,
  DataFlow::Node aux
where
  regexp = re.getRegExpTerm() and
  isIncompleteHostNameRegExpPattern(regexp, hostSequence, msg) and
  (
    if re.getAParse() != re
    then (
      kind = "string, which is used as a regular expression $@," and
      aux = re.getAParse()
    ) else (
      kind = "regular expression" and aux = re
    )
  ) and
  not CharacterEscapes::hasALikelyRegExpPatternMistake(re)
select hostSequence, "This " + kind + " " + msg, aux, "here"

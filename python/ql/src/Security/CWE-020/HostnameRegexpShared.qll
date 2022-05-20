/**
 * Provides predicates for reasoning about regular expressions
 * that match URLs and hostname patterns.
 */

private import HostnameRegexpSpecific

/**
 * Holds if the given constant is unlikely to occur in the origin part of a URL.
 */
predicate isConstantInvalidInsideOrigin(RegExpConstant term) {
  // Look for any of these cases:
  // - A character that can't occur in the origin
  // - Two dashes in a row
  // - A colon that is not part of port or scheme separator
  // - A slash that is not part of scheme separator
  term.getValue().regexpMatch(".*(?:[^a-zA-Z0-9.:/-]|--|:[^0-9/]|(?<![/:]|^)/).*")
}

/** Holds if `term` is a dot constant of form `\.` or `[.]`. */
predicate isDotConstant(RegExpTerm term) {
  term.(RegExpCharEscape).getValue() = "."
  or
  exists(RegExpCharacterClass cls |
    term = cls and
    not cls.isInverted() and
    cls.getNumChild() = 1 and
    cls.getAChild().(RegExpConstant).getValue() = "."
  )
}

/** Holds if `term` is a wildcard `.` or an actual `.` character. */
predicate isDotLike(RegExpTerm term) {
  term instanceof RegExpDot
  or
  isDotConstant(term)
}

/** Holds if `term` will only ever be matched against the beginning of the input. */
predicate matchesBeginningOfString(RegExpTerm term) {
  term.isRootTerm()
  or
  exists(RegExpTerm parent | matchesBeginningOfString(parent) |
    term = parent.(RegExpSequence).getChild(0)
    or
    parent.(RegExpSequence).getChild(0) instanceof RegExpCaret and
    term = parent.(RegExpSequence).getChild(1)
    or
    term = parent.(RegExpAlt).getAChild()
    or
    term = parent.(RegExpGroup).getAChild()
  )
}

/**
 * Holds if the given sequence contains top-level domain preceded by a dot, such as `.com`,
 * excluding cases where this is at the very beginning of the regexp.
 *
 * `i` is bound to the index of the last child in the top-level domain part.
 */
predicate hasTopLevelDomainEnding(RegExpSequence seq, int i) {
  seq.getChild(i)
      .(RegExpConstant)
      .getValue()
      .regexpMatch("(?i)" + RegExpPatterns::getACommonTld() + "(:\\d+)?([/?#].*)?") and
  isDotLike(seq.getChild(i - 1)) and
  not (i = 1 and matchesBeginningOfString(seq))
}

/**
 * Holds if the given regular expression term contains top-level domain preceded by a dot,
 * such as `.com`.
 */
predicate hasTopLevelDomainEnding(RegExpSequence seq) { hasTopLevelDomainEnding(seq, _) }

/**
 * Holds if `term` will always match a hostname, that is, all disjunctions contain
 * a hostname pattern that isn't inside a quantifier.
 */
predicate alwaysMatchesHostname(RegExpTerm term) {
  hasTopLevelDomainEnding(term, _)
  or
  // `localhost` is considered a hostname pattern, but has no TLD
  term.(RegExpConstant).getValue().regexpMatch("\\blocalhost\\b")
  or
  not term instanceof RegExpAlt and
  not term instanceof RegExpQuantifier and
  alwaysMatchesHostname(term.getAChild())
  or
  alwaysMatchesHostnameAlt(term)
}

/** Holds if every child of `alt` contains a hostname pattern. */
predicate alwaysMatchesHostnameAlt(RegExpAlt alt) {
  alwaysMatchesHostnameAlt(alt, alt.getNumChild() - 1)
}

/**
 * Holds if the first `i` children of `alt` contains a hostname pattern.
 *
 * This is used instead of `forall` to avoid materializing the set of alternatives
 * that don't contains hostnames, which is much larger.
 */
predicate alwaysMatchesHostnameAlt(RegExpAlt alt, int i) {
  alwaysMatchesHostname(alt.getChild(0)) and i = 0
  or
  alwaysMatchesHostnameAlt(alt, i - 1) and
  alwaysMatchesHostname(alt.getChild(i))
}

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

predicate incompleteHostnameRegExp(
  RegExpSequence hostSequence, string message, DataFlow::Node aux, string label
) {
  exists(RegExpPatternSource re, RegExpTerm regexp, string msg, string kind |
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
    )
  |
    message = "This " + kind + " " + msg and label = "here"
  )
}

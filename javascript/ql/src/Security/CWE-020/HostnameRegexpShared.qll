/**
 * Provides predicates for reasoning about regular expressions
 * that match URLs and hostname patterns.
 */

import javascript

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
  seq
      .getChild(i)
      .(RegExpConstant)
      .getValue()
      .regexpMatch("(?i)" + RegExpPatterns::commonTLD() + "(:\\d+)?([/?#].*)?") and
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

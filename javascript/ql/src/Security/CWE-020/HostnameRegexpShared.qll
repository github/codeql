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

/**
 * Holds if the given sequence contains top-level domain preceded by a dot, such as `.com`.
 *
 * `i` is bound to the index of the last child in the top-level domain part.
 */
predicate hasTopLevelDomainEnding(RegExpSequence seq, int i) {
  seq.getChild(i).(RegExpConstant).getValue().regexpMatch("(?i)" + RegExpPatterns::commonTLD() + "(:\\d+)?([/?#].*)?") and
  isDotLike(seq.getChild(i - 1))
}

/**
 * Holds if the given regular expression term contains top-level domain preceded by a dot,
 * such as `.com`.
 */
predicate hasTopLevelDomainEnding(RegExpSequence seq) {
  hasTopLevelDomainEnding(seq, _)
}

/**
 * Provides classes for working with regular expressions that can
 * perform backtracking in superlinear time.
 */

import javascript

/**
 * A regular expression term that permits unlimited repetitions.
 */
private class InfiniteRepetitionQuantifier extends RegExpQuantifier {
  InfiniteRepetitionQuantifier() {
    this instanceof RegExpPlus
    or
    this instanceof RegExpStar
    or
    this instanceof RegExpRange and not exists(this.(RegExpRange).getUpperBound())
  }
}

/**
 * Holds if `t` matches at least an epsilon symbol.
 *
 * That is, this term does not restrict the language of the enclosing regular expression.
 *
 * This is implemented as an under-approximation, and this predicate does not hold for sub-patterns in particular.
 */
private predicate matchesEpsilon(RegExpTerm t) {
  t instanceof RegExpStar
  or
  t instanceof RegExpOpt
  or
  t.(RegExpRange).getLowerBound() = 0
  or
  exists(RegExpTerm child |
    child = t.getAChild() and
    matchesEpsilon(child)
  |
    t instanceof RegExpAlt or
    t instanceof RegExpGroup or
    t instanceof RegExpPlus or
    t instanceof RegExpRange
  )
  or
  matchesEpsilon(t.(RegExpBackRef).getGroup())
  or
  forex(RegExpTerm child | child = t.(RegExpSequence).getAChild() | matchesEpsilon(child))
}

/**
 * Gets a term that matches the symbol immediately before `t` is done matching.
 *
 * Examples:
 *
 * - For `d` in `abc?de` this gets `b`, `c`, `c?` (in addition to `d`).
 * - For `(bc|de)` in `a(bc|de)f` this gets `c` and `e` (in addition to `bc|de` and `(bc|de)`).
 */
private RegExpTerm getAMatchPredecessor(RegExpTerm t) {
  result = t
  or
  exists(RegExpTerm recurse | result = getAMatchPredecessor(recurse) |
    // wrappers depend on their children
    recurse = t.getAChild() and
    (
      t instanceof RegExpAlt
      or
      t instanceof RegExpGroup
      or
      t instanceof RegExpQuantifier
    )
    or
    recurse = t.(RegExpSequence).getLastChild()
    or
    recurse = t.(RegExpBackRef).getGroup()
    or
    // recurse past epsilon terms
    matchesEpsilon(t) and recurse = t.getPredecessor()
  )
}

private RegExpCharacterClassEscape unwrapCharacterClassEscape(RegExpTerm t) {
  t = result or
  t.(RegExpCharacterClass).getAChild() = result
}

pragma[inline]
private predicate compatibleConstants(RegExpTerm t1, RegExpTerm t2) {
  exists(string s1, string s2 |
    s1 = t1.getAMatchedString() and s2 = t2.getAMatchedString()
    or
    unwrapCharacterClassEscape(t1).getValue() = s1 and
    unwrapCharacterClassEscape(t2).getValue() = s2
  |
    s1 = s2
  )
}

/**
 * Holds if `s1` and `s2` possibly have a non-empty intersection.
 *
 * This is a simple, and under-approximate, version of
 * ReDoS::compatible/2, as this predicate only handles some character
 * classes and constant values.
 */
pragma[inline]
private predicate compatible(RegExpTerm s1, RegExpTerm s2) {
  not s1.(RegExpCharacterClass).isInverted() and
  not s2.(RegExpCharacterClass).isInverted() and
  compatibleConstants(s1, s2)
}

/**
 * A term that may cause a regular expression engine to perform a
 * polynomial number of match attempts, relative to the input length.
 */
class PolynomialBackTrackingTerm extends InfiniteRepetitionQuantifier {
  string reason;

  PolynomialBackTrackingTerm() {
    // the regexp may fail to match ...
    exists(RegExpTerm succ | this.getSuccessor+() = succ | not matchesEpsilon(succ)) and
    (
      // ... and while failing, it will try to start matching at all positions of a long string
      forall(RegExpTerm pred | pred = this.getPredecessor+() | matchesEpsilon(pred)) and
      reason = "it can start matching anywhere"
      or
      exists(RegExpTerm pred |
        pred instanceof InfiniteRepetitionQuantifier
        or
        forall(RegExpTerm predpred | predpred = pred.getPredecessor+() | matchesEpsilon(predpred))
      |
        pred = getAMatchPredecessor(this.getPredecessor()) and
        (
          // compatible children
          compatible(pred.getAChild(), this.getAChild())
          or
          // or `this` is compatible with everything (and the predecessor is something)
          unique( | | this.getAChild()) instanceof RegExpDot and
          exists([pred, pred.getAChild()].getAMatchedString())
        ) and
        reason =
          "it can start matching anywhere after the start of the preceeding '" + pred.toString() +
            "'"
      )
    ) and
    not this.getParent*() instanceof RegExpSubPattern // too many corner cases
  }

  /**
   * Holds if all non-empty successors to the polynomial backtracking term matches the end of the line.
   */
  predicate isAtEndLine() {
    forall(RegExpTerm succ | this.getSuccessor+() = succ and not matchesEpsilon(succ) |
      succ instanceof RegExpDollar
    )
  }

  /**
   * Gets the reason for the number of match attempts.
   */
  string getReason() { result = reason }
}

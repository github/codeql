/**
 * @name Regular expression always matches
 * @description Regular expression tests that always find a match indicate dead code or a logic error
 * @kind problem
 * @problem.severity warning
 * @id js/regex/always-matches
 * @tags correctness
 *       regular-expressions
 * @precision high
 */

import javascript

/**
 * Gets a node reachable from the given root term through alts and groups only.
 *
 * For example, for `/(foo|bar)/` this gets `(foo|bar)`, `foo|bar`, `foo` and `bar`.
 */
RegExpTerm getEffectiveRootAux(RegExpTerm actualRoot) {
  actualRoot.isRootTerm() and
  result = actualRoot
  or
  result = getEffectiveRootAux(actualRoot).(RegExpAlt).getAChild()
  or
  result = getEffectiveRootAux(actualRoot).(RegExpGroup).getAChild()
}

/**
 * Gets the effective root of the given term.
 *
 * For example, for `/(foo|bar)/` this gets `foo` and `bar`.
 */
RegExpTerm getEffectiveRoot(RegExpTerm actualRoot) {
  result = getEffectiveRootAux(actualRoot) and
  not result instanceof RegExpAlt and
  not result instanceof RegExpGroup
}

/**
 * Holds if `term` contains an anchor on both ends.
 */
predicate isPossiblyAnchoredOnBothEnds(RegExpSequence term) {
  term.getAChild*() instanceof RegExpCaret and
  term.getAChild*() instanceof RegExpDollar and
  term.getNumChild() >= 2
}

/**
 * Holds if `term` is obviously intended to match any string.
 */
predicate isUniversalRegExp(RegExpTerm term) {
  exists(RegExpTerm child | child = term.(RegExpStar).getAChild() |
    child instanceof RegExpDot
    or
    child.(RegExpCharacterClass).isUniversalClass()
  )
  or
  term.(RegExpSequence).getNumChild() = 0
}

/**
 * A call that searches for a regexp match within a string, but does not
 * extract the capture groups or the matched string itself.
 *
 * Because of the longest-match rule, queries that are more than pure tests
 * aren't necessarily broken just because the regexp can accept the empty string.
 */
abstract class RegExpQuery extends DataFlow::CallNode {
  abstract RegExpTerm getRegExp();
}

/**
 * A call to `RegExp.prototype.test`.
 */
class RegExpTestCall extends DataFlow::MethodCallNode, RegExpQuery {
  DataFlow::RegExpCreationNode regexp;

  RegExpTestCall() { this = regexp.getAReference().getAMethodCall("test") }

  override RegExpTerm getRegExp() { result = regexp.getRoot() }
}

/**
 * A call to `String.prototype.search`.
 */
class RegExpSearchCall extends DataFlow::MethodCallNode, RegExpQuery {
  DataFlow::RegExpCreationNode regexp;

  RegExpSearchCall() {
    this.getMethodName() = "search" and
    regexp.getAReference().flowsTo(this.getArgument(0))
  }

  override RegExpTerm getRegExp() { result = regexp.getRoot() }
}

/**
 * Holds if `t` is a zero-width assertion other than an anchor.
 */
predicate isAssertion(RegExpTerm t) {
  t instanceof RegExpSubPattern or
  t instanceof RegExpWordBoundary or
  t instanceof RegExpNonWordBoundary
}

from RegExpTerm term, RegExpQuery call, string message
where
  term.isNullable() and
  not isAssertion(term.getAChild*()) and
  not isUniversalRegExp(term) and
  term = getEffectiveRoot(call.getRegExp()) and
  (
    call instanceof RegExpTestCall and
    not isPossiblyAnchoredOnBothEnds(term) and
    message =
      "This regular expression always matches when used in a test $@, as it can match an empty substring."
    or
    call instanceof RegExpSearchCall and
    not term.getAChild*() instanceof RegExpDollar and
    message =
      "This regular expression always matches at index 0 when used $@, as it matches the empty substring."
  )
select term, message, call, "here"

##" * perform backtracking in superlinear/exponential time.
##" *
##" * This module contains a number of utility predicates for compiling a regular expression into a NFA and reasoning about this NFA.
 *
 * The `ReDoSConfiguration` contains a `isReDoSCandidate` predicate that is used to
 * to determine which states the prefix/suffix search should happen on.
 * There is only meant to exist one `ReDoSConfiguration` at a time.
 *
 * The predicate `hasReDoSResult` outputs a de-duplicated set of
 * states that will cause backtracking (a rejecting suffix exists).
 */
import RegExpTreeView
/**
 * A configuration for which parts of a regular expression should be considered relevant for
 * the different predicates in `ReDoS.qll`.
 * Used to adjust the computations for either superlinear or exponential backtracking.
 */
abstract class ReDoSConfiguration extends string {
  bindingset[this]
  ReDoSConfiguration() { any() }
  /**
   * Holds if `state` with the pump string `pump` is a candidate for a
   * ReDoS vulnerable state.
   * This is used to determine which states are considered for the prefix/suffix construction.
   */
  abstract predicate isReDoSCandidate(State state, string pump);
}
/**
 * Holds if repeating `pump' starting at `state` is a candidate for causing backtracking.
 * No check whether a rejected suffix exists has been made.
 */
private predicate isReDoSCandidate(State state, string pump) {
  any(ReDoSConfiguration conf).isReDoSCandidate(state, pump) and
  (
    not any(ReDoSConfiguration conf).isReDoSCandidate(epsilonSucc+(state), _)
    or
    epsilonSucc+(state) = state and
    state =
      max(State s, Location l |
        s = epsilonSucc+(state) and
        l = s.getRepr().getLocation() and
        any(ReDoSConfiguration conf).isReDoSCandidate(s, _) and
        s.getRepr() instanceof InfiniteRepetitionQuantifier
      |
        s order by l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine()
      )
  )
}
/**
 * Gets the char after `c` (from a simplified ASCII table).
 */
private string nextChar(string c) { exists(int code | code = ascii(c) | code + 1 = ascii(result)) }
/**
 * Gets an approximation for the ASCII code for `char`.
 * Only the easily printable chars are included (so no newline, tab, null, etc).
 */
private int ascii(string char) {

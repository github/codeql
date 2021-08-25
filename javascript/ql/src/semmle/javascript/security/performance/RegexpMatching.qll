/**
 * EXPERIMENTAL. This API may change in the future.
 *
 * Provides classes for testing whether a given regular expression matches a given input string.
 */

import javascript
import ReDoSUtil

/**
 * A class to test whether a regular expression matches a string.
 * Override this class and extend `toTest` to configure which strings should be tested for acceptance by this regular expression.
 * The result can afterwards be read from the `matches` predicate.
 */
abstract class MatchedRegExp extends DataFlow::RegExpCreationNode {
  /**
   * Holds if it should be tested whether this regular expression matches `str`.
   *
   * If `ignorePrefix` is true, then a regexp without a start anchor will be treated as if it had a start anchor.
   * E.g. a regular expression `/foo$/` will match any string that ends with "foo",
   * but if `ignorePrefix` is true, it will only match "foo".
   */
  abstract predicate toTest(string str, boolean ignorePrefix);

  /**
   * Gets a state a regular expression is in after matching the `i`th char in `str`.
   * The regular expression is modelled as a non-determistic finite automaton,
   * the regular expression can therefore be in multiple states after matching a character.
   */
  private State getAState(int i, string str, boolean ignorePrefix) {
    i = -1 and
    this.toTest(str, ignorePrefix) and
    result.getRepr().getRootTerm() = this.getRoot() and
    isStartState(result)
    or
    exists(State prev |
      prev = getAState(i - 1, str, ignorePrefix) and
      deltaClosed(prev, getAnInputSymbolMatching(str.charAt(i)), result) and
      not (
        ignorePrefix = true and
        isStartState(prev) and
        isStartState(result)
      )
    )
  }

  /**
   * Holds if `regexp` matches `str`.
   */
  predicate matches(string str) {
    exists(State state | state = getAState(str.length() - 1, str, _) |
      epsilonSucc*(state) = Accept(_)
    )
  }
}

/**
 * Holds if `state` is a start state.
 */
private predicate isStartState(State state) {
  state = mkMatch(any(RegExpRoot r)) and
  not exists(RegExpCaret car | car.getRootTerm() = state.getRepr().getRootTerm())
  or
  exists(RegExpCaret car | state = after(car))
}

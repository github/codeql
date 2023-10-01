/**
 * Provides predicates for reasoning about which strings are matched by a regular expression,
 * and for testing which capture groups are filled when a particular regexp matches a string.
 */

private import NfaUtils as NfaUtils
private import codeql.regex.RegexTreeView

/**
 * A parameterized module implementing the analysis described in the above papers.
 */
module Make<RegexTreeViewSig TreeImpl> {
  private import TreeImpl
  import NfaUtils::Make<TreeImpl>

  final private class FinalRegExpTerm = RegExpTerm;

  /** A root term */
  final class RootTerm extends FinalRegExpTerm {
    RootTerm() { this.isRootTerm() }
  }

  /**
   * Holds if it should be tested whether `root` matches `str`.
   *
   * If `ignorePrefix` is true, then a regexp without a start anchor will be treated as if it had a start anchor.
   * E.g. a regular expression `/foo$/` will match any string that ends with "foo",
   * but if `ignorePrefix` is true, it will only match "foo".
   *
   * If `testWithGroups` is true, then the `RegexpMatching::fillsCaptureGroup` predicate can be used to determine which capture
   * groups are filled by a string.
   */
  signature predicate isRegexpMatchingCandidateSig(
    RootTerm root, string str, boolean ignorePrefix, boolean testWithGroups
  );

  /**
   * A module for determining if a regexp matches a given string,
   * and reasoning about which capture groups are filled by a given string.
   *
   * The module parameter `isCandidate` determines which strings should be tested,
   * and the results can be read from the `matches` and `fillsCaptureGroup` predicates.
   */
  module RegexpMatching<isRegexpMatchingCandidateSig/4 isCandidate> {
    /**
     * Gets a state the regular expression `reg` can be in after matching the `i`th char in `str`.
     * The regular expression is modeled as a non-determistic finite automaton,
     * the regular expression can therefore be in multiple states after matching a character.
     *
     * It's a forward search to all possible states, and there is thus no guarantee that the state is on a path to an accepting state.
     */
    private State getAState(RootTerm reg, int i, string str, boolean ignorePrefix) {
      // start state, the -1 position before any chars have been matched
      i = -1 and
      isCandidate(reg, str, ignorePrefix, _) and
      result.getRepr().getRootTerm() = reg and
      isStartState(result)
      or
      // recursive case
      result = getAStateAfterMatching(reg, _, str, i, _, ignorePrefix)
    }

    /**
     * Gets the next state after the `prev` state from `reg`.
     * `prev` is the state after matching `fromIndex` chars in `str`,
     * and the result is the state after matching `toIndex` chars in `str`.
     *
     * This predicate is used as a step relation in the forwards search (`getAState`),
     * and also as a step relation in the later backwards search (`getAStateThatReachesAccept`).
     */
    private State getAStateAfterMatching(
      RootTerm reg, State prev, string str, int toIndex, int fromIndex, boolean ignorePrefix
    ) {
      // the basic recursive case - outlined into a noopt helper to make performance work out.
      result = getAStateAfterMatchingAux(reg, prev, str, toIndex, fromIndex, ignorePrefix)
      or
      // we can skip past word boundaries if the next char is a non-word char.
      fromIndex = toIndex and
      prev.getRepr() instanceof RegExpWordBoundary and
      prev = getAState(reg, toIndex, str, ignorePrefix) and
      after(prev.getRepr()) = result and
      str.charAt(toIndex + 1).regexpMatch("\\W") // \W matches any non-word char.
    }

    pragma[noopt]
    private State getAStateAfterMatchingAux(
      RootTerm reg, State prev, string str, int toIndex, int fromIndex, boolean ignorePrefix
    ) {
      prev = getAState(reg, fromIndex, str, ignorePrefix) and
      fromIndex = toIndex - 1 and
      exists(string char | char = str.charAt(toIndex) | specializedDeltaClosed(prev, char, result)) and
      not discardedPrefixStep(prev, result, ignorePrefix)
    }

    /** Holds if a step from `prev` to `next` should be discarded when the `ignorePrefix` flag is set. */
    private predicate discardedPrefixStep(State prev, State next, boolean ignorePrefix) {
      prev = mkMatch(any(RegExpRoot r)) and
      ignorePrefix = true and
      next = prev
    }

    // The `deltaClosed` relation specialized to the chars that exists in strings tested by a `MatchedRegExp`.
    private predicate specializedDeltaClosed(State prev, string char, State next) {
      deltaClosed(prev, specializedGetAnInputSymbolMatching(char), next)
    }

    // The `getAnInputSymbolMatching` relation specialized to the chars that exists in strings tested by a `MatchedRegExp`.
    pragma[noinline]
    private InputSymbol specializedGetAnInputSymbolMatching(string char) {
      exists(string s | isCandidate(_, s, _, _) | char = s.charAt(_)) and
      result = getAnInputSymbolMatching(char)
    }

    /**
     * Gets the `i`th state on a path to the accepting state when `reg` matches `str`.
     * Starts with an accepting state as found by `getAState` and searches backwards
     * to the start state through the reachable states (as found by `getAState`).
     *
     * This predicate satisfies the invariant that the result state can be reached with `i` steps from a start state,
     * and an accepting state can be found after (`str.length() - 1 - i`) steps from the result.
     * The result state is therefore always on a valid path where `reg` accepts `str`.
     *
     * This predicate is only used to find which capture groups a regular expression has filled,
     * and thus the search is only performed for the strings in the `testWithGroups(..)` predicate.
     */
    private State getAStateThatReachesAccept(RootTerm reg, int i, string str, boolean ignorePrefix) {
      // base case, reaches an accepting state from the last state in `getAState(..)`
      isCandidate(reg, str, ignorePrefix, true) and
      i = str.length() - 1 and
      result = getAState(reg, i, str, ignorePrefix) and
      epsilonSucc*(result) = Accept(_)
      or
      // recursive case. `next` is the next state to be matched after matching `prev`.
      // this predicate is doing a backwards search, so `prev` is the result we are looking for.
      exists(State next, State prev, int fromIndex, int toIndex |
        next = getAStateThatReachesAccept(reg, toIndex, str, ignorePrefix) and
        next = getAStateAfterMatching(reg, prev, str, toIndex, fromIndex, ignorePrefix) and
        i = fromIndex and
        result = prev
      )
    }

    /** Gets the capture group number that `term` belongs to. */
    private int group(RegExpTerm term) {
      exists(RegExpGroup grp | grp.getNumber() = result | term.getParent*() = grp)
    }

    /**
     * Holds if `reg` matches `str`, where `str` is in the `isCandidate` predicate.
     */
    predicate matches(RootTerm reg, string str) {
      exists(State state | state = getAState(reg, str.length() - 1, str, _) |
        epsilonSucc*(state) = Accept(_)
      )
    }

    /**
     * Holds if matching `str` against `reg` may fill capture group number `g`.
     * Only holds if `str` is in the `testWithGroups` predicate.
     */
    predicate fillsCaptureGroup(RootTerm reg, string str, int g) {
      exists(State s |
        s = getAStateThatReachesAccept(reg, _, str, _) and
        g = group(s.getRepr())
      )
    }
  }
}

/**
 * This library implements the analysis described in the following two papers:
 *
 *   James Kirrage, Asiri Rathnayake, Hayo Thielecke: Static Analysis for
 *     Regular Expression Denial-of-Service Attacks. NSS 2013.
 *     (https://arxiv.org/abs/1301.0849)
 *   Asiri Rathnayake, Hayo Thielecke: Static Analysis for Regular Expression
 *     Exponential Runtime via Substructural Logics. 2014.
 *     (https://www.cs.bham.ac.uk/~hxt/research/redos_full.pdf)
 *
 * The basic idea is to search for overlapping cycles in the NFA, that is,
 * states `q` such that there are two distinct paths from `q` to itself
 * that consume the same word `w`.
 *
 * For any such state `q`, an attack string can be constructed as follows:
 * concatenate a prefix `v` that takes the NFA to `q` with `n` copies of
 * the word `w` that leads back to `q` along two different paths, followed
 * by a suffix `x` that is _not_ accepted in state `q`. A backtracking
 * implementation will need to explore at least 2^n different ways of going
 * from `q` back to itself while trying to match the `n` copies of `w`
 * before finally giving up.
 *
 * Now in order to identify overlapping cycles, all we have to do is find
 * pumpable forks, that is, states `q` that can transition to two different
 * states `r1` and `r2` on the same input symbol `c`, such that there are
 * paths from both `r1` and `r2` to `q` that consume the same word. The latter
 * condition is equivalent to saying that `(q, q)` is reachable from `(r1, r2)`
 * in the product NFA.
 *
 * This is what the library does. It makes a simple attempt to construct a
 * prefix `v` leading into `q`, but only to improve the alert message.
 * And the library tries to prove the existence of a suffix that ensures
 * rejection. This check might fail, which can cause false positives.
 *
 * Finally, sometimes it depends on the translation whether the NFA generated
 * for a regular expression has a pumpable fork or not. We implement one
 * particular translation, which may result in false positives or negatives
 * relative to some particular JavaScript engine.
 *
 * More precisely, the library constructs an NFA from a regular expression `r`
 * as follows:
 *
 *   * Every sub-term `t` gives rise to an NFA state `Match(t,i)`, representing
 *     the state of the automaton before attempting to match the `i`th character in `t`.
 *   * There is one accepting state `Accept(r)`.
 *   * There is a special `AcceptAnySuffix(r)` state, which accepts any suffix string
 *     by using an epsilon transition to `Accept(r)` and an any transition to itself.
 *   * Transitions between states may be labelled with epsilon, or an abstract
 *     input symbol.
 *   * Each abstract input symbol represents a set of concrete input characters:
 *     either a single character, a set of characters represented by a
 *     character class, or the set of all characters.
 *   * The product automaton is constructed lazily, starting with pair states
 *     `(q, q)` where `q` is a fork, and proceeding along an over-approximate
 *     step relation.
 *   * The over-approximate step relation allows transitions along pairs of
 *     abstract input symbols where the symbols have overlap in the characters they accept.
 *   * Once a trace of pairs of abstract input symbols that leads from a fork
 *     back to itself has been identified, we attempt to construct a concrete
 *     string corresponding to it, which may fail.
 *   * Lastly we ensure that any state reached by repeating `n` copies of `w` has
 *     a suffix `x` (possible empty) that is most likely __not__ accepted.
 */

private import NfaUtils as NfaUtils
private import codeql.regex.RegexTreeView

/**
 * A parameterized module implementing the analysis described in the above papers.
 */
module Make<RegexTreeViewSig TreeImpl> {
  private import TreeImpl
  import NfaUtils::Make<TreeImpl>

  /**
   * Holds if state `s` might be inside a backtracking repetition.
   */
  pragma[noinline]
  private predicate stateInsideBacktracking(State s) {
    s.getRepr().getParent*() instanceof MaybeBacktrackingRepetition
  }

  /**
   * A infinitely repeating quantifier that might backtrack.
   */
  private class MaybeBacktrackingRepetition instanceof InfiniteRepetitionQuantifier {
    MaybeBacktrackingRepetition() {
      exists(RegExpTerm child |
        child instanceof RegExpAlt or
        child instanceof RegExpQuantifier
      |
        child.getParent+() = this
      )
    }

    string toString() { result = this.(InfiniteRepetitionQuantifier).toString() }
  }

  /**
   * A state in the product automaton.
   */
  private newtype TStatePair =
    /**
     * We lazily only construct those states that we are actually
     * going to need: `(q, q)` for every fork state `q`, and any
     * pair of states that can be reached from a pair that we have
     * already constructed. To cut down on the number of states,
     * we only represent states `(q1, q2)` where `q1` is lexicographically
     * no bigger than `q2`.
     *
     * States are only constructed if both states in the pair are
     * inside a repetition that might backtrack.
     */
    MkStatePair(State q1, State q2) {
      isFork(q1, _, _, _, _) and q2 = q1
      or
      (step(_, _, _, q1, q2) or step(_, _, _, q2, q1)) and
      rankState(q1) <= rankState(q2)
    }

  /**
   * Gets a unique number for a `state`.
   * Is used to create an ordering of states, where states with the same `toString()` will be ordered differently.
   */
  private int rankState(State state) {
    state =
      rank[result](State s |
        stateInsideBacktracking(s)
      |
        s order by getTermLocationString(s.getRepr())
      )
  }

  /**
   * A state in the product automaton.
   */
  private class StatePair extends TStatePair {
    State q1;
    State q2;

    StatePair() { this = MkStatePair(q1, q2) }

    /** Gets a textual representation of this element. */
    string toString() { result = "(" + q1 + ", " + q2 + ")" }

    /** Gets the first component of the state pair. */
    State getLeft() { result = q1 }

    /** Gets the second component of the state pair. */
    State getRight() { result = q2 }
  }

  /**
   * Holds for `(fork, fork)` state pairs when `isFork(fork, _, _, _, _)` holds.
   *
   * Used in `statePairDistToFork`
   */
  private predicate isStatePairFork(StatePair p) {
    exists(State fork | p = MkStatePair(fork, fork) and isFork(fork, _, _, _, _))
  }

  /**
   * Holds if there are transitions from the components of `q` to the corresponding
   * components of `r`.
   *
   * Used in `statePairDistToFork`
   */
  private predicate reverseStep(StatePair r, StatePair q) { step(q, _, _, r) }

  /**
   * Gets the minimum length of a path from `q` to `r` in the
   * product automaton.
   */
  private int statePairDistToFork(StatePair q, StatePair r) =
    shortestDistances(isStatePairFork/1, reverseStep/2)(r, q, result)

  /**
   * Holds if there are transitions from `q` to `r1` and from `q` to `r2`
   * labelled with `s1` and `s2`, respectively, where `s1` and `s2` do not
   * trivially have an empty intersection.
   *
   * This predicate only holds for states associated with regular expressions
   * that have at least one repetition quantifier in them (otherwise the
   * expression cannot be vulnerable to ReDoS attacks anyway).
   */
  pragma[noopt]
  private predicate isFork(State q, InputSymbol s1, InputSymbol s2, State r1, State r2) {
    stateInsideBacktracking(q) and
    exists(State q1, State q2 |
      q1 = epsilonSucc*(q) and
      delta(q1, s1, r1) and
      q2 = epsilonSucc*(q) and
      delta(q2, s2, r2) and
      // Use pragma[noopt] to prevent intersect(s1,s2) from being the starting point of the join.
      // From (s1,s2) it would find a huge number of intermediate state pairs (q1,q2) originating from different literals,
      // and discover at the end that no `q` can reach both `q1` and `q2` by epsilon transitions.
      exists(intersect(s1, s2))
    |
      s1 != s2
      or
      r1 != r2
      or
      r1 = r2 and q1 != q2
      or
      // If q can reach itself by epsilon transitions, then there are two distinct paths to the q1/q2 state:
      // one that uses the loop and one that doesn't. The engine will separately attempt to match with each path,
      // despite ending in the same state. The "fork" thus arises from the choice of whether to use the loop or not.
      // To avoid every state in the loop becoming a fork state,
      // we arbitrarily pick the InfiniteRepetitionQuantifier state as the canonical fork state for the loop
      // (every epsilon-loop must contain such a state).
      //
      // We additionally require that the there exists another InfiniteRepetitionQuantifier `mid` on the path from `q` to itself.
      // This is done to avoid flagging regular expressions such as `/(a?)*b/` - that only has polynomial runtime, and is detected by `js/polynomial-redos`.
      // The below code is therefore a heuristic, that only flags regular expressions such as `/(a*)*b/`,
      // and does not flag regular expressions such as `/(a?b?)c/`, but the latter pattern is not used frequently.
      r1 = r2 and
      q1 = q2 and
      epsilonSucc+(q) = q and
      exists(RegExpTerm term | term = q.getRepr() | term instanceof InfiniteRepetitionQuantifier) and
      // One of the mid states is an infinite quantifier itself
      exists(State mid, RegExpTerm term |
        mid = epsilonSucc+(q) and
        term = mid.getRepr() and
        term instanceof InfiniteRepetitionQuantifier and
        q = epsilonSucc+(mid) and
        not mid = q
      )
    ) and
    stateInsideBacktracking(r1) and
    stateInsideBacktracking(r2)
  }

  /**
   * Gets the state pair `(q1, q2)` or `(q2, q1)`; note that only
   * one or the other is defined.
   */
  private StatePair mkStatePair(State q1, State q2) {
    result = MkStatePair(q1, q2) or result = MkStatePair(q2, q1)
  }

  /**
   * Holds if there are transitions from the components of `q` to the corresponding
   * components of `r` labelled with `s1` and `s2`, respectively.
   */
  private predicate step(StatePair q, InputSymbol s1, InputSymbol s2, StatePair r) {
    exists(State r1, State r2 | step(q, s1, s2, r1, r2) and r = mkStatePair(r1, r2))
  }

  /**
   * Holds if there are transitions from the components of `q` to `r1` and `r2`
   * labelled with `s1` and `s2`, respectively.
   *
   * We only consider transitions where the resulting states `(r1, r2)` are both
   * inside a repetition that might backtrack.
   */
  pragma[noopt]
  private predicate step(StatePair q, InputSymbol s1, InputSymbol s2, State r1, State r2) {
    exists(State q1, State q2 | q.getLeft() = q1 and q.getRight() = q2 |
      deltaClosed(q1, s1, r1) and
      deltaClosed(q2, s2, r2) and
      // use noopt to force the join on `intersect` to happen last.
      exists(intersect(s1, s2))
    ) and
    stateInsideBacktracking(r1) and
    stateInsideBacktracking(r2)
  }

  private newtype TTrace =
    Nil() or
    Step(InputSymbol s1, InputSymbol s2, TTrace t) { isReachableFromFork(_, _, s1, s2, t, _) }

  /**
   * A list of pairs of input symbols that describe a path in the product automaton
   * starting from some fork state.
   */
  private class Trace extends TTrace {
    /** Gets a textual representation of this element. */
    string toString() {
      this = Nil() and result = "Nil()"
      or
      exists(InputSymbol s1, InputSymbol s2, Trace t | this = Step(s1, s2, t) |
        result = "Step(" + s1 + ", " + s2 + ", " + t + ")"
      )
    }
  }

  /**
   * Holds if `r` is reachable from `(fork, fork)` under input `w`, and there is
   * a path from `r` back to `(fork, fork)` with `rem` steps.
   */
  private predicate isReachableFromFork(State fork, StatePair r, Trace w, int rem) {
    exists(InputSymbol s1, InputSymbol s2, Trace v |
      isReachableFromFork(fork, r, s1, s2, v, rem) and
      w = Step(s1, s2, v)
    )
  }

  private predicate isReachableFromFork(
    State fork, StatePair r, InputSymbol s1, InputSymbol s2, Trace v, int rem
  ) {
    // base case
    exists(State q1, State q2 |
      isFork(fork, s1, s2, q1, q2) and
      r = MkStatePair(q1, q2) and
      v = Nil() and
      rem = statePairDistToFork(r, MkStatePair(fork, fork))
    )
    or
    // recursive case
    exists(StatePair p |
      isReachableFromFork(fork, p, v, rem + 1) and
      step(p, s1, s2, r) and
      rem = statePairDistToFork(r, MkStatePair(fork, fork))
    )
  }

  /**
   * Gets a state in the product automaton from which `(fork, fork)` is
   * reachable in zero or more epsilon transitions.
   */
  private StatePair getAForkPair(State fork) {
    isFork(fork, _, _, _, _) and
    result = MkStatePair(epsilonPred*(fork), epsilonPred*(fork))
  }

  /** An implementation of a chain containing chars for use by `Concretizer`. */
  private module CharTreeImpl implements CharTree {
    class CharNode = Trace;

    CharNode getPrev(CharNode t) { t = Step(_, _, result) }

    /** Holds if `n` is a trace that is used by `concretize` in `isPumpable`. */
    predicate isARelevantEnd(CharNode n) {
      exists(State f | isReachableFromFork(f, getAForkPair(f), n, _))
    }

    string getChar(CharNode t) {
      exists(InputSymbol s1, InputSymbol s2 | t = Step(s1, s2, _) | result = intersect(s1, s2))
    }
  }

  /**
   * Holds if `fork` is a pumpable fork with word `w`.
   */
  private predicate isPumpable(State fork, string w) {
    exists(StatePair q, Trace t |
      isReachableFromFork(fork, q, t, _) and
      q = getAForkPair(fork) and
      w = Concretizer<CharTreeImpl>::concretize(t)
    )
  }

  /** Holds if `state` has exponential ReDoS */
  predicate hasReDoSResult = ReDoSPruning<isPumpable/2>::hasReDoSResult/4;
}

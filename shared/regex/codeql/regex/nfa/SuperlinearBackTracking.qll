/**
 * This module implements the analysis described in the paper:
 *   Valentin Wustholz, Oswaldo Olivo, Marijn J. H. Heule, and Isil Dillig:
 *     Static Detection of DoS Vulnerabilities in
 *     Programs that use Regular Expressions
 *     (Extended Version).
 *   (https://arxiv.org/pdf/1701.04045.pdf)
 *
 * Theorem 3 from the paper describes the basic idea.
 *
 * The following explains the idea using variables and predicate names that are used in the implementation:
 * We consider a pair of repetitions, which we will call `pivot` and `pumpEnd`.
 *
 * We create a product automaton of 3-tuples of states (see `StateTuple`).
 * There exists a transition `(a,b,c) -> (d,e,f)` in the product automaton
 * iff there exists three transitions in the NFA `a->d, b->e, c->f` where those three
 * transitions all match a shared character `char`. (see `getAThreewayIntersect`)
 *
 * We start a search in the product automaton at `(pivot, pivot, pumpEnd)`,
 * and search for a series of transitions (a `Trace`), such that we end
 * at `(pivot, pumpEnd, pumpEnd)` (see `isReachableFromStartTuple`).
 *
 * For example, consider the regular expression `/^\d*5\w*$/`.
 * The search will start at the tuple `(\d*, \d*, \w*)` and search
 * for a path to `(\d*, \w*, \w*)`.
 * This path exists, and consists of a single transition in the product automaton,
 * where the three corresponding NFA edges all match the character `"5"`.
 *
 * The start-state in the NFA has an any-transition to itself, this allows us to
 * flag regular expressions such as `/a*$/` - which does not have a start anchor -
 * and can thus start matching anywhere.
 *
 * The implementation is not perfect.
 * It has the same suffix detection issue as the `js/redos` query, which can cause false positives.
 * It also doesn't find all transitions in the product automaton, which can cause false negatives.
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
   * Gets any root (start) state of a regular expression.
   */
  private State getRootState() { result = mkMatch(any(RegExpRoot r)) }

  private newtype TStateTuple =
    MkStateTuple(State q1, State q2, State q3) {
      // starts at (pivot, pivot, pumpEnd)
      isStartLoops(q1, q3) and q1 = q2
      or
      step(_, _, _, _, q1, q2, q3) and FeasibleTuple::isFeasibleTuple(q1, q2, q3)
    }

  /**
   * A state in the product automaton.
   * The product automaton contains 3-tuples of states.
   *
   * We lazily only construct those states that we are actually
   * going to need.
   * Either a start state `(pivot, pivot, pumpEnd)`, or a state
   * where there exists a transition from an already existing state.
   *
   * The exponential variant of this query (`js/redos`) uses an optimization
   * trick where `q1 <= q2`. This trick cannot be used here as the order
   * of the elements matter.
   */
  class StateTuple extends TStateTuple {
    State q1;
    State q2;
    State q3;

    StateTuple() { this = MkStateTuple(q1, q2, q3) }

    /**
     * Gest a string representation of this tuple.
     */
    string toString() { result = "(" + q1 + ", " + q2 + ", " + q3 + ")" }

    /**
     * Holds if this tuple is `(r1, r2, r3)`.
     */
    pragma[noinline]
    predicate isTuple(State r1, State r2, State r3) { r1 = q1 and r2 = q2 and r3 = q3 }
  }

  /**
   * A module for determining feasible tuples for the product automaton.
   *
   * The implementation is split into many predicates for performance reasons.
   */
  private module FeasibleTuple {
    /**
     * Holds if the tuple `(r1, r2, r3)` might be on path from a start-state to an end-state in the product automaton.
     */
    pragma[inline]
    predicate isFeasibleTuple(State r1, State r2, State r3) {
      // The first element is either inside a repetition (or the start state itself)
      isRepetitionOrStart(r1) and
      // The last element is inside a repetition
      stateInsideRepetition(r3) and
      // The states are reachable in the NFA in the order r1 -> r2 -> r3
      delta+(r1) = r2 and
      delta+(r2) = r3 and
      // The first element can reach a beginning (the "pivot" state in a `(pivot, pumpEnd)` pair).
      canReachABeginning(r1) and
      // The last element can reach a target (the "pumpEnd" state in a `(pivot, pumpEnd)` pair).
      canReachATarget(r3)
    }

    /**
     * Holds if `s` is either inside a repetition, or is the start state (which is a repetition).
     */
    pragma[noinline]
    private predicate isRepetitionOrStart(State s) {
      stateInsideRepetition(s) or s = getRootState()
    }

    /**
     * Holds if state `s` might be inside a backtracking repetition.
     */
    pragma[noinline]
    private predicate stateInsideRepetition(State s) {
      s.getRepr().getParent*() instanceof InfiniteRepetitionQuantifier
    }

    /**
     * Holds if there exists a path in the NFA from `s` to a "pivot" state
     * (from a `(pivot, pumpEnd)` pair that starts the search).
     */
    pragma[noinline]
    private predicate canReachABeginning(State s) {
      delta+(s) = any(State pivot | isStartLoops(pivot, _))
    }

    /**
     * Holds if there exists a path in the NFA from `s` to a "pumpEnd" state
     * (from a `(pivot, pumpEnd)` pair that starts the search).
     */
    pragma[noinline]
    private predicate canReachATarget(State s) {
      delta+(s) = any(State pumpEnd | isStartLoops(_, pumpEnd))
    }
  }

  /**
   * Holds if `pivot` and `pumpEnd` are a pair of loops that could be the beginning of a quadratic blowup.
   *
   * There is a slight implementation difference compared to the paper: this predicate requires that `pivot != pumpEnd`.
   * The case where `pivot = pumpEnd` causes exponential backtracking and is handled by the `js/redos` query.
   */
  predicate isStartLoops(State pivot, State pumpEnd) {
    pivot != pumpEnd and
    pumpEnd.getRepr() instanceof InfiniteRepetitionQuantifier and
    delta+(pivot) = pumpEnd and
    (
      pivot.getRepr() instanceof InfiniteRepetitionQuantifier
      or
      pivot = mkMatch(any(RegExpRoot root))
    )
  }

  /**
   * Gets a state for which there exists a transition in the NFA from `s'.
   */
  State delta(State s) { delta(s, _, result) }

  /**
   * Holds if there are transitions from the components of `q` to the corresponding
   * components of `r` labelled with `s1`, `s2`, and `s3`, respectively.
   */
  pragma[nomagic]
  private predicate stepHelper(
    StateTuple q, InputSymbol s1, InputSymbol s2, InputSymbol s3, StateTuple r
  ) {
    exists(State r1, State r2, State r3 |
      step(q, s1, s2, s3, r1, r2, r3) and r = MkStateTuple(r1, r2, r3)
    )
  }

  /**
   * Holds if there are transitions from the components of `q` to the corresponding
   * components of `r` labelled with `s1`, `s2`, and `s3`, respectively.
   *
   * Additionally, a heuristic is used to avoid blowups in the case of complex regexps.
   * For regular expressions with more than 100 states, we only look at all the characters
   * for the transitions out of `q` and only consider transitions that use the lexicographically
   * smallest character.
   */
  pragma[noinline]
  predicate step(StateTuple q, InputSymbol s1, InputSymbol s2, InputSymbol s3, StateTuple r) {
    stepHelper(q, s1, s2, s3, r) and
    (
      countStates(any(State s | q.isTuple(s, _, _)).getRepr().getRootTerm()) < 100
      or
      // arbitrarily pick an edge out of `q` for complex regexps. This is a heuristic to avoid potential blowups.
      exists(string char |
        char =
          min(string str, InputSymbol x1, InputSymbol x2, InputSymbol x3 |
            stepHelper(q, x1, x2, x3, _) and str = getAStepChar(x1, x2, x3)
          |
            str
          ) and
        char = getAStepChar(s1, s2, s3)
      )
    )
  }

  // specialized version of `getAThreewayIntersect` to be used in `step` above.
  pragma[noinline]
  private string getAStepChar(InputSymbol s1, InputSymbol s2, InputSymbol s3) {
    stepHelper(_, s1, s2, s3, _) and result = getAThreewayIntersect(s1, s2, s3)
  }

  /** Gets the number of states in the NFA for `root`. This is used to determine a complexity metric used in the `step` predicate above. */
  private int countStates(RegExpTerm root) {
    root.isRootTerm() and
    result = count(State s | s.getRepr().getRootTerm() = root)
  }

  /**
   * Holds if there are transitions from the components of `q` to `r1`, `r2`, and `r3
   * labelled with `s1`, `s2`, and `s3`, respectively.
   */
  pragma[noopt]
  predicate step(
    StateTuple q, InputSymbol s1, InputSymbol s2, InputSymbol s3, State r1, State r2, State r3
  ) {
    exists(State q1, State q2, State q3 | q.isTuple(q1, q2, q3) |
      deltaClosed(q1, s1, r1) and
      deltaClosed(q2, s2, r2) and
      deltaClosed(q3, s3, r3) and
      // use noopt to force the join on `getAThreewayIntersect` to happen last.
      exists(getAThreewayIntersect(s1, s2, s3))
    )
  }

  /**
   * Gets a char that is matched by all the edges `s1`, `s2`, and `s3`.
   *
   * The result is not complete, and might miss some combination of edges that share some character.
   */
  pragma[noinline]
  string getAThreewayIntersect(InputSymbol s1, InputSymbol s2, InputSymbol s3) {
    result = minAndMaxIntersect(s1, s2) and result = [intersect(s2, s3), intersect(s1, s3)]
    or
    result = minAndMaxIntersect(s1, s3) and result = [intersect(s2, s3), intersect(s1, s2)]
    or
    result = minAndMaxIntersect(s2, s3) and result = [intersect(s1, s2), intersect(s1, s3)]
  }

  /**
   * Gets the minimum and maximum characters that intersect between `a` and `b`.
   * This predicate is used to limit the size of `getAThreewayIntersect`.
   */
  pragma[noinline]
  string minAndMaxIntersect(InputSymbol a, InputSymbol b) {
    result = [min(intersect(a, b)), max(intersect(a, b))]
  }

  private newtype TTrace =
    Nil() or
    Step(InputSymbol s1, InputSymbol s2, InputSymbol s3, TTrace t) {
      isReachableFromStartTuple(_, _, t, s1, s2, s3, _, _)
    }

  /**
   * A list of tuples of input symbols that describe a path in the product automaton
   * starting from some start state.
   */
  class Trace extends TTrace {
    /**
     * Gets a string representation of this Trace that can be used for debug purposes.
     */
    string toString() {
      this = Nil() and result = "Nil()"
      or
      exists(InputSymbol s1, InputSymbol s2, InputSymbol s3, Trace t | this = Step(s1, s2, s3, t) |
        result = "Step(" + s1 + ", " + s2 + ", " + s3 + ", " + t + ")"
      )
    }
  }

  /**
   * Holds if there exists a transition from `r` to `q` in the product automaton.
   * Notice that the arguments are flipped, and thus the direction is backwards.
   */
  pragma[noinline]
  predicate tupleDeltaBackwards(StateTuple q, StateTuple r) { step(r, _, _, _, q) }

  /**
   * Holds if `tuple` is an end state in our search.
   * That means there exists a pair of loops `(pivot, pumpEnd)` such that `tuple = (pivot, pumpEnd, pumpEnd)`.
   */
  predicate isEndTuple(StateTuple tuple) { tuple = getAnEndTuple(_, _) }

  /**
   * Gets the minimum length of a path from `r` to some an end state `end`.
   *
   * The implementation searches backwards from the end-tuple.
   * This approach was chosen because it is way more efficient if the first predicate given to `shortestDistances` is small.
   * The `end` argument must always be an end state.
   */
  int distBackFromEnd(StateTuple r, StateTuple end) =
    shortestDistances(isEndTuple/1, tupleDeltaBackwards/2)(end, r, result)

  /**
   * Holds if there exists a pair of repetitions `(pivot, pumpEnd)` in the regular expression such that:
   * `tuple` is reachable from `(pivot, pivot, pumpEnd)` in the product automaton,
   * and there is a distance of `dist` from `tuple` to the nearest end-tuple `(pivot, pumpEnd, pumpEnd)`,
   * and a path from a start-state to `tuple` follows the transitions in `trace`.
   */
  private predicate isReachableFromStartTuple(
    State pivot, State pumpEnd, StateTuple tuple, Trace trace, int dist
  ) {
    exists(InputSymbol s1, InputSymbol s2, InputSymbol s3, Trace v |
      isReachableFromStartTuple(pivot, pumpEnd, v, s1, s2, s3, tuple, dist) and
      trace = Step(s1, s2, s3, v)
    )
  }

  private predicate isReachableFromStartTuple(
    State pivot, State pumpEnd, Trace trace, InputSymbol s1, InputSymbol s2, InputSymbol s3,
    StateTuple tuple, int dist
  ) {
    // base case.
    isStartLoops(pivot, pumpEnd) and
    step(MkStateTuple(pivot, pivot, pumpEnd), s1, s2, s3, tuple) and
    tuple = MkStateTuple(_, _, _) and
    trace = Nil() and
    dist = distBackFromEnd(tuple, MkStateTuple(pivot, pumpEnd, pumpEnd))
    or
    // recursive case
    exists(StateTuple p |
      isReachableFromStartTuple(pivot, pumpEnd, p, trace, dist + 1) and
      dist = distBackFromEnd(tuple, MkStateTuple(pivot, pumpEnd, pumpEnd)) and
      step(p, s1, s2, s3, tuple)
    )
  }

  /**
   * Gets the tuple `(pivot, pumpEnd, pumpEnd)` from the product automaton.
   */
  StateTuple getAnEndTuple(State pivot, State pumpEnd) {
    isStartLoops(pivot, pumpEnd) and
    result = MkStateTuple(pivot, pumpEnd, pumpEnd)
  }

  /** An implementation of a chain containing chars for use by `Concretizer`. */
  private module CharTreeImpl implements CharTree {
    class CharNode = Trace;

    CharNode getPrev(CharNode t) { t = Step(_, _, _, result) }

    /** Holds if `n` is used in `isPumpable`. */
    predicate isARelevantEnd(CharNode n) {
      exists(State pivot, State pumpEnd |
        isReachableFromStartTuple(pivot, pumpEnd, getAnEndTuple(pivot, pumpEnd), n, _)
      )
    }

    private string getCharInternal(CharNode t) {
      exists(InputSymbol s1, InputSymbol s2, InputSymbol s3 | t = Step(s1, s2, s3, _) |
        result = getAThreewayIntersect(s1, s2, s3)
      )
    }

    string getChar(CharNode t) {
      result = getCharInternal(t) and
      not (
        // skip the upper-case char if we have the lower-case version.
        result.toLowerCase() != result and result.toLowerCase() = getCharInternal(t)
      )
    }
  }

  /**
   * Holds if matching repetitions of `pump` can:
   * 1) Transition from `pivot` back to `pivot`.
   * 2) Transition from `pivot` to `pumpEnd`.
   * 3) Transition from `pumpEnd` to `pumpEnd`.
   *
   * From theorem 3 in the paper linked in the top of this file we can therefore conclude that
   * the regular expression has polynomial backtracking - if a rejecting suffix exists.
   *
   * This predicate is used by `SuperLinearReDoSConfiguration`, and the final results are
   * available in the `hasReDoSResult` predicate.
   */
  predicate isPumpable(State pivot, State pumpEnd, string pump) {
    exists(StateTuple q, Trace t |
      isReachableFromStartTuple(pivot, pumpEnd, q, t, _) and
      q = getAnEndTuple(pivot, pumpEnd) and
      pump = Concretizer<CharTreeImpl>::concretize(t)
    )
  }

  /**
   * Holds if states starting in `state` can have polynomial backtracking with the string `pump`.
   */
  predicate isReDoSCandidate(State state, string pump) { isPumpable(_, state, pump) }

  /**
   * Holds if repetitions of `pump` at `t` will cause polynomial backtracking.
   */
  predicate polynomialReDoS(RegExpTerm t, string pump, string prefixMsg, RegExpTerm prev) {
    exists(State s, State pivot |
      ReDoSPruning<isReDoSCandidate/2>::hasReDoSResult(t, pump, s, prefixMsg) and
      isPumpable(pivot, s, _) and
      prev = pivot.getRepr()
    )
  }

  /**
   * Gets a message for why `term` can cause polynomial backtracking.
   */
  string getReasonString(RegExpTerm term, string pump, string prefixMsg, RegExpTerm prev) {
    polynomialReDoS(term, pump, prefixMsg, prev) and
    result =
      "Strings " + prefixMsg + "with many repetitions of '" + pump +
        "' can start matching anywhere after the start of the preceeding " + prev
  }

  final private class FinalInfiniteRepetitionQuantifier = InfiniteRepetitionQuantifier;

  /**
   * A term that may cause a regular expression engine to perform a
   * polynomial number of match attempts, relative to the input length.
   */
  class PolynomialBackTrackingTerm extends FinalInfiniteRepetitionQuantifier {
    string reason;
    string pump;
    string prefixMsg;
    RegExpTerm prev;

    PolynomialBackTrackingTerm() {
      reason = getReasonString(this, pump, prefixMsg, prev) and
      // there might be many reasons for this term to have polynomial backtracking - we pick the shortest one.
      reason =
        min(string msg | msg = getReasonString(this, _, _, _) | msg order by msg.length(), msg)
    }

    /**
     * Holds if all non-empty successors to the polynomial backtracking term matches the end of the line.
     */
    predicate isAtEndLine() {
      forall(RegExpTerm pumpEnd | super.getSuccessor+() = pumpEnd and not matchesEpsilon(pumpEnd) |
        pumpEnd instanceof RegExpDollar
      )
    }

    /**
     * Gets the string that should be repeated to cause this regular expression to perform polynomially.
     */
    string getPumpString() { result = pump }

    /**
     * Gets a message for which prefix a matching string must start with for this term to cause polynomial backtracking.
     */
    string getPrefixMessage() { result = prefixMsg }

    /**
     * Gets a predecessor to `this`, which also loops on the pump string, and thereby causes polynomial backtracking.
     */
    RegExpTerm getPreviousLoop() { result = prev }

    /**
     * Gets the reason for the number of match attempts.
     */
    string getReason() { result = reason }
  }
}

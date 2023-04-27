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
    /**
     * A tuple of states `(q1, q2, q3)` in the product automaton that is reachable from `(pivot, pivot, pumpEnd)`.
     */
    MkStateTuple(State pivot, State pumpEnd, State q1, State q2, State q3) {
      // starts at (pivot, pivot, pumpEnd)
      isStartLoops(q1, q3) and
      q1 = q2 and
      pivot = q1 and
      pumpEnd = q3
      or
      // recurse: any transition out where all 3 edges share a char (and the resulting tuple isn't obviously infeasible)
      exists(StateTuple prev |
        prev = MkStateTuple(pivot, pumpEnd, _, _, _) and
        hasCommonStep(prev, _, _, _, q1, q2, q3) and
        FeasibleTuple::isFeasibleTuple(pivot, pumpEnd, q1, q2, q3)
      )
    }

  /**
   * A state `(q1, q2, q3)` in the product automaton, that is reachable from `(pivot, pivot, pumpEnd)`.
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
    State pivot;
    State pumpEnd;
    State q1;
    State q2;
    State q3;

    StateTuple() { this = MkStateTuple(pivot, pumpEnd, q1, q2, q3) }

    /**
     * Gest a string representation of this tuple.
     */
    string toString() { result = "(" + q1 + ", " + q2 + ", " + q3 + ")" }

    /**
     * Holds if this tuple is `(r1, r2, r3)`.
     */
    pragma[noinline]
    predicate isTuple(State r1, State r2, State r3) { r1 = q1 and r2 = q2 and r3 = q3 }

    /**
     * Gets the first state of the tuple.
     */
    State getFirst() { result = q1 }

    /**
     * Gets the second state of the tuple.
     */
    State getSecond() { result = q2 }

    /**
     * Gets the third state of the tuple.
     */
    State getThird() { result = q3 }

    /**
     * Gets the pivot state.
     */
    State getPivot() { result = pivot }

    /**
     * Gets the pumpEnd state.
     */
    State getPumpEnd() { result = pumpEnd }

    /**
     * Holds if the pivot state has the specified location.
     * This location has been chosen arbitrarily, and is only useful for debugging.
     */
    predicate hasLocationInfo(string file, int line, int column, int endLine, int endColumn) {
      pivot.hasLocationInfo(file, line, column, endLine, endColumn)
    }
  }

  /**
   * A module for determining feasible tuples for the product automaton.
   *
   * The implementation is split into many predicates for performance reasons.
   */
  private module FeasibleTuple {
    /**
     * Holds if the tuple `(r1, r2, r3)` might be on path from a start-state `(pivot, pivot, pumpEnd)` to an end-state `(pivot, pumpEnd, pumpEnd)` in the product automaton.
     */
    bindingset[pivot, pumpEnd, r1, r2, r3]
    pragma[inline_late]
    predicate isFeasibleTuple(State pivot, State pumpEnd, State r1, State r2, State r3) {
      isStartLoops(pivot, pumpEnd) and
      // r1 can reach the pivot state
      reachesBeginning(r1, pivot) and
      // r2 and r3 can reach the pumpEnd state
      reachesEnd(r2, pumpEnd) and
      reachesEnd(r3, pumpEnd) and
      // The first element is either inside a repetition (or the start state itself)
      isRepetitionOrStart(r1) and
      // The last element is inside a repetition
      stateInsideRepetition(r3) and
      // The states are reachable in the NFA in the order r1 -> r2 -> r3
      delta+(r1) = r2 and
      delta+(r2) = r3
    }

    pragma[noinline]
    private predicate reachesBeginning(State s, State pivot) {
      isStartLoops(pivot, _) and
      delta+(s) = pivot
    }

    pragma[noinline]
    private predicate reachesEnd(State s, State pumpEnd) {
      isStartLoops(_, pumpEnd) and
      delta+(s) = pumpEnd
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
   * Where the edges `s1`, `s2`, and `s3` all share at least one character.
   */
  pragma[nomagic]
  private predicate step(StateTuple q, InputSymbol s1, InputSymbol s2, InputSymbol s3, StateTuple r) {
    exists(State r1, State r2, State r3 |
      hasCommonStep(q, s1, s2, s3, r1, r2, r3) and
      r =
        MkStateTuple(pragma[only_bind_out](q.getPivot()), pragma[only_bind_out](q.getPumpEnd()),
          pragma[only_bind_out](r1), pragma[only_bind_out](r2), pragma[only_bind_out](r3))
    )
  }

  /**
   * Holds if there are transitions from the components of `q` to `r1`, `r2`, and `r3
   * labelled with `s1`, `s2`, and `s3`, respectively.
   * Where `s1`, `s2`, and `s3` all share at least one character.
   */
  pragma[noopt]
  predicate hasCommonStep(
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

  /** Gets a tuple reachable in a forwards exploratory search from the start state `(pivot, pivot, pivot)`. */
  private StateTuple getReachableFromStartStateForwards(State pivot, State pumpEnd) {
    // base case.
    isStartLoops(pivot, pumpEnd) and
    result = MkStateTuple(pivot, pumpEnd, pivot, pivot, pumpEnd)
    or
    // recursive case
    exists(StateTuple p |
      p = getReachableFromStartStateForwards(pivot, pumpEnd) and
      step(p, _, _, _, result)
    )
  }

  /**
   * Gets a state tuple that can reach the end state `(pivot, pumpEnd, pumpEnd)`, found via a backwards exploratory search.
   * Where the end state was reachable from a forwards search from the start state `(pivot, pivot, pumpEnd)`.
   * The resulting tuples are exactly those that are on a path from the start state to the end state.
   */
  private StateTuple getARelevantStateTuple(State pivot, State pumpEnd) {
    // base case.
    isStartLoops(pivot, pumpEnd) and
    result = MkStateTuple(pivot, pumpEnd, pivot, pumpEnd, pumpEnd) and
    result = getReachableFromStartStateForwards(pivot, pumpEnd)
    or
    // recursive case
    exists(StateTuple p |
      p = getARelevantStateTuple(pivot, pumpEnd) and
      step(result, _, _, _, p) and
      pragma[only_bind_out](result) = getReachableFromStartStateForwards(pivot, pumpEnd) // was reachable in the forwards pass.
    )
  }

  /**
   * Holds if there exists a transition from `src` to `dst` in the product automaton.
   * Where `src` and `dst` are both on a path from a start state to an end state.
   * Notice that the arguments are flipped, and thus the direction is backwards.
   */
  pragma[noinline]
  predicate tupleDeltaBackwards(StateTuple dst, StateTuple src) {
    step(src, _, _, _, dst) and
    // `step` ensures that `src` and `dst` have the same pivot and pumpEnd.
    src = getARelevantStateTuple(_, _) and
    dst = getARelevantStateTuple(_, _)
  }

  /**
   * Holds if `tuple` is an end state in our search, and `tuple` is on a path from a start state to an end state.
   * That means there exists a pair of loops `(pivot, pumpEnd)` such that `tuple = (pivot, pumpEnd, pumpEnd)`.
   */
  predicate isEndTuple(StateTuple tuple) {
    tuple = getEndTuple(_, _) and
    tuple = getARelevantStateTuple(_, _)
  }

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
   * Holds if there is a step from `q` to `r` in the product automaton labeled with `s1`, `s2`, and `s3`.
   * Where the step is on a path from a start state to an end state.
   */
  private predicate isStepOnPath(
    StateTuple q, InputSymbol s1, InputSymbol s2, InputSymbol s3, StateTuple r
  ) {
    step(q, s1, s2, s3, r) and
    exists(State pivot, State pumpEnd, StateTuple end |
      end = MkStateTuple(pivot, pumpEnd, pivot, pumpEnd, pumpEnd) and
      pragma[only_bind_out](distBackFromEnd(q, end)) =
        pragma[only_bind_out](distBackFromEnd(r, end)) + 1
    )
  }

  /**
   * Gets a unique number for a `state`.
   * Is used to create an ordering of states and tuples of states.
   */
  private int rankState(State state) {
    state =
      rank[result](State s, int startLine, int endLine, int startColumn, int endColumn |
        exists(StateTuple tuple | tuple = getARelevantStateTuple(_, _) |
          s = [tuple.getFirst(), tuple.getSecond(), tuple.getThird()] and
          s.getRepr().hasLocationInfo(_, startLine, startColumn, endLine, endColumn)
        )
      |
        s order by startLine, startColumn, endLine, endColumn
      )
  }

  /**
   * Holds if there is a step from `q` to `r` in the product automaton labeled with `s1`, `s2`, and `s3`.
   * Where the step is on a path from a start state to an end state.
   * And the step is a uniquely chosen step from out of `q`.
   */
  pragma[nomagic]
  private predicate isUniqueMinStepOnPath(
    StateTuple q, InputSymbol s1, InputSymbol s2, InputSymbol s3, StateTuple r
  ) {
    isStepOnPath(q, s1, s2, s3, r) and
    r =
      min(StateTuple cand |
        isStepOnPath(q, _, _, _, cand)
      |
        cand
        order by
          rankState(cand.getFirst()), rankState(cand.getSecond()), rankState(cand.getThird())
      )
  }

  private newtype TTrace =
    Nil(State pivot, State pumpEnd) {
      isStartLoops(pivot, pumpEnd) and
      getStartTuple(pivot, pumpEnd) = getARelevantStateTuple(pivot, pumpEnd)
    } or
    Step(TTrace prev, StateTuple nextTuple) {
      exists(StateTuple prevTuple |
        exists(State pivot, State pumpEnd |
          prev = Nil(pivot, pumpEnd) and
          prevTuple = getStartTuple(pivot, pumpEnd)
        )
        or
        prev = Step(_, prevTuple)
      |
        isUniqueMinStepOnPath(prevTuple, _, _, _, nextTuple)
      )
    }

  /**
   * A list of tuples of input symbols that describe a path in the product automaton
   * starting from a start state `(pivot, pivot, pumpEnd)`.
   */
  class Trace extends TTrace {
    /**
     * Gets a string representation of this Trace that can be used for debug purposes.
     */
    string toString() { result = "a trace" }

    /** Gets a trace where the head has been removed. */
    Trace getPrev() { this = Step(result, _) }

    /** Gets the tuple at the head of this trace. */
    StateTuple getTuple() {
      this = Step(_, result)
      or
      exists(State prev, State pumpEnd |
        this = Nil(prev, pumpEnd) and
        result = getStartTuple(prev, pumpEnd)
      )
    }
  }

  /**
   * Gets the tuple `(pivot, pumpEnd, pumpEnd)` from the product automaton.
   */
  StateTuple getEndTuple(State pivot, State pumpEnd) {
    isStartLoops(pivot, pumpEnd) and
    result = MkStateTuple(pivot, pumpEnd, pivot, pumpEnd, pumpEnd)
  }

  /**
   * Gets the tuple `(pivot, pivot, pumpEnd)` from the product automaton.
   */
  StateTuple getStartTuple(State pivot, State pumpEnd) {
    isStartLoops(pivot, pumpEnd) and
    result = MkStateTuple(pivot, pumpEnd, pivot, pivot, pumpEnd)
  }

  /** An implementation of a chain containing chars for use by `Concretizer`. */
  private module CharTreeImpl implements CharTree {
    class CharNode = Trace;

    CharNode getPrev(CharNode t) { result = t.getPrev() }

    predicate isARelevantEnd(CharNode n) { n.getTuple() = getEndTuple(_, _) }

    string getChar(CharNode t) {
      result =
        min(string c, InputSymbol s1, InputSymbol s2, InputSymbol s3 |
          isUniqueMinStepOnPath(t.getPrev().getTuple(), s1, s2, s3, t.getTuple()) and
          c = getAThreewayIntersect(s1, s2, s3)
        |
          c
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
      q = getEndTuple(pivot, pumpEnd) and
      q = t.getTuple() and
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

  /**
   * A term that may cause a regular expression engine to perform a
   * polynomial number of match attempts, relative to the input length.
   */
  class PolynomialBackTrackingTerm instanceof InfiniteRepetitionQuantifier {
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
      forall(RegExpTerm succ | super.getSuccessor+() = succ and not matchesEpsilon(succ) |
        succ instanceof RegExpDollar
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

    /** Gets a string representation of this term. */
    string toString() { result = super.toString() }

    /** Gets the outermost term of this regular expression. */
    RegExpTerm getRootTerm() { result = super.getRootTerm() }

    /** Holds if this term has the specific location. */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      super.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }
  }
}

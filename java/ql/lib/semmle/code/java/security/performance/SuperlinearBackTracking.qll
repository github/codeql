/**
 * Provides classes for working with regular expressions that can
 * perform backtracking in superlinear time.
 */

import ReDoSUtil

/*
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
 * We consider a pair of repetitions, which we will call `pivot` and `succ`.
 *
 * We create a product automaton of 3-tuples of states (see `StateTuple`).
 * There exists a transition `(a,b,c) -> (d,e,f)` in the product automaton
 * iff there exists three transitions in the NFA `a->d, b->e, c->f` where those three
 * transitions all match a shared character `char`. (see `getAThreewayIntersect`)
 *
 * We start a search in the product automaton at `(pivot, pivot, succ)`,
 * and search for a series of transitions (a `Trace`), such that we end
 * at `(pivot, succ, succ)` (see `isReachableFromStartTuple`).
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

/**
 * An instantiaion of `ReDoSConfiguration` for superlinear ReDoS.
 */
class SuperLinearReDoSConfiguration extends ReDoSConfiguration {
  SuperLinearReDoSConfiguration() { this = "SuperLinearReDoSConfiguration" }

  override predicate isReDoSCandidate(State state, string pump) { isPumpable(_, state, pump) }
}

/**
 * Gets any root (start) state of a regular expression.
 */
private State getRootState() { result = mkMatch(any(RegExpRoot r)) }

private newtype TStateTuple =
  MkStateTuple(State q1, State q2, State q3) {
    // starts at (pivot, pivot, succ)
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
 * Either a start state `(pivot, pivot, succ)`, or a state
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
   * Gest a string repesentation of this tuple.
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
    // The first element can reach a beginning (the "pivot" state in a `(pivot, succ)` pair).
    canReachABeginning(r1) and
    // The last element can reach a target (the "succ" state in a `(pivot, succ)` pair).
    canReachATarget(r3)
  }

  /**
   * Holds if `s` is either inside a repetition, or is the start state (which is a repetition).
   */
  pragma[noinline]
  private predicate isRepetitionOrStart(State s) { stateInsideRepetition(s) or s = getRootState() }

  /**
   * Holds if state `s` might be inside a backtracking repetition.
   */
  pragma[noinline]
  private predicate stateInsideRepetition(State s) {
    s.getRepr().getParent*() instanceof InfiniteRepetitionQuantifier
  }

  /**
   * Holds if there exists a path in the NFA from `s` to a "pivot" state
   * (from a `(pivot, succ)` pair that starts the search).
   */
  pragma[noinline]
  private predicate canReachABeginning(State s) {
    delta+(s) = any(State pivot | isStartLoops(pivot, _))
  }

  /**
   * Holds if there exists a path in the NFA from `s` to a "succ" state
   * (from a `(pivot, succ)` pair that starts the search).
   */
  pragma[noinline]
  private predicate canReachATarget(State s) { delta+(s) = any(State succ | isStartLoops(_, succ)) }
}

/**
 * Holds if `pivot` and `succ` are a pair of loops that could be the beginning of a quadratic blowup.
 *
 * There is a slight implementation difference compared to the paper: this predicate requires that `pivot != succ`.
 * The case where `pivot = succ` causes exponential backtracking and is handled by the `js/redos` query.
 */
predicate isStartLoops(State pivot, State succ) {
  pivot != succ and
  succ.getRepr() instanceof InfiniteRepetitionQuantifier and
  delta+(pivot) = succ and
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
pragma[noinline]
predicate step(StateTuple q, InputSymbol s1, InputSymbol s2, InputSymbol s3, StateTuple r) {
  exists(State r1, State r2, State r3 |
    step(q, s1, s2, s3, r1, r2, r3) and r = MkStateTuple(r1, r2, r3)
  )
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
    exists(StateTuple p |
      isReachableFromStartTuple(_, _, p, t, _) and
      step(p, s1, s2, s3, _)
    )
    or
    exists(State pivot, State succ | isStartLoops(pivot, succ) |
      t = Nil() and step(MkStateTuple(pivot, pivot, succ), s1, s2, s3, _)
    )
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
 * That means there exists a pair of loops `(pivot, succ)` such that `tuple = (pivot, succ, succ)`.
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
 * Holds if there exists a pair of repetitions `(pivot, succ)` in the regular expression such that:
 * `tuple` is reachable from `(pivot, pivot, succ)` in the product automaton,
 * and there is a distance of `dist` from `tuple` to the nearest end-tuple `(pivot, succ, succ)`,
 * and a path from a start-state to `tuple` follows the transitions in `trace`.
 */
predicate isReachableFromStartTuple(State pivot, State succ, StateTuple tuple, Trace trace, int dist) {
  // base case. The first step is inlined to start the search after all possible 1-steps, and not just the ones with the shortest path.
  exists(InputSymbol s1, InputSymbol s2, InputSymbol s3, State q1, State q2, State q3 |
    isStartLoops(pivot, succ) and
    step(MkStateTuple(pivot, pivot, succ), s1, s2, s3, tuple) and
    tuple = MkStateTuple(q1, q2, q3) and
    trace = Step(s1, s2, s3, Nil()) and
    dist = distBackFromEnd(tuple, MkStateTuple(pivot, succ, succ))
  )
  or
  // recursive case
  exists(StateTuple p, Trace v, InputSymbol s1, InputSymbol s2, InputSymbol s3 |
    isReachableFromStartTuple(pivot, succ, p, v, dist + 1) and
    dist = isReachableFromStartTupleHelper(pivot, succ, tuple, p, s1, s2, s3) and
    trace = Step(s1, s2, s3, v)
  )
}

/**
 * Helper predicate for the recursive case in `isReachableFromStartTuple`.
 */
pragma[noinline]
private int isReachableFromStartTupleHelper(
  State pivot, State succ, StateTuple r, StateTuple p, InputSymbol s1, InputSymbol s2,
  InputSymbol s3
) {
  result = distBackFromEnd(r, MkStateTuple(pivot, succ, succ)) and
  step(p, s1, s2, s3, r)
}

/**
 * Gets the tuple `(pivot, succ, succ)` from the product automaton.
 */
StateTuple getAnEndTuple(State pivot, State succ) {
  isStartLoops(pivot, succ) and
  result = MkStateTuple(pivot, succ, succ)
}

private predicate hasSuffix(Trace suffix, Trace t, int i) {
  // Declaring `t` to be a `RelevantTrace` currently causes a redundant check in the
  // recursive case, so instead we check it explicitly here.
  t instanceof RelevantTrace and
  i = 0 and
  suffix = t
  or
  hasSuffix(Step(_, _, _, suffix), t, i - 1)
}

pragma[noinline]
private predicate hasTuple(InputSymbol s1, InputSymbol s2, InputSymbol s3, Trace t, int i) {
  hasSuffix(Step(s1, s2, s3, _), t, i)
}

private class RelevantTrace extends Trace, Step {
  RelevantTrace() {
    exists(State pivot, State succ, StateTuple q |
      isReachableFromStartTuple(pivot, succ, q, this, _) and
      q = getAnEndTuple(pivot, succ)
    )
  }

  pragma[noinline]
  private string getAThreewayIntersect(int i) {
    exists(InputSymbol s1, InputSymbol s2, InputSymbol s3 |
      hasTuple(s1, s2, s3, this, i) and
      result = getAThreewayIntersect(s1, s2, s3)
    )
  }

  /** Gets a string corresponding to this trace. */
  // the pragma is needed for the case where `getAThreewayIntersect(s1, s2, s3)` has multiple values,
  // not for recursion
  language[monotonicAggregates]
  string concretise() {
    result =
      strictconcat(int i |
        hasTuple(_, _, _, this, i)
      |
        this.getAThreewayIntersect(i) order by i desc
      )
  }
}

/**
 * Holds if matching repetitions of `pump` can:
 * 1) Transition from `pivot` back to `pivot`.
 * 2) Transition from `pivot` to `succ`.
 * 3) Transition from `succ` to `succ`.
 *
 * From theorem 3 in the paper linked in the top of this file we can therefore conclude that
 * the regular expression has polynomial backtracking - if a rejecting suffix exists.
 *
 * This predicate is used by `SuperLinearReDoSConfiguration`, and the final results are
 * available in the `hasReDoSResult` predicate.
 */
predicate isPumpable(State pivot, State succ, string pump) {
  exists(StateTuple q, RelevantTrace t |
    isReachableFromStartTuple(pivot, succ, q, t, _) and
    q = getAnEndTuple(pivot, succ) and
    pump = t.concretise()
  )
}

/**
 * Holds if repetitions of `pump` at `t` will cause polynomial backtracking.
 */
predicate polynimalReDoS(RegExpTerm t, string pump, string prefixMsg, RegExpTerm prev) {
  exists(State s, State pivot |
    hasReDoSResult(t, pump, s, prefixMsg) and
    isPumpable(pivot, s, _) and
    prev = pivot.getRepr()
  )
}

/**
 * Gets a message for why `term` can cause polynomial backtracking.
 */
string getReasonString(RegExpTerm term, string pump, string prefixMsg, RegExpTerm prev) {
  polynimalReDoS(term, pump, prefixMsg, prev) and
  result =
    "Strings " + prefixMsg + "with many repetitions of '" + pump +
      "' can start matching anywhere after the start of the preceeding " + prev
}

/**
 * A term that may cause a regular expression engine to perform a
 * polynomial number of match attempts, relative to the input length.
 */
class PolynomialBackTrackingTerm extends InfiniteRepetitionQuantifier {
  string reason;
  string pump;
  string prefixMsg;
  RegExpTerm prev;

  PolynomialBackTrackingTerm() {
    reason = getReasonString(this, pump, prefixMsg, prev) and
    // there might be many reasons for this term to have polynomial backtracking - we pick the shortest one.
    reason = min(string msg | msg = getReasonString(this, _, _, _) | msg order by msg.length(), msg)
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

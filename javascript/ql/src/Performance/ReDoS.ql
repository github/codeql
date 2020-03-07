/**
 * @name Inefficient regular expression
 * @description A regular expression that requires exponential time to match certain inputs
 *              can be a performance bottleneck, and may be vulnerable to denial-of-service
 *              attacks.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/redos
 * @tags security
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

import javascript

/*
 * This query implements the analysis described in the following two papers:
 *
 *   James Kirrage, Asiri Rathnayake, Hayo Thielecke: Static Analysis for
 *     Regular Expression Denial-of-Service Attacks. NSS 2013.
 *     (http://www.cs.bham.ac.uk/~hxt/research/reg-exp-sec.pdf)
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
 * This is what the query does. It makes no attempt to construct a prefix
 * leading into `q`, and only a weak one to construct a suffix that ensures
 * rejection; this causes some false positives. Also, the query does not fully
 * handle character classes and does not handle various other features at all;
 * this causes false negatives.
 *
 * Finally, sometimes it depends on the translation whether the NFA generated
 * for a regular expression has a pumpable fork or not. We implement one
 * particular translation, which may result in false positives or negatives
 * relative to some particular JavaScript engine.
 *
 * More precisely, the query constructs an NFA from a regular expression `r`
 * as follows:
 *
 *   * Every sub-term `t` gives rise to an NFA state `Match(t,i)`, representing
 *     the state of the automaton before attempting to match the `i`th character in `t`.
 *   * There is one additional accepting state `Accept(r)`.
 *   * Transitions between states may be labelled with epsilon, or an abstract
 *     input symbol.
 *   * Each abstract input symbol represents a set of concrete input characters:
 *     either a single character, a set of characters represented by a (positive)
 *     character class, or the set of all characters.
 *   * The product automaton is constructed lazily, starting with pair states
 *     `(q, q)` where `q` is a fork, and proceding along an over-approximate
 *     step relation.
 *   * The over-approximate step relation allows transitions along pairs of
 *     abstract input symbols as long as the symbols are not trivially incompatible.
 *   * Once a trace of pairs of abstract input symbols that leads from a fork
 *     back to itself has been identified, we attempt to construct a concrete
 *     string corresponding to it, which may fail.
 *   * Instead of trying to construct a suffix that makes the automaton fail,
 *     we ensure that it isn't possible to reach the accepting state from the
 *     fork along epsilon transitions. In this case, it is very likely (though
 *     not guaranteed) that a rejecting suffix exists.
 */

/**
 * A branch in a disjunction that is the root node in a literal, or a literal
 * whose root node is not a disjunction.
 */
class RegExpRoot extends RegExpTerm {
  RegExpParent parent;

  RegExpRoot() {
    exists(RegExpAlt alt |
      alt.isRootTerm() and
      this = alt.getAChild() and
      parent = alt.getParent()
    )
    or
    this.isRootTerm() and
    not this instanceof RegExpAlt and
    parent = this.getParent()
  }

  /**
   * Holds if this root term is relevant to the ReDoS analysis.
   */
  predicate isRelevant() {
    // there is at least one repetition
    exists(RegExpRepetition rep | getRoot(rep) = this) and
    // there are no lookbehinds
    not exists(RegExpLookbehind lbh | getRoot(lbh) = this) and
    // is actually used as a RegExp
    isUsedAsRegExp()
  }
}

/**
 * A term that matches repetitions of a given pattern, that is, `E*`, `E+`, or `E{n,m}`.
 */
class RegExpRepetition extends RegExpParent {
  RegExpRepetition() {
    this instanceof RegExpStar or
    this instanceof RegExpPlus or
    this instanceof RegExpRange
  }
}

/**
 * Gets the root containing the given term, that is, the root of the literal,
 * or a branch of the root disjunction.
 */
RegExpRoot getRoot(RegExpTerm term) {
  result = term or
  result = getRoot(term.getParent())
}

/**
 * An abstract input symbol, representing a set of concrete characters.
 */
newtype TInputSymbol =
  /** An input symbol corresponding to character `c`. */
  Char(string c) { c = any(RegExpConstant cc).getValue().charAt(_) } or
  /**
   * An input symbol representing all characters matched by
   * (positive, non-universal) character class `recc`.
   */
  CharClass(RegExpCharacterClass recc) {
    getRoot(recc).isRelevant() and
    not recc.isInverted() and
    not recc.isUniversalClass()
  } or
  /** An input symbol representing all characters matched by `.`. */
  Dot() or
  /** An input symbol representing all characters. */
  Any() or
  /** An epsilon transition in the automaton. */
  Epsilon()

/**
 * An abstract input symbol, representing a set of concrete characters.
 */
class InputSymbol extends TInputSymbol {
  InputSymbol() { not this instanceof Epsilon }

  string toString() {
    this = Char(result)
    or
    result = any(RegExpCharacterClass recc | this = CharClass(recc)).toString()
    or
    this = Dot() and result = "."
    or
    this = Any() and result = "[^]"
  }
}

/**
 * Gets a lower bound on the characters matched by the given character class term.
 */
string getCCLowerBound(RegExpTerm t) {
  t.getParent() instanceof RegExpCharacterClass and
  (
    result = t.(RegExpConstant).getValue()
    or
    t.(RegExpCharacterRange).isRange(result, _)
    or
    exists(string name | name = t.(RegExpCharacterClassEscape).getValue() |
      name = "w" and result = "0"
      or
      name = "W" and result = ""
      or
      name = "s" and result = ""
      or
      name = "S" and result = ""
    )
  )
}

/**
 * The highest character used in a regular expression. Used to represent intervals without an upper bound.
 */
string highestCharacter() { result = max(RegExpConstant c | | c.getValue()) }

/**
 * Gets an upper bound on the characters matched by the given character class term.
 */
string getCCUpperBound(RegExpTerm t) {
  t.getParent() instanceof RegExpCharacterClass and
  (
    result = t.(RegExpConstant).getValue()
    or
    t.(RegExpCharacterRange).isRange(_, result)
    or
    exists(string name | name = t.(RegExpCharacterClassEscape).getValue() |
      name = "w" and result = "z"
      or
      name = "W" and result = highestCharacter()
      or
      name = "s" and result = highestCharacter()
      or
      name = "S" and result = highestCharacter()
    )
  )
}

/**
 * Holds if `s` belongs to `l` and is a character class whose set of matched characters is contained
 * in the interval `lo-hi`.
 */
predicate hasBounds(RegExpRoot l, InputSymbol s, string lo, string hi) {
  exists(RegExpCharacterClass cc | s = CharClass(cc) |
    l = getRoot(cc) and
    lo = min(getCCLowerBound(cc.getAChild())) and
    hi = max(getCCUpperBound(cc.getAChild()))
  )
}

/**
 * Holds if `s1` and `s2` possibly have a non-empty intersection.
 *
 * This predicate is over-approximate; it is only used for pruning the search space.
 */
predicate compatible(InputSymbol s1, InputSymbol s2) {
  exists(RegExpRoot l, string lo1, string lo2, string hi1, string hi2 |
    hasBounds(l, s1, lo1, hi1) and
    hasBounds(l, s2, lo2, hi2) and
    max(string s | s = lo1 or s = lo2) <= min(string s | s = hi1 or s = hi2)
  )
  or
  exists(intersect(s1, s2))
}

newtype TState =
  Match(RegExpTerm t, int i) {
    getRoot(t).isRelevant() and
    (
      i = 0
      or
      exists(t.(RegExpConstant).getValue().charAt(i))
    )
  } or
  Accept(RegExpRoot l) { l.isRelevant() }

/**
 * A state in the NFA corresponding to a regular expression.
 *
 * Each regular expression literal `l` has one accepting state
 * `Accept(l)` and a state `Match(t, i)` for every subterm `t`,
 * which represents the state of the NFA before starting to
 * match `t`, or the `i`th character in `t` if `t` is a constant.
 */
class State extends TState {
  RegExpParent repr;

  State() { this = Match(repr, _) or this = Accept(repr) }

  string toString() {
    exists(int i | this = Match(repr, i) | result = "Match(" + repr + "," + i + ")")
    or
    this instanceof Accept and
    result = "Accept(" + repr + ")"
  }

  Location getLocation() { result = repr.getLocation() }
}

class EdgeLabel extends TInputSymbol {
  string toString() {
    this = Epsilon() and result = ""
    or
    exists(InputSymbol s | this = s and result = s.toString())
  }
}

/**
 * Gets the state before matching `t`.
 */
pragma[inline]
State before(RegExpTerm t) { result = Match(t, 0) }

/**
 * Gets a state the NFA may be in after matching `t`.
 */
State after(RegExpTerm t) {
  exists(RegExpAlt alt | t = alt.getAChild() | result = after(alt))
  or
  exists(RegExpSequence seq, int i | t = seq.getChild(i) |
    result = before(seq.getChild(i + 1))
    or
    i + 1 = seq.getNumChild() and result = after(seq)
  )
  or
  exists(RegExpGroup grp | t = grp.getAChild() | result = after(grp))
  or
  exists(RegExpStar star | t = star.getAChild() | result = before(star))
  or
  exists(RegExpPlus plus | t = plus.getAChild() |
    result = before(plus) or
    result = after(plus)
  )
  or
  exists(RegExpOpt opt | t = opt.getAChild() | result = after(opt))
  or
  exists(RegExpRoot root | t = root | result = Accept(root))
}

/**
 * Holds if the NFA has a transition from `q1` to `q2` labelled with `lbl`.
 */
predicate delta(State q1, EdgeLabel lbl, State q2) {
  exists(RegExpConstant s, int i |
    q1 = Match(s, i) and
    lbl = Char(s.getValue().charAt(i)) and
    (
      q2 = Match(s, i + 1)
      or
      s.getValue().length() = i + 1 and
      q2 = after(s)
    )
  )
  or
  exists(RegExpDot dot | q1 = before(dot) and q2 = after(dot) |
    if dot.getLiteral().isDotAll() then lbl = Any() else lbl = Dot()
  )
  or
  exists(RegExpCharacterClass cc |
    cc.isUniversalClass() and q1 = before(cc) and lbl = Any() and q2 = after(cc)
    or
    q1 = before(cc) and lbl = CharClass(cc) and q2 = after(cc)
  )
  or
  exists(RegExpAlt alt | lbl = Epsilon() | q1 = before(alt) and q2 = before(alt.getAChild()))
  or
  exists(RegExpSequence seq | lbl = Epsilon() | q1 = before(seq) and q2 = before(seq.getChild(0)))
  or
  exists(RegExpGroup grp | lbl = Epsilon() | q1 = before(grp) and q2 = before(grp.getChild(0)))
  or
  exists(RegExpStar star | lbl = Epsilon() |
    q1 = before(star) and q2 = before(star.getChild(0))
    or
    q1 = before(star) and q2 = after(star)
  )
  or
  exists(RegExpPlus plus | lbl = Epsilon() | q1 = before(plus) and q2 = before(plus.getChild(0)))
  or
  exists(RegExpOpt opt | lbl = Epsilon() |
    q1 = before(opt) and q2 = before(opt.getChild(0))
    or
    q1 = before(opt) and q2 = after(opt)
  )
}

/**
 * Gets a state that `q` has an epsilon transition to.
 */
State epsilonSucc(State q) { delta(q, Epsilon(), result) }

/**
 * Gets a state that has an epsilon transition to `q`.
 */
State epsilonPred(State q) { q = epsilonSucc(result) }

/**
 * Holds if there is a state `q` that can be reached from `q1`
 * along epsilon edges, such that there is a transition from
 * `q` to `q2` that consumes symbol `s`.
 */
predicate deltaClosed(State q1, InputSymbol s, State q2) { delta(epsilonSucc*(q1), s, q2) }

/**
 * A state in the product automaton.
 *
 * We lazily only construct those states that we are actually
 * going to need: `(q, q)` for every fork state `q`, and any
 * pair of states that can be reached from a pair that we have
 * already constructed. To cut down on the number of states,
 * we only represent states `(q1, q2)` where `q1` is lexicographically
 * no bigger than `q2`.
 */
newtype TStatePair =
  MkStatePair(State q1, State q2) {
    isFork(q1, _, _, _, _) and q2 = q1
    or
    step(_, _, _, q1, q2) and q1.toString() <= q2.toString()
  }

class StatePair extends TStatePair {
  State q1;
  State q2;

  StatePair() { this = MkStatePair(q1, q2) }

  string toString() { result = "(" + q1 + ", " + q2 + ")" }
}

/**
 * Gets the state pair `(q1, q2)` or `(q2, q1)`; note that only
 * one or the other is defined.
 */
StatePair mkStatePair(State q1, State q2) {
  result = MkStatePair(q1, q2) or result = MkStatePair(q2, q1)
}

predicate isStatePair(StatePair p) { any() }

predicate delta2(StatePair q, StatePair r) { step(q, _, _, r) }

/**
 * Gets the minimum length of a path from `q` to `r` in the
 * product automaton.
 */
int statePairDist(StatePair q, StatePair r) =
  shortestDistances(isStatePair/1, delta2/2)(q, r, result)

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
predicate isFork(State q, InputSymbol s1, InputSymbol s2, State r1, State r2) {
  exists(State q1, State q2 |
    q1 = epsilonSucc*(q) and
    delta(q1, s1, r1) and
    q2 = epsilonSucc*(q) and
    delta(q2, s2, r2) and
    // Use pragma[noopt] to prevent compatible(s1,s2) from being the starting point of the join.
    // From (s1,s2) it would find a huge number of intermediate state pairs (q1,q2) originating from different literals,
    // and discover at the end that no `q` can reach both `q1` and `q2` by epsilon transitions.
    compatible(s1, s2)
  |
    s1 != s2
    or
    r1 != r2
    or
    r1 = r2 and q1 != q2
  )
}

/**
 * Holds if there are transitions from the components of `q` to the corresponding
 * components of `r` labelled with `s1` and `s2`, respectively.
 */
predicate step(StatePair q, InputSymbol s1, InputSymbol s2, StatePair r) {
  exists(State r1, State r2 | step(q, s1, s2, r1, r2) and r = mkStatePair(r1, r2))
}

/**
 * Holds if there are transitions from the components of `q` to `r1` and `r2`
 * labelled with `s1` and `s2`, respectively.
 */
predicate step(StatePair q, InputSymbol s1, InputSymbol s2, State r1, State r2) {
  exists(State q1, State q2 | q = MkStatePair(q1, q2) |
    deltaClosed(q1, s1, r1) and
    deltaClosed(q2, s2, r2) and
    compatible(s1, s2)
  )
}

/**
 * A list of pairs of input symbols that describe a path in the product automaton
 * starting from some fork state.
 */
newtype Trace =
  Nil() or
  Step(InputSymbol s1, InputSymbol s2, Trace t) {
    exists(StatePair p |
      isReachableFromFork(_, p, t, _) and
      step(p, s1, s2, _)
    )
    or
    t = Nil() and isFork(_, s1, s2, _, _)
  }

/**
 * Gets a character that is represented by both `c` and `d`.
 */
string intersect(InputSymbol c, InputSymbol d) {
  c = Char(result) and
  (
    d = Char(result)
    or
    exists(RegExpCharacterClass cc | d = CharClass(cc) |
      exists(RegExpTerm child | child = cc.getAChild() |
        result = child.(RegExpConstant).getValue()
        or
        exists(string lo, string hi | child.(RegExpCharacterRange).isRange(lo, hi) |
          lo <= result and result <= hi
        )
      )
    )
    or
    d = Dot() and
    not (result = "\n" or result = "\r")
    or
    d = Any()
  )
  or
  exists(RegExpCharacterClass cc | c = CharClass(cc) and result = choose(cc) |
    d = CharClass(cc)
    or
    d = Dot() and
    not (result = "\n" or result = "\r")
    or
    d = Any()
  )
  or
  c = Dot() and
  (
    d = Dot() and result = "a"
    or
    d = Any() and result = "a"
  )
  or
  c = Any() and d = Any() and result = "a"
  or
  result = intersect(d, c)
}

/**
 * Gets a character matched by character class `cc`.
 */
string choose(RegExpCharacterClass cc) {
  result =
    min(string c |
      exists(RegExpTerm child | child = cc.getAChild() |
        c = child.(RegExpConstant).getValue() or
        child.(RegExpCharacterRange).isRange(c, _)
      )
    )
}

/**
 * Gets a string corresponding to the trace `t`.
 */
string concretise(Trace t) {
  t = Nil() and result = ""
  or
  exists(InputSymbol s1, InputSymbol s2, Trace rest | t = Step(s1, s2, rest) |
    result = concretise(rest) + intersect(s1, s2)
  )
}

/**
 * Holds if `r` is reachable from `(fork, fork)` under input `w`, and there is
 * a path from `r` back to `(fork, fork)` with `rem` steps.
 */
predicate isReachableFromFork(State fork, StatePair r, Trace w, int rem) {
  exists(InputSymbol s1, InputSymbol s2, State q1, State q2 |
    isFork(fork, s1, s2, q1, q2) and
    r = MkStatePair(q1, q2) and
    w = Step(s1, s2, Nil()) and
    rem = statePairDist(r, MkStatePair(fork, fork))
  )
  or
  exists(StatePair p, Trace v, InputSymbol s1, InputSymbol s2 |
    isReachableFromFork(fork, p, v, rem + 1) and
    step(p, s1, s2, r) and
    w = Step(s1, s2, v) and
    rem > 0
  )
}

/**
 * Gets a state in the product automaton from which `(fork, fork)` is
 * reachable in zero or more epsilon transitions.
 */
StatePair getAForkPair(State fork) {
  isFork(fork, _, _, _, _) and
  result = MkStatePair(epsilonPred*(fork), epsilonPred*(fork))
}

/**
 * Holds if `fork` is a pumpable fork with word `w`.
 */
predicate isPumpable(State fork, string w) {
  exists(StatePair q, Trace t |
    isReachableFromFork(fork, q, t, _) and
    (
      q = getAForkPair(fork) and w = concretise(t)
      or
      exists(InputSymbol s1, InputSymbol s2 |
        step(q, s1, s2, getAForkPair(fork)) and
        w = concretise(Step(s1, s2, t))
      )
    )
  )
}

/**
 * Gets a state that can be reached from pumpable `fork` consuming
 * the first `i+1` characters of `w`.
 *
 * Character classes are overapproximated as intervals; for example,
 * `[a-ln-z]` is treated the same as `[a-z]`, and hence considered
 * to match `m`, even though in fact it does not. This is fine for
 * our purposes, since we only use this predicate to avoid false
 * positives.
 */
State process(State fork, string w, int i) {
  isPumpable(fork, w) and
  exists(State prev |
    i = 0 and prev = fork
    or
    prev = process(fork, w, i - 1)
  |
    exists(InputSymbol s |
      deltaClosed(prev, s, result) and
      exists(intersect(Char(w.charAt(i)), s))
    )
  )
}

/**
 * Gets the result of backslash-escaping newlines, carriage-returns and
 * backslashes in `s`.
 */
bindingset[s]
string escape(string s) {
  result = s.replaceAll("\\", "\\\\").replaceAll("\n", "\\n").replaceAll("\r", "\\r")
}

/**
 * Gets `str` with the last `i` characters moved to the front.
 *
 * We use this to adjust the witness string to match with the beginning of
 * a RegExpTerm, so it doesn't start in the middle of a constant.
 */
bindingset[str, i]
string rotate(string str, int i) {
  result = str.suffix(str.length() - i) + str.prefix(str.length() - i)
}

from RegExpTerm t, string c, int i
where
  c = min(string w | isPumpable(Match(t, i), w)) and
  not isPumpable(epsilonSucc+(Match(t, i)), _) and
  not epsilonSucc*(process(Match(t, i), c, c.length() - 1)) = Accept(_)
select t,
  "This part of the regular expression may cause exponential backtracking on strings " +
    "containing many repetitions of '" + escape(rotate(c, i)) + "'."

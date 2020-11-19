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
 * rejection; this causes some false positives.
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
 *     either a single character, a set of characters represented by a
 *     character class, or the set of all characters.
 *   * The product automaton is constructed lazily, starting with pair states
 *     `(q, q)` where `q` is a fork, and proceding along an over-approximate
 *     step relation.
 *   * The over-approximate step relation allows transitions along pairs of
 *     abstract input symbols where the symbols have overlap in the characters they accept.
 *   * Once a trace of pairs of abstract input symbols that leads from a fork
 *     back to itself has been identified, we attempt to construct a concrete
 *     string corresponding to it, which may fail.
 *   * Instead of trying to construct a suffix that makes the automaton fail,
 *     we ensure that repeating `n` copies of `w` does not reach a state that is
 *     an epsilon transition from the accepting state.
 *     This assumes that the accepting state accepts any suffix.
 *     Regular expressions - where the end anchor `$` is used - have an accepting state
 *     that does not accept all suffixes. Such regular expression not accurately
 *     modelled by this assumption, which can cause false negatives.
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
    exists(RegExpRepetition rep | getRoot(rep) = this |
      // that could possibly match the same thing in multiple ways.
      exists(RegExpTerm child |
        child instanceof RegExpAlt or
        child instanceof RegExpQuantifier
      |
        child.getParent+() = rep
      )
    ) and
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
 * A constant in a regular expression that represents valid Unicode character(s).
 */
class RegexpCharacterConstant extends RegExpConstant {
  RegexpCharacterConstant() { this.isCharacter() }
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
  Char(string c) {
    c = any(RegexpCharacterConstant cc | getRoot(cc).isRelevant()).getValue().charAt(_)
  } or
  /**
   * An input symbol representing all characters matched by
   * (non-universal) character class `recc`.
   */
  CharClass(RegExpTerm recc) {
    getRoot(recc).isRelevant() and
    (
      recc instanceof RegExpCharacterClass and
      not recc.(RegExpCharacterClass).isUniversalClass()
    )
    or
    recc instanceof RegExpCharacterClassEscape
  } or
  /** An input symbol representing all characters matched by `.`. */
  Dot() or
  /** An input symbol representing all characters. */
  Any() or
  /** An epsilon transition in the automaton. */
  Epsilon()

/**
 * Holds if `a` and `b` are input symbols from the same regexp.
 * (And not a `Dot()`, `Any()` or `Epsilon()`)
 */
private predicate sharesRoot(TInputSymbol a, TInputSymbol b) {
  exists(RegExpRoot root |
    belongsTo(a, root) and
    belongsTo(b, root)
  )
}

/**
 * Holds if the `a` is an input symbol from a regexp that has root `root`.
 */
private predicate belongsTo(TInputSymbol a, RegExpRoot root) {
  exists(RegExpTerm term | getRoot(term) = root |
    a = Char(term.(RegexpCharacterConstant).getValue().charAt(_))
    or
    a = CharClass(term)
  )
}

/**
 * An abstract input symbol, representing a set of concrete characters.
 */
class InputSymbol extends TInputSymbol {
  InputSymbol() { not this instanceof Epsilon }

  string toString() {
    this = Char(result)
    or
    result = any(RegExpTerm recc | this = CharClass(recc)).toString()
    or
    this = Dot() and result = "."
    or
    this = Any() and result = "[^]"
  }
}

/**
 * An abstract input symbol that represents a character class.
 */
abstract class CharacterClass extends InputSymbol {
  /**
   * Gets a character that is relevant for intersection-tests involving this
   * character class.
   *
   * Specifically, this is any of the characters mentioned explicitly in the
   * character class, offset by one if it is inverted. For character class escapes,
   * the result is as if the class had been written out as a series of intervals.
   *
   * This set is large enough to ensure that for any two intersecting character
   * classes, one contains a relevant character from the other.
   */
  abstract string getARelevantChar();

  /**
   * Holds if this character class matches `char`.
   */
  bindingset[char]
  abstract predicate matches(string char);

  /**
   * Gets a character matched by this character class.
   */
  string choose() { result = getARelevantChar() and matches(result) }
}

/**
 * Provides implementations for `CharacterClass`.
 */
private module CharacterClasses {
  /**
   * Holds if the character class `cc` has a child (constant or range) that matches `char`.
   */
  pragma[noinline]
  predicate hasChildThatMatches(RegExpCharacterClass cc, string char) {
    exists(CharClass(cc)) and
    exists(RegExpTerm child | child = cc.getAChild() |
      char = child.(RegexpCharacterConstant).getValue()
      or
      rangeMatchesOnLetterOrDigits(child, char)
      or
      not rangeMatchesOnLetterOrDigits(child, _) and
      char = getARelevantChar() and
      exists(string lo, string hi | child.(RegExpCharacterRange).isRange(lo, hi) |
        lo <= char and
        char <= hi
      )
      or
      exists(RegExpCharacterClassEscape escape | escape = child |
        escape.getValue() = escape.getValue().toLowerCase() and
        classEscapeMatches(escape.getValue(), char)
        or
        char = getARelevantChar() and
        escape.getValue() = escape.getValue().toUpperCase() and
        not classEscapeMatches(escape.getValue().toLowerCase(), char)
      )
    )
  }

  /**
   * Holds if `range` is a range on lower-case, upper-case, or digits, and matches `char`.
   * This predicate is used to restrict the searchspace for ranges by only joining `getAnyPossiblyMatchedChar`
   * on a few ranges.
   */
  private predicate rangeMatchesOnLetterOrDigits(RegExpCharacterRange range, string char) {
    exists(string lo, string hi |
      range.isRange(lo, hi) and lo = lowercaseLetter() and hi = lowercaseLetter()
    |
      lo <= char and
      char <= hi and
      char = lowercaseLetter()
    )
    or
    exists(string lo, string hi |
      range.isRange(lo, hi) and lo = upperCaseLetter() and hi = upperCaseLetter()
    |
      lo <= char and
      char <= hi and
      char = upperCaseLetter()
    )
    or
    exists(string lo, string hi | range.isRange(lo, hi) and lo = digit() and hi = digit() |
      lo <= char and
      char <= hi and
      char = digit()
    )
  }

  private string lowercaseLetter() { result = "abdcefghijklmnopqrstuvwxyz".charAt(_) }

  private string upperCaseLetter() { result = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".charAt(_) }

  private string digit() { result = [0 .. 9].toString() }

  /**
   * Gets a char that could be matched by a regular expression.
   * Includes all printable ascii chars, all constants mentioned in a regexp, and all chars matches by the regexp `/\s|\d|\w/`.
   */
  string getARelevantChar() {
    exists(ascii(result))
    or
    exists(RegexpCharacterConstant c | result = c.getValue().charAt(_))
    or
    classEscapeMatches(_, result)
  }

  /**
   * Gets a char that is mentioned in the character class `c`.
   */
  private string getAMentionedChar(RegExpCharacterClass c) {
    exists(RegExpTerm child | child = c.getAChild() |
      result = child.(RegexpCharacterConstant).getValue()
      or
      child.(RegExpCharacterRange).isRange(result, _)
      or
      child.(RegExpCharacterRange).isRange(_, result)
      or
      exists(RegExpCharacterClassEscape escape | child = escape |
        result = min(string s | classEscapeMatches(escape.getValue().toLowerCase(), s))
        or
        result = max(string s | classEscapeMatches(escape.getValue().toLowerCase(), s))
      )
    )
  }

  /**
   * An implementation of `CharacterClass` for positive (non inverted) character classes.
   */
  private class PositiveCharacterClass extends CharacterClass {
    RegExpCharacterClass cc;

    PositiveCharacterClass() { this = CharClass(cc) and not cc.isInverted() }

    override string getARelevantChar() { result = getAMentionedChar(cc) }

    override predicate matches(string char) { hasChildThatMatches(cc, char) }
  }

  /**
   * An implementation of `CharacterClass` for inverted character classes.
   */
  private class InvertedCharacterClass extends CharacterClass {
    RegExpCharacterClass cc;

    InvertedCharacterClass() { this = CharClass(cc) and cc.isInverted() }

    override string getARelevantChar() {
      result = nextChar(getAMentionedChar(cc)) or
      nextChar(result) = getAMentionedChar(cc)
    }

    bindingset[char]
    override predicate matches(string char) { not hasChildThatMatches(cc, char) }
  }

  /**
   * Holds if the character class escape `clazz` (\d, \s, or \w) matches `char`.
   */
  pragma[noinline]
  private predicate classEscapeMatches(string clazz, string char) {
    clazz = "d" and
    char = "0123456789".charAt(_)
    or
    clazz = "s" and
    (
      char = [" ", "\t", "\r", "\n"]
      or
      char = getARelevantChar() and
      char.regexpMatch("\\u000b|\\u000c") // \v|\f (vertical tab | form feed)
    )
    or
    clazz = "w" and
    char = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_".charAt(_)
  }

  /**
   * An implementation of `CharacterClass` for \d, \s, and \w.
   */
  private class PositiveCharacterClassEscape extends CharacterClass {
    RegExpCharacterClassEscape cc;

    PositiveCharacterClassEscape() { this = CharClass(cc) and cc.getValue() = ["d", "s", "w"] }

    override string getARelevantChar() {
      cc.getValue() = "d" and
      result = ["0", "9"]
      or
      cc.getValue() = "s" and
      result = [" "]
      or
      cc.getValue() = "w" and
      result = ["a", "Z", "_", "0", "9"]
    }

    override predicate matches(string char) { classEscapeMatches(cc.getValue(), char) }

    override string choose() {
      cc.getValue() = "d" and
      result = "9"
      or
      cc.getValue() = "s" and
      result = [" "]
      or
      cc.getValue() = "w" and
      result = "a"
    }
  }

  /**
   * An implementation of `CharacterClass` for \D, \S, and \W.
   */
  private class NegativeCharacterClassEscape extends CharacterClass {
    RegExpCharacterClassEscape cc;

    NegativeCharacterClassEscape() { this = CharClass(cc) and cc.getValue() = ["D", "S", "W"] }

    override string getARelevantChar() {
      cc.getValue() = "D" and
      result = ["a", "Z", "!"]
      or
      cc.getValue() = "S" and
      result = ["a", "9", "!"]
      or
      cc.getValue() = "W" and
      result = [" ", "!"]
    }

    bindingset[char]
    override predicate matches(string char) {
      not classEscapeMatches(cc.getValue().toLowerCase(), char)
    }
  }
}

newtype TState =
  Match(RegExpTerm t, int i) {
    getRoot(t).isRelevant() and
    (
      i = 0
      or
      exists(t.(RegexpCharacterConstant).getValue().charAt(i))
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
  exists(RegexpCharacterConstant s, int i |
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
    q1 = before(cc) and
    lbl = CharClass(cc) and
    q2 = after(cc)
  )
  or
  exists(RegExpCharacterClassEscape cc |
    q1 = before(cc) and
    lbl = CharClass(cc) and
    q2 = after(cc)
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

  State getLeft() { result = q1 }

  State getRight() { result = q2 }
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
pragma[noopt]
predicate step(StatePair q, InputSymbol s1, InputSymbol s2, State r1, State r2) {
  exists(State q1, State q2 | q.getLeft() = q1 and q.getRight() = q2 |
    deltaClosed(q1, s1, r1) and
    deltaClosed(q2, s2, r2) and
    // use noopt to force the join on `intersect` to happen last.
    exists(intersect(s1, s2))
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
 * Gets the minimum char that is matched by both the character classes `c` and `d`.
 */
private string getMinOverlapBetweenCharacterClasses(CharacterClass c, CharacterClass d) {
  result = min(getAOverlapBetweenCharacterClasses(c, d))
}

/**
 * Gets a char that is matched by both the character classes `c` and `d`.
 * And `c` and `d` is not the same character class.
 */
private string getAOverlapBetweenCharacterClasses(CharacterClass c, CharacterClass d) {
  sharesRoot(c, d) and
  result = [c.getARelevantChar(), d.getARelevantChar()] and
  c.matches(result) and
  d.matches(result) and
  not c = d
}

/**
 * Gets a character that is represented by both `c` and `d`.
 */
string intersect(InputSymbol c, InputSymbol d) {
  c = Char(result) and
  d = getAnInputSymbolMatching(result) and
  (
    sharesRoot(c, d)
    or
    d = Dot()
    or
    d = Any()
  )
  or
  result = getMinOverlapBetweenCharacterClasses(c, d)
  or
  result = c.(CharacterClass).choose() and
  (
    d = c
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
 * Gets a symbol that matches `char`.
 */
bindingset[char]
InputSymbol getAnInputSymbolMatching(string char) {
  result = Char(char)
  or
  result.(CharacterClass).matches(char)
  or
  result = Dot() and
  not (char = "\n" or char = "\r")
  or
  result = Any()
}

/**
 * Gets the char after `c` (from a simplified ASCII table).
 */
string nextChar(string c) { exists(int code | code = ascii(c) | code + 1 = ascii(result)) }

/**
 * Gets an approximation for the ASCII code for `char`.
 * Only the easily printable chars are included (so no newline, tab, null, etc).
 */
int ascii(string char) {
  char =
    rank[result](string c |
      c =
        "! \"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
            .charAt(_)
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
  // base case
  exists(InputSymbol s1, InputSymbol s2, State q1, State q2 |
    isFork(fork, s1, s2, q1, q2) and
    r = MkStatePair(q1, q2) and
    w = Step(s1, s2, Nil()) and
    rem = statePairDist(r, MkStatePair(fork, fork))
  )
  or
  // recursive case
  exists(StatePair p, Trace v, InputSymbol s1, InputSymbol s2 |
    isReachableFromFork(fork, p, v, rem + 1) and
    step(p, s1, s2, r) and
    w = Step(s1, s2, v) and
    rem >= statePairDist(r, MkStatePair(fork, fork))
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
 * Gets a state that can be reached from pumpable `fork` consuming all
 * chars in `w` any number of times followed by the first `i+1` characters of `w`.
 *
 * This predicate is used to ensure that the accepting state is not reached from the fork by repeating `w`.
 * This works under the assumption that any accepting state accepts all suffixes.
 * For example, a regexp like `/^(a+)+/` will accept any string as long the prefix is some number of `"a"`s,
 * and it is therefore not possible to construct a rejected suffix.
 * This assumption breaks on regular expression that use the anchor `$`, e.g: `/^(a+)+$/`, and such regular
 * expression are not accurately modeled by this query.
 *
 * The string `w` is repeated any number of times because it needs to be
 * infinitely repeatedable for the attack to work.
 * For a regular expression `/((ab)+)*abab/` the accepting state is not reachable from the fork
 * using epsilon transitions. But any attempt at repeating `w` will end in the accepting state.
 * This also relies on the assumption that any accepting state will accept all suffixes.
 */
State process(State fork, string w, int i) {
  isPumpable(fork, w) and
  exists(State prev |
    i = 0 and prev = fork
    or
    prev = process(fork, w, i - 1)
    or
    // repeat until fixpoint
    i = 0 and
    prev = process(fork, w, w.length() - 1)
  |
    deltaClosed(prev, getAnInputSymbolMatching(w.charAt(i)), result)
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
  c =
    min(string w |
      isPumpable(Match(t, i), w) and
      not isPumpable(epsilonSucc+(Match(t, i)), _) and
      not epsilonSucc*(process(Match(t, i), w, _)) = Accept(_)
    |
      w order by w.length(), w
    )
select t,
  "This part of the regular expression may cause exponential backtracking on strings " +
    "containing many repetitions of '" + escape(rotate(c, i)) + "'."

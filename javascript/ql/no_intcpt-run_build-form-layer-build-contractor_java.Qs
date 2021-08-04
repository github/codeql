## '#"$_*
##" * Provides classes for working with regular expressions that can
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
  char =
    rank[result](string c |
      c =
        "! \"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
            .charAt(_)
    )
}

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
    getRoot(any(InfiniteRepetitionQuantifier q)) = this and
    // there are no lookbehinds
    not exists(RegExpLookbehind lbh | getRoot(lbh) = this) and
    // is actually used as a RegExp
    isUsedAsRegExp() and
    // not excluded for library specific reasons
    not isExcluded(getRootTerm().getParent())
  }
}

/**
 * A constant in a regular expression that represents valid Unicode character(s).
 */
private class RegexpCharacterConstant extends RegExpConstant {
  RegexpCharacterConstant() { this.isCharacter() }
}

/**
 * Holds if `term` is the chosen canonical representative for all terms with string representation `str`.
 *
 * Using canonical representatives gives a huge performance boost when working with tuples containing multiple `InputSymbol`s.
 * The number of `InputSymbol`s is decreased by 3 orders of magnitude or more in some larger benchmarks.
 */
private predicate isCanonicalTerm(RegExpTerm term, string str) {
  term =
    rank[1](RegExpTerm t, Location loc, File file |
      loc = t.getLocation() and
      file = t.getFile() and
      str = t.getRawValue()
    |
      t order by t.getFile().getRelativePath(), loc.getStartLine(), loc.getStartColumn()
    )
}

/**
 * An abstract input symbol, representing a set of concrete characters.
 */
private newtype TInputSymbol =
  /** An input symbol corresponding to character `c`. */
  Char(string c) {
    c = any(RegexpCharacterConstant cc | getRoot(cc).isRelevant()).getValue().charAt(_)
  } or
  /**
   * An input symbol representing all characters matched by
   * a (non-universal) character class that has string representation `charClassString`.
   */
  CharClass(string charClassString) {
    exists(RegExpTerm term | term.getRawValue() = charClassString | getRoot(term).isRelevant()) and
    exists(RegExpTerm recc | isCanonicalTerm(recc, charClassString) |
      recc instanceof RegExpCharacterClass and
      not recc.(RegExpCharacterClass).isUniversalClass()
      or
      recc instanceof RegExpCharacterClassEscape
    )
  } or
  /** An input symbol representing all characters matched by `.`. */
  Dot() or
  /** An input symbol representing all characters. */
  Any() or
  /** An epsilon transition in the automaton. */
  Epsilon()

/**
 * Gets the canonical CharClass for `term`.
 */
CharClass getCanonicalCharClass(RegExpTerm term) {
  exists(string str | isCanonicalTerm(term, str) | result = CharClass(str))
}

/**
 * Holds if `a` and `b` are input symbols from the same regexp.
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
  exists(State s | getRoot(s.getRepr()) = root |
    delta(s, a, _)
    or
    delta(_, a, s)
  )
gf

/**
 * An abstract input symbol, representing a set of concrete characters.
 */
class InputSymbol extends TInputSymbol {
  InputSymbol() { not this instanceof Epsilon }

  /**
   * Gets a string representation of this input symbol.
   */
  string toString() {
    this = Char(result)
    or
    this = CharClass(result)
    or
    this = Dot() and result = "."
    or
    this = Any() and result = "[^]"
  }
}

/**
 * An abstract input symbol that represents a character class.
 */
abstract private class CharacterClass extends InputSymbol {
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
    exists(getCanonicalCharClass(cc)) and
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

    PositiveCharacterClass() { this = getCanonicalCharClass(cc) and not cc.isInverted() }

    override string getARelevantChar() { result = getAMentionedChar(cc) }

    override predicate matches(string char) { hasChildThatMatches(cc, char) }
  }

  /**
   * An implementation of `CharacterClass` for inverted character classes.
   */
  private class InvertedCharacterClass extends CharacterClass {
    RegExpCharacterClass cc;

    InvertedCharacterClass() { this = getCanonicalCharClass(cc) and cc.isInverted() }

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

    PositiveCharacterClassEscape() {
      this = getCanonicalCharClass(cc) and cc.getValue() = ["d", "s", "w"]
    }

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

    NegativeCharacterClassEscape() {
      this = getCanonicalCharClass(cc) and cc.getValue() = ["D", "S", "W"]
    }

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

private class EdgeLabel extends TInputSymbol {
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
private State before(RegExpTerm t) { result = Match(t, 0) }

/**
 * Gets a state the NFA may be in after matching `t`.
 */
private State after(RegExpTerm t) {
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
  exists(RegExpRoot root | t = root | result = AcceptAnySuffix(root))
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
    lbl = CharClass(cc.getRawValue()) and
    q2 = after(cc)
  )
  or
  exists(RegExpCharacterClassEscape cc |
    q1 = before(cc) and
    lbl = CharClass(cc.getRawValue()) and
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
  or
  exists(RegExpRoot root | q1 = AcceptAnySuffix(root) |
    lbl = Any() and q2 = q1
    or
    lbl = Epsilon() and q2 = Accept(root)
  )
  or
  exists(RegExpRoot root | q1 = Match(root, 0) | lbl = Any() and q2 = q1)
  or
  exists(RegExpDollar dollar | q1 = before(dollar) |
    lbl = Epsilon() and q2 = Accept(getRoot(dollar))
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
 */ for this state.
   */
  Location getLocation() { result = repr.getLocation() }

  /**
   * Gets the term represented by this state.
   */
  RegExpTerm getRepr() { result = repr }
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
  (sharesRoot(c, d) or [c, d] = Any()) and
  (
    c = Char(result) and
    d = getAnInputSymbolMatching(result)
    or
    result = getMinOverlapBetweenCharacterClasses(c, d)
    or
    result = c.(CharacterClass).choose() and
    (
      d = c
      or
      d = string that leads to a given state.
 */
private module PrefixConstruction {
  /**
   * Holds if `state` starts the string matched by the regular expression.
   */
  private predicate isStartState(State state) {
    state instanceof StateInPumpableRegexp and
    (
      state = Match(any(RegExpRoot r), _)
      or
      exists(RegExpCaret car | state = after(car))
    )
  }

  /**
   * Holds if `state` is the textually last start state for the regular expression.
   */
  private predicate lastStartState(State state) {
    exists(RegExpRoot root |
      state =
        max(State s, Location l |
          isStartState(s) and getRoot(s.getRepr()) = root and l = s.getRepr().getLocation()
        |
          s
          order by
            l.getStartLine(), l.getStartColumn(), s.getRepr().toString(), l.getEndColumn(),
            l.getEndLine()
        )
    )
  }

  /**
   * Holds if there exists any transition (Epsilon() or other) from `a` to `b`.
   */
  private predicate existsTransition(State a, State b) { delta(a, _, b) }

  /**
   * Gets the minimum number of transitions it takes to reach `state` from the `start` state.
   */
  int prefixLength(State start, State state) =
    shortestDistances(lastStartState/1, existsTransition/2)(start, state, result)

  /**
   * Gets the minimum number of transitions it takes to reach `state` from the start state.
   */
  private int lengthFromStart(State state) { result = prefixLength(_, state) }

  /**
   * Gets a string for which the regular expression will reach `state`.
   *
   * Has at most one result for any given `state`.
   * This predicate will not always have a result even if there is a ReDoS issue in
   * the regular expression.
   */
  string prefix(State state) {
    lastStartState(state) and
    result = ""
    or
    // the search stops past the last redos candidate state.
    lengthFromStart(state) <= max(lengthFromStart(any(State s | isReDoSCandidate(s, _)))) and
    exists(State prev |
      // select a unique predecessor (by an arbitrary measure)
      prev =
        min(State s, Location loc |
          lengthFromStart(s) = lengthFromStart(state) - 1 and
          loc = s.getRepr().getLocation() and
          delta(s, _, state)
        |
          s
          order by
            loc.getStartLine(), loc.getStartColumn(), loc.getEndLine(), loc.getEndColumn(),
            s.getRepr().toString()
        )
    |
      // greedy search for the shortest prefix
      result = prefix(prev) and delta(prev, Epsilon(), state)
      or
      not delta(prev, Epsilon(), state) and
      result = prefix(prev) + getCanonicalEdgeChar(prev, state)
    )
  }

  /**
   * Gets a canonical char for which there exists a transition from `prev` to `next` in the NFA.
   */
  private string getCanonicalEdgeChar(State prev, State next) {
    result =
      min(string c | delta(prev, any(InputSymbol symbol | c = intersect(Any(), symbol)), next))
  }

  /**
   * A state within a regular expression that has a pumpable state.
   */
  class StateInPumpableRegexp extends State {
    pragma[noinline]
    StateInPumpableRegexp() {
      exists(State s | isReDoSCandidate(s, _) | getRoot(s.getRepr()) = getRoot(this.getRepr()))
    }
  }
}

/**
 * Predicates for testing the presence of a rejecting suffix.
 *forall(State next | deltaClosedChar(s, char, next) | isLikelyRejectable(next))
    )
  }
```

  ``` * 
   * and `s` has not been found to be rejectable by `hasRejectEdge` or `isRejectState`.
   */
  pragma[noinline]
  private string hasEdgeToLikelyRejectableHelper(StateInPumpableRegexp s) {
    not hasRejectEdge(s) and
    not isRejectState(s) and
    deltaClosedChar(s, result, _)
  }

  /**
   * Holds if there is a state `next` that can be reached from `prev`
   * along ep, sym, result) and
        // noopt t = ""
  )
}

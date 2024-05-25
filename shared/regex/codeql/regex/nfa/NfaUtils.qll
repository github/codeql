/**
 * A shared library for creating and reasoning about NFA's.
 */

private import codeql.regex.RegexTreeView
private import codeql.util.Numbers
private import codeql.util.Strings

/**
 * Classes and predicates that create an NFA and various algorithms for working with it.
 */
module Make<RegexTreeViewSig TreeImpl> {
  private import TreeImpl

  /**
   * Gets the char after `c` (from a simplified ASCII table).
   */
  private string nextChar(string c) {
    exists(int code | code = asciiPrintable(c) | code + 1 = asciiPrintable(result))
  }

  /**
   * Holds if `t` matches at least an epsilon symbol.
   *
   * That is, this term does not restrict the language of the enclosing regular expression.
   *
   * This is implemented as an under-approximation, and this predicate does not hold for sub-patterns in particular.
   */
  predicate matchesEpsilon(RegExpTerm t) {
    t instanceof RegExpStar
    or
    t instanceof RegExpOpt
    or
    t.(RegExpRange).getLowerBound() = 0
    or
    exists(RegExpTerm child |
      child = t.getAChild() and
      matchesEpsilon(child)
    |
      t instanceof RegExpAlt or
      t instanceof RegExpGroup or
      t instanceof RegExpPlus or
      t instanceof RegExpRange
    )
    or
    matchesEpsilon(t.(RegExpBackRef).getGroup())
    or
    forex(RegExpTerm child | child = t.(RegExpSequence).getAChild() | matchesEpsilon(child))
  }

  final private class FinalRegExpSubPattern = RegExpSubPattern;

  /**
   * A lookahead/lookbehind that matches the empty string.
   */
  class EmptyPositiveSubPattern extends FinalRegExpSubPattern {
    EmptyPositiveSubPattern() {
      (
        this instanceof RegExpPositiveLookahead
        or
        this instanceof RegExpPositiveLookbehind
      ) and
      matchesEpsilon(this.getOperand())
    }
  }

  final private class FinalRegExpTerm = RegExpTerm;

  /**
   * A branch in a disjunction that is the root node in a literal, or a literal
   * whose root node is not a disjunction.
   */
  class RegExpRoot extends FinalRegExpTerm {
    RegExpRoot() {
      exists(RegExpParent parent |
        exists(RegExpAlt alt |
          alt.isRootTerm() and
          this = alt.getAChild() and
          parent = alt.getParent()
        )
        or
        this.isRootTerm() and
        not this instanceof RegExpAlt and
        parent = this.getParent()
      )
    }

    /**
     * Holds if this root term is relevant to the ReDoS analysis.
     */
    predicate isRelevant() {
      // is actually used as a RegExp
      super.isUsedAsRegExp() and
      // not excluded for library specific reasons
      not isExcluded(super.getRootTerm().getParent())
    }
  }

  /**
   * A constant in a regular expression that represents valid Unicode character(s).
   */
  private class RegexpCharacterConstant instanceof RegExpConstant {
    RegexpCharacterConstant() { this.isCharacter() }

    string toString() { result = this.(RegExpConstant).toString() }

    RegExpTerm getRootTerm() { result = this.(RegExpConstant).getRootTerm() }

    string getValue() { result = this.(RegExpConstant).getValue() }
  }

  /**
   * A regexp term that is relevant for this ReDoS analysis.
   */
  class RelevantRegExpTerm extends FinalRegExpTerm {
    RelevantRegExpTerm() { getRoot(this).isRelevant() }
  }

  /**
   * Gets a string for the full location of `t`.
   */
  bindingset[t]
  pragma[inline_late]
  string getTermLocationString(RegExpTerm t) {
    exists(string file, int startLine, int startColumn, int endLine, int endColumn |
      t.hasLocationInfo(file, startLine, startColumn, endLine, endColumn) and
      result = file + ":" + startLine + ":" + startColumn + "-" + endLine + ":" + endColumn
    )
  }

  /**
   * Holds if `term` is the chosen canonical representative for all terms with string representation `str`.
   * The string representation includes which flags are used with the regular expression.
   *
   * Using canonical representatives gives a huge performance boost when working with tuples containing multiple `InputSymbol`s.
   * The number of `InputSymbol`s is decreased by 3 orders of magnitude or more in some larger benchmarks.
   */
  private predicate isCanonicalTerm(RelevantRegExpTerm term, string str) {
    term =
      min(RelevantRegExpTerm t |
        str = getCanonicalizationString(t)
      |
        t order by getTermLocationString(t), t.toString()
      )
  }

  /**
   * Gets a string representation of `term` that is used for canonicalization.
   */
  private string getCanonicalizationString(RelevantRegExpTerm term) {
    exists(string ignoreCase |
      (if isIgnoreCase(term.getRootTerm()) then ignoreCase = "i" else ignoreCase = "") and
      result = term.getRawValue() + "|" + ignoreCase
    )
  }

  /**
   * An abstract input symbol, representing a set of concrete characters.
   */
  private newtype TInputSymbol =
    /** An input symbol corresponding to character `c`. */
    Char(string c) {
      c =
        getACodepoint(any(RegexpCharacterConstant cc |
            cc instanceof RelevantRegExpTerm and
            not isIgnoreCase(cc.getRootTerm())
          ).getValue())
      or
      // normalize everything to lower case if the regexp is case insensitive
      c =
        any(RegexpCharacterConstant cc, string char |
          cc instanceof RelevantRegExpTerm and
          isIgnoreCase(cc.getRootTerm()) and
          char = getACodepoint(cc.getValue())
        |
          char.toLowerCase()
        )
    } or
    /**
     * An input symbol representing all characters matched by
     * a (non-universal) character class that has string representation `charClassString`.
     */
    CharClass(string charClassString) {
      exists(RelevantRegExpTerm recc | isCanonicalTerm(recc, charClassString) |
        recc instanceof RegExpCharacterClass and
        not recc.(RegExpCharacterClass).isUniversalClass()
        or
        isEscapeClass(recc, _)
      )
    } or
    /** An input symbol representing all characters matched by `.`. */
    Dot() or
    /** An input symbol representing all characters. */
    Any() or
    /** An epsilon transition in the automaton. */
    Epsilon()

  /**
   * Gets the the CharClass corresponding to the canonical representative `term`.
   */
  private CharClass getCharClassForCanonicalTerm(RegExpTerm term) {
    exists(string str | isCanonicalTerm(term, str) | result = CharClass(str))
  }

  /**
   * Gets a char class that represents `term`, even when `term` is not the canonical representative.
   */
  CharacterClass getCanonicalCharClass(RegExpTerm term) {
    exists(string str | str = getCanonicalizationString(term) and result = CharClass(str))
  }

  /**
   * Holds if `a` and `b` are input symbols from the same regexp.
   */
  private predicate sharesRoot(InputSymbol a, InputSymbol b) {
    exists(RegExpRoot root |
      belongsTo(a, root) and
      belongsTo(b, root)
    )
  }

  /**
   * Holds if the `a` is an input symbol from a regexp that has root `root`.
   */
  private predicate belongsTo(InputSymbol a, RegExpRoot root) {
    exists(State s | getRoot(s.getRepr()) = root |
      delta(s, a, _)
      or
      delta(_, a, s)
    )
  }

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
    string choose() { result = this.getARelevantChar() and this.matches(result) }
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
      if isIgnoreCase(cc.getRootTerm())
      then
        // normalize everything to lower case if the regexp is case insensitive
        exists(string c | hasChildThatMatchesIgnoringCasingFlags(cc, c) | char = c.toLowerCase())
      else hasChildThatMatchesIgnoringCasingFlags(cc, char)
    }

    /**
     * Holds if the character class `cc` has a child (constant or range) that matches `char`.
     * Ignores whether the character class is inside a regular expression that has the ignore case flag.
     */
    pragma[noinline]
    predicate hasChildThatMatchesIgnoringCasingFlags(RegExpCharacterClass cc, string char) {
      exists(getCharClassForCanonicalTerm(cc)) and
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
        exists(string charClass | isEscapeClass(child, charClass) |
          charClass.toLowerCase() = charClass and
          classEscapeMatches(charClass, char)
          or
          char = getARelevantChar() and
          charClass.toUpperCase() = charClass and
          not classEscapeMatches(charClass, char)
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

    private string lowercaseLetter() { result = "abcdefghijklmnopqrstuvwxyz".charAt(_) }

    private string upperCaseLetter() { result = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".charAt(_) }

    private string digit() { result = [0 .. 9].toString() }

    /**
     * Gets a char that could be matched by a regular expression.
     * Includes all printable ascii chars, all constants mentioned in a regexp, and all chars matches by the regexp `/\s|\d|\w/`.
     */
    string getARelevantChar() {
      exists(asciiPrintable(result))
      or
      exists(RegexpCharacterConstant c | result = getACodepoint(c.getValue()))
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
        exists(string charClass | isEscapeClass(child, charClass) |
          result = min(string s | classEscapeMatches(charClass.toLowerCase(), s))
          or
          result = max(string s | classEscapeMatches(charClass.toLowerCase(), s))
        )
      )
    }

    bindingset[char, cc]
    private string caseNormalize(string char, RegExpTerm cc) {
      if isIgnoreCase(cc.getRootTerm()) then result = char.toLowerCase() else result = char
    }

    /**
     * An implementation of `CharacterClass` for positive (non inverted) character classes.
     */
    private class PositiveCharacterClass extends CharacterClass {
      RegExpCharacterClass cc;

      PositiveCharacterClass() { this = getCharClassForCanonicalTerm(cc) and not cc.isInverted() }

      override string getARelevantChar() { result = caseNormalize(getAMentionedChar(cc), cc) }

      override predicate matches(string char) { hasChildThatMatches(cc, char) }
    }

    /**
     * An implementation of `CharacterClass` for inverted character classes.
     */
    private class InvertedCharacterClass extends CharacterClass {
      RegExpCharacterClass cc;

      InvertedCharacterClass() { this = getCharClassForCanonicalTerm(cc) and cc.isInverted() }

      override string getARelevantChar() {
        result = nextChar(caseNormalize(getAMentionedChar(cc), cc)) or
        nextChar(result) = caseNormalize(getAMentionedChar(cc), cc)
      }

      bindingset[char]
      override predicate matches(string char) {
        not hasChildThatMatches(cc, char) and
        (
          // detect unsupported char classes that doesn't match anything (e.g. `\p{L}` in ruby), and don't report any matches
          hasChildThatMatches(cc, _)
          or
          not exists(cc.getAChild()) // [^] still matches everything
        )
      }
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
      char = [" ", "\t", "\r", "\n", 11.toUnicode(), 12.toUnicode()] // 11.toUnicode() = \v, 12.toUnicode() = \f
      or
      clazz = "w" and
      char = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_".charAt(_)
    }

    /**
     * An implementation of `CharacterClass` for \d, \s, and \w.
     */
    private class PositiveCharacterClassEscape extends CharacterClass {
      string charClass;
      RegExpTerm cc;

      PositiveCharacterClassEscape() {
        isEscapeClass(cc, charClass) and
        this = getCharClassForCanonicalTerm(cc) and
        charClass = ["d", "s", "w"]
      }

      override string getARelevantChar() {
        charClass = "d" and
        result = ["0", "9"]
        or
        charClass = "s" and
        result = " "
        or
        charClass = "w" and
        if isIgnoreCase(cc.getRootTerm())
        then result = ["a", "z", "_", "0", "9"]
        else result = ["a", "Z", "_", "0", "9"]
      }

      override predicate matches(string char) { classEscapeMatches(charClass, char) }

      override string choose() {
        charClass = "d" and
        result = "9"
        or
        charClass = "s" and
        result = " "
        or
        charClass = "w" and
        result = "a"
      }
    }

    /**
     * An implementation of `CharacterClass` for \D, \S, and \W.
     */
    private class NegativeCharacterClassEscape extends CharacterClass {
      string charClass;

      NegativeCharacterClassEscape() {
        exists(RegExpTerm cc |
          isEscapeClass(cc, charClass) and
          this = getCharClassForCanonicalTerm(cc) and
          charClass = ["D", "S", "W"]
        )
      }

      override string getARelevantChar() {
        charClass = "D" and
        result = ["a", "Z", "!"]
        or
        charClass = "S" and
        result = ["a", "9", "!"]
        or
        charClass = "W" and
        result = [" ", "!"]
      }

      bindingset[char]
      override predicate matches(string char) {
        not classEscapeMatches(charClass.toLowerCase(), char) and
        // detect unsupported char classes (e.g. `\p{L}` in ruby), and don't report any matches
        classEscapeMatches(charClass.toLowerCase(), _)
      }
    }

    /** Gets a representative for all char classes that match the same chars as `c`. */
    CharacterClass normalize(CharacterClass c) {
      exists(string normalization |
        normalization = getNormalizationString(c) and
        result =
          min(CharacterClass cc, string raw |
            getNormalizationString(cc) = normalization and cc = CharClass(raw)
          |
            cc order by raw
          )
      )
    }

    /** Gets a string representing all the chars matched by `c` */
    private string getNormalizationString(CharacterClass c) {
      (c instanceof PositiveCharacterClass or c instanceof PositiveCharacterClassEscape) and
      result = concat(string char | c.matches(char) and char = CharacterClasses::getARelevantChar())
      or
      (c instanceof InvertedCharacterClass or c instanceof NegativeCharacterClassEscape) and
      // the string produced by the concat can not contain repeated chars
      // so by starting the below with "nn" we can guarantee that
      // it will not overlap with the above case.
      // and a negative char class can never match the same chars as a positive one, so we don't miss any results from this.
      result =
        "nn:" +
          concat(string char | not c.matches(char) and char = CharacterClasses::getARelevantChar())
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
   * A RegExp term that acts like a plus.
   * Either it's a RegExpPlus, or it is a range {1,X} where X is >= 30.
   * 30 has been chosen as a threshold because for exponential blowup 2^30 is enough to get a decent DOS attack.
   */
  private class EffectivelyPlus instanceof RegExpTerm {
    EffectivelyPlus() {
      this instanceof RegExpPlus
      or
      exists(RegExpRange range |
        range.getLowerBound() = 1 and
        (range.getUpperBound() >= 30 or not exists(range.getUpperBound()))
      |
        this = range
      )
    }

    string toString() { result = this.(RegExpTerm).toString() }

    RegExpTerm getAChild() { result = this.(RegExpTerm).getChild(_) }

    RegExpTerm getChild(int i) { result = this.(RegExpTerm).getChild(i) }
  }

  /**
   * A RegExp term that acts like a star.
   * Either it's a RegExpStar, or it is a range {0,X} where X is >= 30.
   */
  private class EffectivelyStar instanceof RegExpTerm {
    EffectivelyStar() {
      this instanceof RegExpStar
      or
      exists(RegExpRange range |
        range.getLowerBound() = 0 and
        (range.getUpperBound() >= 30 or not exists(range.getUpperBound()))
      |
        this = range
      )
    }

    string toString() { result = this.(RegExpTerm).toString() }

    RegExpTerm getAChild() { result = this.(RegExpTerm).getAChild() }

    RegExpTerm getChild(int i) { result = this.(RegExpTerm).getChild(i) }
  }

  /**
   * A RegExp term that acts like a question mark.
   * Either it's a RegExpQuestion, or it is a range {0,1}.
   */
  private class EffectivelyQuestion instanceof RegExpTerm {
    EffectivelyQuestion() {
      this instanceof RegExpOpt
      or
      exists(RegExpRange range | range.getLowerBound() = 0 and range.getUpperBound() = 1 |
        this = range
      )
    }

    string toString() { result = this.(RegExpTerm).toString() }

    RegExpTerm getAChild() { result = this.(RegExpTerm).getAChild() }

    RegExpTerm getChild(int i) { result = this.(RegExpTerm).getChild(i) }
  }

  /**
   * Gets the state before matching `t`.
   */
  pragma[inline]
  private State before(RegExpTerm t) { result = Match(t, 0) }

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
    exists(EffectivelyStar star | t = star.getAChild() |
      not isPossessive(star) and
      result = before(star)
    )
    or
    exists(EffectivelyPlus plus | t = plus.getAChild() |
      not isPossessive(plus) and
      result = before(plus)
      or
      result = after(plus)
    )
    or
    exists(EffectivelyQuestion opt | t = opt.getAChild() | result = after(opt))
    or
    exists(RegExpRoot root | t = root |
      if matchesAnySuffix(root) then result = AcceptAnySuffix(root) else result = Accept(root)
    )
  }

  pragma[noinline]
  private int getCodepointLengthForState(string s) {
    result = getCodepointLength(s) and
    s = any(RegexpCharacterConstant reg).getValue()
  }

  /**
   * Holds if the NFA has a transition from `q1` to `q2` labelled with `lbl`.
   */
  predicate delta(State q1, EdgeLabel lbl, State q2) {
    exists(RegexpCharacterConstant s, int i |
      q1 = Match(s, i) and
      (
        not isIgnoreCase(s.getRootTerm()) and
        lbl = Char(getCodepointAt(s.getValue(), i))
        or
        // normalize everything to lower case if the regexp is case insensitive
        isIgnoreCase(s.getRootTerm()) and
        exists(string c | c = getCodepointAt(s.getValue(), i) | lbl = Char(c.toLowerCase()))
      ) and
      (
        q2 = Match(s, i + 1)
        or
        getCodepointLengthForState(s.getValue()) = i + 1 and
        q2 = after(s)
      )
    )
    or
    exists(RegExpDot dot | q1 = before(dot) and q2 = after(dot) |
      if isDotAll(dot.getRootTerm()) then lbl = Any() else lbl = Dot()
    )
    or
    exists(RegExpCharacterClass cc |
      cc.isUniversalClass() and q1 = before(cc) and lbl = Any() and q2 = after(cc)
      or
      q1 = before(cc) and
      lbl = CharacterClasses::normalize(CharClass(getCanonicalizationString(cc))) and
      q2 = after(cc)
    )
    or
    exists(RegExpTerm cc | isEscapeClass(cc, _) |
      q1 = before(cc) and
      lbl = CharacterClasses::normalize(CharClass(getCanonicalizationString(cc))) and
      q2 = after(cc)
    )
    or
    exists(RegExpAlt alt | lbl = Epsilon() | q1 = before(alt) and q2 = before(alt.getAChild()))
    or
    exists(RegExpSequence seq | lbl = Epsilon() | q1 = before(seq) and q2 = before(seq.getChild(0)))
    or
    exists(RegExpGroup grp | lbl = Epsilon() | q1 = before(grp) and q2 = before(grp.getChild(0)))
    or
    exists(RegExpGroup grp | lbl = Epsilon() |
      not exists(grp.getAChild()) and
      q1 = before(grp) and
      q2 = before(grp.getSuccessor())
    )
    or
    exists(EffectivelyStar star | lbl = Epsilon() |
      q1 = before(star) and q2 = before(star.getChild(0))
      or
      q1 = before(star) and q2 = after(star)
    )
    or
    exists(EffectivelyPlus plus | lbl = Epsilon() |
      q1 = before(plus) and q2 = before(plus.getChild(0))
    )
    or
    exists(EffectivelyQuestion opt | lbl = Epsilon() |
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
    exists(RegExpRoot root | q1 = Match(root, 0) |
      matchesAnyPrefix(root) and lbl = Any() and q2 = q1
    )
    or
    exists(RegExpDollar dollar | q1 = before(dollar) |
      lbl = Epsilon() and q2 = Accept(getRoot(dollar))
    )
    or
    exists(EmptyPositiveSubPattern empty | q1 = before(empty) |
      lbl = Epsilon() and q2 = after(empty)
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
   * Gets the root containing the given term, that is, the root of the literal,
   * or a branch of the root disjunction.
   */
  RegExpRoot getRoot(RegExpTerm term) {
    result = term or
    result = getRoot(term.getParent())
  }

  /**
   * A state in the NFA.
   */
  newtype TState =
    /**
     * A state representing that the NFA is about to match a term.
     * `i` is used to index into multi-char literals.
     */
    Match(RelevantRegExpTerm t, int i) {
      i = 0
      or
      exists(getCodepointAt(t.(RegexpCharacterConstant).getValue(), i))
    } or
    /**
     * An accept state, where exactly the given input string is accepted.
     */
    Accept(RegExpRoot l) { l.isRelevant() } or
    /**
     * An accept state, where the given input string, or any string that has this
     * string as a prefix, is accepted.
     */
    AcceptAnySuffix(RegExpRoot l) { l.isRelevant() }

  /**
   * Gets a state that is about to match the regular expression `t`.
   */
  State mkMatch(RegExpTerm t) { result = Match(t, 0) }

  /**
   * A state in the NFA corresponding to a regular expression.
   *
   * Each regular expression literal `l` has one accepting state
   * `Accept(l)`, one state that accepts all suffixes `AcceptAnySuffix(l)`,
   * and a state `Match(t, i)` for every subterm `t`,
   * which represents the state of the NFA before starting to
   * match `t`, or the `i`th character in `t` if `t` is a constant.
   */
  final class State extends TState {
    RegExpTerm repr;

    State() {
      this = Match(repr, _) or
      this = Accept(repr) or
      this = AcceptAnySuffix(repr)
    }

    /**
     * Gets a string representation for this state in a regular expression.
     */
    string toString() {
      exists(int i | this = Match(repr, i) | result = "Match(" + repr + "," + i + ")")
      or
      this instanceof Accept and
      result = "Accept(" + repr + ")"
      or
      this instanceof AcceptAnySuffix and
      result = "AcceptAny(" + repr + ")"
    }

    /**
     * Gets the term represented by this state.
     */
    RegExpTerm getRepr() { result = repr }

    /**
     * Holds if the term represented by this state is found at the specified location offsets.
     */
    predicate hasLocationInfo(string file, int line, int column, int endline, int endcolumn) {
      repr.hasLocationInfo(file, line, column, endline, endcolumn)
    }
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
        d = Dot() and
        not (result = "\n" or result = "\r")
        or
        d = Any()
      )
      or
      (c = Dot() or c = Any()) and
      (d = Dot() or d = Any()) and
      result = "a"
    )
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
   * Holds if `state` is a start state.
   */
  predicate isStartState(State state) {
    state = mkMatch(any(RegExpRoot r))
    or
    exists(RegExpCaret car | state = after(car))
  }

  /**
   * Holds if `state` is a candidate for ReDoS with string `pump`.
   */
  signature predicate isCandidateSig(State state, string pump);

  /**
   * Holds if `state` is a candidate for ReDoS.
   */
  signature predicate isCandidateSig(State state);

  /**
   * Predicates for constructing a prefix string that leads to a given state.
   */
  module PrefixConstruction<isCandidateSig/1 isCandidate> {
    /**
     * Holds if `state` is the textually last start state for the regular expression.
     */
    private predicate lastStartState(RelevantState state) {
      exists(RegExpRoot root |
        state =
          max(RelevantState s |
            isStartState(s) and
            getRoot(s.getRepr()) = root
          |
            s order by getTermLocationString(s.getRepr()), s.getRepr().toString()
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
      lengthFromStart(state) <= max(lengthFromStart(any(State s | isCandidate(s)))) and
      exists(State prev |
        // select a unique predecessor (by an arbitrary measure)
        prev =
          min(State s |
            lengthFromStart(s) = lengthFromStart(state) - 1 and
            delta(s, _, state)
          |
            s order by getTermLocationString(s.getRepr()), s.getRepr().toString()
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

    /** A state within a regular expression that contains a candidate state. */
    class RelevantState extends State {
      RelevantState() {
        exists(State s | isCandidate(s) | getRoot(s.getRepr()) = getRoot(this.getRepr()))
      }
    }
  }

  /**
   * A module for pruning candidate ReDoS states.
   * The candidates are specified by the `isCandidate` signature predicate.
   * The candidates are checked for rejecting suffixes and deduplicated,
   * and the resulting ReDoS states are read by the `hasReDoSResult` predicate.
   */
  module ReDoSPruning<isCandidateSig/2 isCandidate> {
    /**
     * Holds if repeating `pump` starting at `state` is a candidate for causing backtracking.
     * No check whether a rejected suffix exists has been made.
     */
    private predicate isReDoSCandidate(State state, string pump) {
      isCandidate(state, pump) and
      not state = acceptsAnySuffix() and // pruning early - these can never get stuck in a rejecting state.
      (
        not isCandidate(epsilonSucc+(state), _)
        or
        epsilonSucc+(state) = state and
        state =
          max(State s |
            s = epsilonSucc+(state) and
            isCandidate(s, _) and
            s.getRepr() instanceof InfiniteRepetitionQuantifier
          |
            s order by getTermLocationString(s.getRepr()), s.getRepr().toString()
          )
      )
    }

    /** Gets a state that can reach the `accept-any` state using only epsilon steps. */
    private State acceptsAnySuffix() { epsilonSucc*(result) = AcceptAnySuffix(_) }

    private predicate isCandidateState(State s) { isReDoSCandidate(s, _) }

    import PrefixConstruction<isCandidateState/1> as Prefix

    class RelevantState = Prefix::RelevantState;

    /**
     * Predicates for testing the presence of a rejecting suffix.
     *
     * These predicates are used to ensure that the all states reached from the fork
     * by repeating `w` have a rejecting suffix.
     *
     * For example, a regexp like `/^(a+)+/` will accept any string as long the prefix is
     * some number of `"a"`s, and it is therefore not possible to construct a rejecting suffix.
     *
     * A regexp like `/(a+)+$/` or `/(a+)+b/` trivially has a rejecting suffix,
     * as the suffix "X" will cause both the regular expressions to be rejected.
     *
     * The string `w` is repeated any number of times because it needs to be
     * infinitely repeatable for the attack to work.
     * For the regular expression `/((ab)+)*abab/` the accepting state is not reachable from the fork
     * using epsilon transitions. But any attempt at repeating `w` will end in a state that accepts all suffixes.
     */
    private module SuffixConstruction {
      /**
       * Holds if all states reachable from `fork` by repeating `w`
       * are likely rejectable by appending some suffix.
       */
      predicate reachesOnlyRejectableSuffixes(State fork, string w) {
        isReDoSCandidate(fork, w) and
        forex(State next | next = process(fork, w, getCodepointLengthForCandidate(w) - 1) |
          isLikelyRejectable(next)
        ) and
        not getProcessPrevious(fork, _, w) = acceptsAnySuffix() // we stop `process(..)` early if we can, check here if it happened.
      }

      /**
       * Holds if there likely exists a suffix starting from `s` that leads to the regular expression being rejected.
       * This predicate might find impossible suffixes when searching for suffixes of length > 1, which can cause FPs.
       */
      pragma[noinline]
      private predicate isLikelyRejectable(RelevantState s) {
        // exists a reject edge with some char.
        hasRejectEdge(s)
        or
        hasEdgeToLikelyRejectable(s)
        or
        // stopping here is rejection
        isRejectState(s)
      }

      /**
       * Holds if `s` is not an accept state, and there is no epsilon transition to an accept state.
       */
      predicate isRejectState(RelevantState s) { not epsilonSucc*(s) = Accept(_) }

      /**
       * Holds if there is likely a non-empty suffix leading to rejection starting in `s`.
       */
      pragma[noopt]
      predicate hasEdgeToLikelyRejectable(RelevantState s) {
        // all edges (at least one) with some char leads to another state that is rejectable.
        // the `next` states might not share a common suffix, which can cause FPs.
        exists(string char | char = hasEdgeToLikelyRejectableHelper(s) |
          // noopt to force `hasEdgeToLikelyRejectableHelper` to be first in the join-order.
          exists(State next | deltaClosedChar(s, char, next) | isLikelyRejectable(next)) and
          forall(State next | deltaClosedChar(s, char, next) | isLikelyRejectable(next))
        )
      }

      /**
       * Gets a char for there exists a transition away from `s`,
       * and `s` has not been found to be rejectable by `hasRejectEdge` or `isRejectState`.
       */
      pragma[noinline]
      private string hasEdgeToLikelyRejectableHelper(RelevantState s) {
        not hasRejectEdge(s) and
        not isRejectState(s) and
        deltaClosedChar(s, result, _)
      }

      /**
       * Holds if there is a state `next` that can be reached from `prev`
       * along epsilon edges, such that there is a transition from
       * `prev` to `next` that the character symbol `char`.
       */
      predicate deltaClosedChar(RelevantState prev, string char, RelevantState next) {
        deltaClosed(prev, getAnInputSymbolMatchingRelevant(char), next)
      }

      pragma[noinline]
      InputSymbol getAnInputSymbolMatchingRelevant(string char) {
        char = relevant(_) and
        result = getAnInputSymbolMatching(char)
      }

      pragma[noinline]
      RegExpRoot relevantRoot() {
        exists(RegExpTerm term, State s |
          s.getRepr() = term and isCandidateState(s) and result = term.getRootTerm()
        )
      }

      /**
       * Gets a char used for finding possible suffixes inside `root`.
       */
      pragma[noinline]
      private string relevant(RegExpRoot root) {
        root = relevantRoot() and
        (
          exists(asciiPrintable(result)) and exists(root)
          or
          exists(InputSymbol s | belongsTo(s, root) | result = intersect(s, _))
          or
          // The characters from `hasSimpleRejectEdge`. Only `\n` is really needed (as `\n` is not in the `ascii` relation).
          // The three chars must be kept in sync with `hasSimpleRejectEdge`.
          result = ["|", "\n", "Z"] and exists(root)
        )
      }

      /**
       * Holds if there exists a `char` such that there is no edge from `s` labeled `char` in our NFA.
       * The NFA does not model reject states, so the above is the same as saying there is a reject edge.
       */
      private predicate hasRejectEdge(State s) {
        hasSimpleRejectEdge(s)
        or
        not hasSimpleRejectEdge(s) and
        exists(string char | char = relevant(getRoot(s.getRepr())) |
          not deltaClosedChar(s, char, _)
        )
      }

      /**
       * Holds if there is no edge from `s` labeled with "|", "\n", or "Z" in our NFA.
       * This predicate is used as a cheap pre-processing to speed up `hasRejectEdge`.
       */
      private predicate hasSimpleRejectEdge(State s) {
        // The three chars were chosen arbitrarily. The three chars must be kept in sync with `relevant`.
        exists(string char | char = ["|", "\n", "Z"] | not deltaClosedChar(s, char, _))
      }

      // `process` can't use pragma[inline] predicates. So a materialized version of `getCodepointAt` is needed.
      pragma[noinline]
      private string getCodePointAtForProcess(string str, int i) {
        result = getCodepointAt(str, i) and
        isReDoSCandidate(_, str)
      }

      /**
       * Gets a state that can be reached from pumpable `fork` consuming all
       * chars in `w` any number of times followed by the first `i+1` characters of `w`.
       */
      pragma[noopt]
      private State process(State fork, string w, int i) {
        exists(State prev | prev = getProcessPrevious(fork, i, w) |
          not prev = acceptsAnySuffix() and // we stop `process(..)` early if we can. If the successor accepts any suffix, then we know it can never be rejected.
          exists(string char, InputSymbol sym |
            char = getCodePointAtForProcess(w, i) and
            deltaClosed(prev, sym, result) and
            // noopt to prevent joining `prev` with all possible `chars` that could transition away from `prev`.
            // Instead only join with the set of `chars` where a relevant `InputSymbol` has already been found.
            sym = getAProcessInputSymbol(char)
          )
        )
      }

      pragma[noinline]
      private int getCodepointLengthForCandidate(string s) {
        result = getCodepointLength(s) and
        isReDoSCandidate(_, s)
      }

      /**
       * Gets a state that can be reached from pumpable `fork` consuming all
       * chars in `w` any number of times followed by the first `i` characters of `w`.
       */
      private State getProcessPrevious(State fork, int i, string w) {
        isReDoSCandidate(fork, w) and
        (
          i = 0 and result = fork
          or
          result = process(fork, w, i - 1)
          or
          // repeat until fixpoint
          i = 0 and
          result = process(fork, w, getCodepointLengthForCandidate(w) - 1)
        )
      }

      /**
       * Gets an InputSymbol that matches `char`.
       * The predicate is specialized to only have a result for the `char`s that are relevant for the `process` predicate.
       */
      private InputSymbol getAProcessInputSymbol(string char) {
        char = getAProcessChar() and
        result = getAnInputSymbolMatching(char)
      }

      /**
       * Gets a `char` that occurs in a `pump` string.
       */
      private string getAProcessChar() {
        result = getACodepoint(any(string s | isReDoSCandidate(_, s)))
      }
    }

    /**
     * Holds if `term` may cause superlinear backtracking on strings containing many repetitions of `pump`.
     * Gets the shortest string that causes superlinear backtracking.
     */
    private predicate isReDoSAttackable(RegExpTerm term, string pump, State s) {
      exists(int i, string c | s = Match(term, i) |
        c =
          min(string w |
            isCandidate(s, w) and
            SuffixConstruction::reachesOnlyRejectableSuffixes(s, w)
          |
            w order by w.length(), w
          ) and
        pump = escape(rotate(c, i))
      )
    }

    /**
     * Holds if the state `s` (represented by the term `t`) can have backtracking with repetitions of `pump`.
     *
     * `prefixMsg` contains a friendly message for a prefix that reaches `s` (or `prefixMsg` is the empty string if the prefix is empty or if no prefix could be found).
     */
    predicate hasReDoSResult(RegExpTerm t, string pump, State s, string prefixMsg) {
      isReDoSAttackable(t, pump, s) and
      (
        prefixMsg = "starting with '" + escape(Prefix::prefix(s)) + "' and " and
        not Prefix::prefix(s) = ""
        or
        Prefix::prefix(s) = "" and prefixMsg = ""
        or
        not exists(Prefix::prefix(s)) and prefixMsg = ""
      )
    }

    /**
     * Gets `str` with the last `i` characters moved to the front.
     *
     * We use this to adjust the pump string to match with the beginning of
     * a RegExpTerm, so it doesn't start in the middle of a constant.
     */
    bindingset[str, i]
    private string rotate(string str, int i) {
      result = str.suffix(str.length() - i) + str.prefix(str.length() - i)
    }
  }

  /**
   * A module that describes a tree where each node has one or more associated characters, also known as a trie.
   * The root node has no associated character.
   * This module is a signature used in `Concretizer`.
   */
  signature module CharTree {
    /** A node in the tree. */
    class CharNode;

    /** Gets the previous node in the tree from `t`. */
    CharNode getPrev(CharNode t);

    /**
     * Holds if `n` is at the end of a tree. I.e. a node that should have a result in the `Concretizer` module.
     * Such a node can still have children.
     */
    predicate isARelevantEnd(CharNode n);

    /** Gets a char associated with `t`. */
    string getChar(CharNode t);
  }

  /**
   * Implements an algorithm for computing all possible strings
   * from following a tree of nodes (as described in `CharTree`).
   *
   * The string is build using one big concat, where all the chars are computed first.
   * See `concretize`.
   */
  module Concretizer<CharTree Impl> {
    private class Node = Impl::CharNode;

    private predicate getPrev = Impl::getPrev/1;

    private predicate isARelevantEnd = Impl::isARelevantEnd/1;

    private predicate getChar = Impl::getChar/1;

    /** Holds if `n` is on a path from the root to a leaf, and is therefore relevant for the results in `concretize`. */
    private predicate isRelevant(Node n) {
      isARelevantEnd(n)
      or
      exists(Node succ | isRelevant(succ) | n = getPrev(succ))
    }

    /** Holds if `n` is a root with no predecessors. */
    private predicate isRoot(Node n) { not exists(getPrev(n)) }

    /** Gets the distance from a root to `n`. */
    private int nodeDepth(Node n) {
      result = 0 and isRoot(n)
      or
      isRelevant(n) and
      exists(Node prev | result = nodeDepth(prev) + 1 | prev = getPrev(n))
    }

    /** Gets an ancestor of `end`, where `end` is a node that should have a result in `concretize`. */
    private Node getAnAncestor(Node end) { isARelevantEnd(end) and result = getPrev*(end) }

    /** Gets the `i`th character on the path from the root to `n`. */
    pragma[noinline]
    private string getPrefixChar(Node n, int i) {
      exists(Node ancestor |
        result = getChar(ancestor) and
        ancestor = getAnAncestor(n) and
        i = nodeDepth(ancestor)
      ) and
      nodeDepth(n) < 100
    }

    /** Gets a string corresponding to `node`. */
    language[monotonicAggregates]
    string concretize(Node n) {
      result = strictconcat(int i | exists(getPrefixChar(n, i)) | getPrefixChar(n, i) order by i)
    }
  }
}

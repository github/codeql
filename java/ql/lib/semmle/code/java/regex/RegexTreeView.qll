/** Provides a class hierarchy corresponding to a parse tree of regular expressions. */

private import semmle.code.java.regex.regex as RE // importing under a namescape to avoid naming conflict for `Top`.
private import codeql.regex.nfa.NfaUtils as NfaUtils
// exporting as RegexTreeView, and in the top-level scope.
import Impl as RegexTreeView
import Impl

/** Gets the parse tree resulting from parsing `re`, if such has been constructed. */
RegExpTerm getParsedRegExp(RE::StringLiteral re) { result.getRegex() = re and result.isRootTerm() }

private class Regex = RE::Regex;

private class Location = RE::Location;

private class File = RE::File;

/**
 * An element containing a regular expression term, that is, either
 * a string literal (parsed as a regular expression; the root of the parse tree)
 * or another regular expression term (a descendant of the root).
 *
 * For sequences and alternations, we require at least two children.
 * Otherwise, we wish to represent the term differently.
 * This avoids multiple representations of the same term.
 */
private newtype TRegExpParent =
  /** A string literal used as a regular expression */
  TRegExpLiteral(Regex re) or
  /** A quantified term */
  TRegExpQuantifier(Regex re, int start, int end) { re.quantifiedItem(start, end, _, _) } or
  /** A sequence term */
  TRegExpSequence(Regex re, int start, int end) {
    re.sequence(start, end) and
    // Only create sequence nodes for sequences with two or more children.
    exists(int mid |
      re.item(start, mid) and
      re.item(mid, _)
    )
  } or
  /** An alternation term */
  TRegExpAlt(Regex re, int start, int end) {
    re.alternation(start, end) and
    exists(int part_end |
      re.alternationOption(start, end, start, part_end) and
      part_end < end
    ) // if an alternation does not have more than one element, it should be treated as that element instead.
  } or
  /** A character class term */
  TRegExpCharacterClass(Regex re, int start, int end) { re.charSet(start, end) } or
  /** A character range term */
  TRegExpCharacterRange(Regex re, int start, int end) { re.charRange(_, start, _, _, end) } or
  /** A group term */
  TRegExpGroup(Regex re, int start, int end) { re.group(start, end) } or
  /** A special character */
  TRegExpSpecialChar(Regex re, int start, int end) { re.specialCharacter(start, end, _) } or
  /** A normal character */
  TRegExpNormalChar(Regex re, int start, int end) { re.normalCharacter(start, end) } or
  /** A quoted sequence */
  TRegExpQuote(Regex re, int start, int end) { re.quote(start, end) } or
  /** A back reference */
  TRegExpBackRef(Regex re, int start, int end) { re.backreference(start, end) }

private import codeql.regex.RegexTreeView

/** An implementation that statisfies the RegexTreeView signature. */
module Impl implements RegexTreeViewSig {
  /**
   * An element containing a regular expression term, that is, either
   * a string literal (parsed as a regular expression; the root of the parse tree)
   * or another regular expression term (a descendant of the root).
   */
  class RegExpParent extends TRegExpParent {
    /** Gets a textual representation of this element. */
    string toString() { result = "RegExpParent" }

    /** Gets the `i`th child term. */
    RegExpTerm getChild(int i) { none() }

    /** Gets a child term . */
    RegExpTerm getAChild() { result = this.getChild(_) }

    /** Gets the number of child terms. */
    int getNumChild() { result = count(this.getAChild()) }

    /** Gets the associated regex. */
    abstract Regex getRegex();

    /** Gets the last child term of this element. */
    RegExpTerm getLastChild() { result = this.getChild(this.getNumChild() - 1) }
  }

  /**
   * A string literal used as a regular expression.
   *
   * As an optimisation, only regexes containing an infinite repitition quatifier (`+`, `*`, or `{x,}`)
   * and therefore may be relevant for ReDoS queries are considered.
   */
  class RegExpLiteral extends TRegExpLiteral, RegExpParent {
    Regex re;

    RegExpLiteral() { this = TRegExpLiteral(re) }

    override string toString() { result = re.toString() }

    override RegExpTerm getChild(int i) { i = 0 and result.getRegex() = re and result.isRootTerm() }

    /** Holds if dot, `.`, matches all characters, including newlines. */
    predicate isDotAll() { re.getAMode() = "DOTALL" }

    /** Holds if this regex matching is case-insensitive for this regex. */
    predicate isIgnoreCase() { re.getAMode() = "IGNORECASE" }

    /** Get a string representing all modes for this regex. */
    string getFlags() { result = concat(string mode | mode = re.getAMode() | mode, " | ") }

    override Regex getRegex() { result = re }

    /** Gets the primary QL class for this regex. */
    string getPrimaryQLClass() { result = "RegExpLiteral" }
  }

  /**
   * A regular expression term, that is, a syntactic part of a regular expression.
   * These are the tree nodes that form the parse tree of a regular expression literal.
   */
  class RegExpTerm extends RegExpParent {
    Regex re;
    int start;
    int end;

    RegExpTerm() {
      this = TRegExpAlt(re, start, end)
      or
      this = TRegExpBackRef(re, start, end)
      or
      this = TRegExpCharacterClass(re, start, end)
      or
      this = TRegExpCharacterRange(re, start, end)
      or
      this = TRegExpNormalChar(re, start, end)
      or
      this = TRegExpQuote(re, start, end)
      or
      this = TRegExpGroup(re, start, end)
      or
      this = TRegExpQuantifier(re, start, end)
      or
      this = TRegExpSequence(re, start, end)
      or
      this = TRegExpSpecialChar(re, start, end)
    }

    /**
     * Gets the outermost term of this regular expression.
     */
    RegExpTerm getRootTerm() {
      this.isRootTerm() and result = this
      or
      result = this.getParent().(RegExpTerm).getRootTerm()
    }

    /**
     * Holds if this term is part of a string literal
     * that is interpreted as a regular expression.
     */
    predicate isUsedAsRegExp() { any() }

    /**
     * Holds if this is the root term of a regular expression.
     */
    predicate isRootTerm() { start = 0 and end = re.getText().length() }

    /**
     * Gets the parent term of this regular expression term, or the
     * regular expression literal if this is the root term.
     */
    RegExpParent getParent() { result.getAChild() = this }

    override Regex getRegex() { result = re }

    /** Gets the offset at which this term starts. */
    int getStart() { result = start }

    /** Gets the offset at which this term ends. */
    int getEnd() { result = end }

    /** Holds if this term occurs in regex `inRe` offsets `startOffset` to `endOffset`. */
    predicate occursInRegex(Regex inRe, int startOffset, int endOffset) {
      inRe = re and startOffset = start and endOffset = end
    }

    override string toString() { result = re.getText().substring(start, end) }

    /**
     * Gets the location of the surrounding regex, as locations inside the regex do not exist.
     * To get location information corresponding to the term inside the regex,
     * use `hasLocationInfo`.
     */
    Location getLocation() { result = re.getLocation() }

    /** Holds if this term is found at the specified location offsets. */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      /*
       * This is an approximation that handles the simple and common case of single,
       * normal string literal written in the source, but does not give correct results in more complex cases
       * such as compile-time concatenation, or multi-line string literals.
       */

      exists(int re_start, int src_start, int src_end |
        re.getLocation().hasLocationInfo(filepath, startline, re_start, endline, _) and
        re.sourceCharacter(start, src_start, _) and
        re.sourceCharacter(end - 1, _, src_end) and
        startcolumn = re_start + src_start and
        endcolumn = re_start + src_end - 1
      )
    }

    /** Gets the file in which this term is found. */
    File getFile() { result = this.getLocation().getFile() }

    /** Gets the raw source text of this term. */
    string getRawValue() { result = this.toString() }

    /** Gets the string literal in which this term is found. */
    RegExpLiteral getLiteral() { result = TRegExpLiteral(re) }

    /** Gets the regular expression term that is matched (textually) before this one, if any. */
    RegExpTerm getPredecessor() {
      exists(RegExpTerm parent | parent = this.getParent() |
        result = parent.(RegExpSequence).previousElement(this)
        or
        not exists(parent.(RegExpSequence).previousElement(this)) and
        not parent instanceof RegExpSubPattern and
        result = parent.getPredecessor()
      )
    }

    /** Gets the regular expression term that is matched (textually) after this one, if any. */
    RegExpTerm getSuccessor() {
      exists(RegExpTerm parent | parent = this.getParent() |
        result = parent.(RegExpSequence).nextElement(this)
        or
        not exists(parent.(RegExpSequence).nextElement(this)) and
        not parent instanceof RegExpSubPattern and
        result = parent.getSuccessor()
      )
    }

    /** Gets the primary QL class for this term. */
    string getPrimaryQLClass() { result = "RegExpTerm" }
  }

  /**
   * A quantified regular expression term.
   *
   * Example:
   *
   * ```
   * ((ECMA|Java)[sS]cript)*
   * ```
   */
  class RegExpQuantifier extends RegExpTerm, TRegExpQuantifier {
    int part_end;
    boolean maybe_empty;
    boolean may_repeat_forever;

    RegExpQuantifier() {
      this = TRegExpQuantifier(re, start, end) and
      re.quantifiedPart(start, part_end, end, maybe_empty, may_repeat_forever)
    }

    override RegExpTerm getChild(int i) {
      i = 0 and
      result.occursInRegex(re, start, part_end)
    }

    /** Holds if this term may match zero times. */
    predicate mayBeEmpty() { maybe_empty = true }

    /** Holds if this term may match an unlimited number of times. */
    predicate mayRepeatForever() { may_repeat_forever = true }

    /** Gets the quantifier for this term. That is e.g "?" for "a?". */
    string getQuantifier() { result = re.getText().substring(part_end, end) }

    /** Holds if this is a possessive quantifier, e.g. a*+. */
    predicate isPossessive() {
      exists(string q | q = this.getQuantifier() |
        q.length() > 1 and q.charAt(q.length() - 1) = "+"
      )
    }

    override string getPrimaryQLClass() { result = "RegExpQuantifier" }
  }

  /**
   * A regular expression term that permits unlimited repetitions.
   */
  class InfiniteRepetitionQuantifier extends RegExpQuantifier {
    InfiniteRepetitionQuantifier() { this.mayRepeatForever() }
  }

  /**
   * A star-quantified term.
   *
   * Example:
   *
   * ```
   * \w*
   * ```
   */
  class RegExpStar extends InfiniteRepetitionQuantifier {
    RegExpStar() { this.getQuantifier().charAt(0) = "*" }

    override string getPrimaryQLClass() { result = "RegExpStar" }
  }

  /**
   * A plus-quantified term.
   *
   * Example:
   *
   * ```
   * \w+
   * ```
   */
  class RegExpPlus extends InfiniteRepetitionQuantifier {
    RegExpPlus() { this.getQuantifier().charAt(0) = "+" }

    override string getPrimaryQLClass() { result = "RegExpPlus" }
  }

  /**
   * An optional term.
   *
   * Example:
   *
   * ```
   * ;?
   * ```
   */
  class RegExpOpt extends RegExpQuantifier {
    RegExpOpt() { this.getQuantifier().charAt(0) = "?" }

    override string getPrimaryQLClass() { result = "RegExpOpt" }
  }

  /**
   * A range-quantified term
   *
   * Examples:
   *
   * ```
   * \w{2,4}
   * \w{2,}
   * \w{2}
   * ```
   */
  class RegExpRange extends RegExpQuantifier {
    string upper;
    string lower;

    RegExpRange() { re.multiples(part_end, end, lower, upper) }

    /** Gets the string defining the upper bound of this range, which is empty when no such bound exists. */
    string getUpper() { result = upper }

    /** Gets the string defining the lower bound of this range, which is empty when no such bound exists. */
    string getLower() { result = lower }

    /**
     * Gets the upper bound of the range, if any.
     *
     * If there is no upper bound, any number of repetitions is allowed.
     * For a term of the form `r{lo}`, both the lower and the upper bound
     * are `lo`.
     */
    int getUpperBound() { result = this.getUpper().toInt() }

    /** Gets the lower bound of the range. */
    int getLowerBound() { result = this.getLower().toInt() }

    override string getPrimaryQLClass() { result = "RegExpRange" }
  }

  /**
   * A sequence term.
   *
   * Example:
   *
   * ```
   * (ECMA|Java)Script
   * ```
   *
   * This is a sequence with the elements `(ECMA|Java)` and `Script`.
   */
  class RegExpSequence extends RegExpTerm, TRegExpSequence {
    RegExpSequence() { this = TRegExpSequence(re, start, end) }

    override RegExpTerm getChild(int i) { result = seqChild(re, start, end, i) }

    /** Gets the element preceding `element` in this sequence. */
    RegExpTerm previousElement(RegExpTerm element) { element = this.nextElement(result) }

    /** Gets the element following `element` in this sequence. */
    RegExpTerm nextElement(RegExpTerm element) {
      exists(int i |
        element = this.getChild(i) and
        result = this.getChild(i + 1)
      )
    }

    override string getPrimaryQLClass() { result = "RegExpSequence" }
  }

  pragma[nomagic]
  private int seqChildEnd(Regex re, int start, int end, int i) {
    result = seqChild(re, start, end, i).getEnd()
  }

  // moved out so we can use it in the charpred
  private RegExpTerm seqChild(Regex re, int start, int end, int i) {
    re.sequence(start, end) and
    (
      i = 0 and
      exists(int itemEnd |
        re.item(start, itemEnd) and
        result.occursInRegex(re, start, itemEnd)
      )
      or
      i > 0 and
      exists(int itemStart, int itemEnd | itemStart = seqChildEnd(re, start, end, i - 1) |
        re.item(itemStart, itemEnd) and
        result.occursInRegex(re, itemStart, itemEnd)
      )
    )
  }

  /**
   * An alternative term, that is, a term of the form `a|b`.
   *
   * Example:
   *
   * ```
   * ECMA|Java
   * ```
   */
  class RegExpAlt extends RegExpTerm, TRegExpAlt {
    RegExpAlt() { this = TRegExpAlt(re, start, end) }

    override RegExpTerm getChild(int i) {
      i = 0 and
      exists(int part_end |
        re.alternationOption(start, end, start, part_end) and
        result.occursInRegex(re, start, part_end)
      )
      or
      i > 0 and
      exists(int part_start, int part_end |
        part_start = this.getChild(i - 1).getEnd() + 1 // allow for the |
      |
        re.alternationOption(start, end, part_start, part_end) and
        result.occursInRegex(re, part_start, part_end)
      )
    }

    override string getPrimaryQLClass() { result = "RegExpAlt" }
  }

  private import codeql.util.Numbers as Numbers

  /**
   * An escaped regular expression term, that is, a regular expression
   * term starting with a backslash, which is not a backreference.
   *
   * Example:
   *
   * ```
   * \.
   * \w
   * ```
   */
  class RegExpEscape extends RegExpNormalChar {
    RegExpEscape() { re.escapedCharacter(start, end) }

    /**
     * Gets the name of the escaped; for example, `w` for `\w`.
     * TODO: Handle named escapes.
     */
    override string getValue() {
      not this.isUnicode() and
      this.isIdentityEscape() and
      result = this.getUnescaped()
      or
      this.getUnescaped() = "n" and result = "\n"
      or
      this.getUnescaped() = "r" and result = "\r"
      or
      this.getUnescaped() = "t" and result = "\t"
      or
      this.getUnescaped() = "f" and result = 12.toUnicode() // form feed
      or
      this.getUnescaped() = "a" and result = 7.toUnicode() // alert/bell
      or
      this.getUnescaped() = "e" and result = 27.toUnicode() // escape (0x1B)
      or
      this.isUnicode() and
      result = this.getUnicode()
    }

    /** Holds if this terms name is given by the part following the escape character. */
    predicate isIdentityEscape() { not this.getUnescaped() in ["n", "r", "t", "f", "a", "e"] }

    override string getPrimaryQLClass() { result = "RegExpEscape" }

    /** Gets the part of the term following the escape character. That is e.g. "w" if the term is "\w". */
    private string getUnescaped() { result = this.getText().suffix(1) }

    /**
     * Gets the text for this escape. That is e.g. "\w".
     */
    private string getText() { result = re.getText().substring(start, end) }

    /**
     * Holds if this is a unicode escape.
     */
    private predicate isUnicode() { this.getText().matches(["\\u%", "\\x%"]) }

    /**
     * Gets the unicode char for this escape.
     * E.g. for `\u0061` this returns "a".
     */
    private string getUnicode() { result = Numbers::parseHexInt(this.getHexString()).toUnicode() }

    /** Gets the part of this escape that is a hexidecimal string */
    private string getHexString() {
      this.isUnicode() and
      if this.getText().matches("\\u%") // \uhhhh
      then result = this.getText().suffix(2)
      else
        if this.getText().matches("\\x{%") // \x{h..h}
        then result = this.getText().substring(3, this.getText().length() - 1)
        else result = this.getText().suffix(2) // \xhh
    }
  }

  /**
   * A character escape in a regular expression.
   *
   * Example:
   *
   * ```
   * \.
   * ```
   */
  class RegExpCharEscape = RegExpEscape;

  /**
   * A word boundary, that is, a regular expression term of the form `\b`.
   */
  class RegExpWordBoundary extends RegExpSpecialChar {
    RegExpWordBoundary() { this.getChar() = "\\b" }
  }

  /**
   * A non-word boundary, that is, a regular expression term of the form `\B`.
   */
  class RegExpNonWordBoundary extends RegExpSpecialChar {
    RegExpNonWordBoundary() { this.getChar() = "\\B" }
  }

  /**
   * A character class escape in a regular expression.
   * That is, an escaped character that denotes multiple characters.
   *
   * Examples:
   *
   * ```
   * \w
   * \S
   * ```
   */
  class RegExpCharacterClassEscape extends RegExpEscape {
    RegExpCharacterClassEscape() {
      this.getValue() in ["d", "D", "s", "S", "w", "W", "h", "H", "v", "V"] or
      this.getValue().charAt(0) in ["p", "P"]
    }

    override RegExpTerm getChild(int i) { none() }

    override string getPrimaryQLClass() { result = "RegExpCharacterClassEscape" }
  }

  /**
   * A named character class in a regular expression.
   *
   * Examples:
   *
   * ```
   * \p{Digit}
   * \p{IsLowerCase}
   */
  additional class RegExpNamedProperty extends RegExpCharacterClassEscape {
    boolean inverted;
    string name;

    RegExpNamedProperty() {
      name = this.getValue().substring(2, this.getValue().length() - 1) and
      (
        inverted = false and
        this.getValue().charAt(0) = "p"
        or
        inverted = true and
        this.getValue().charAt(0) = "P"
      )
    }

    /** Holds if this class is inverted. */
    predicate isInverted() { inverted = true }

    /** Gets the name of this class. */
    string getClassName() { result = name }

    /**
     * Gets an equivalent single-chcracter escape sequence for this class (e.g. \d) if possible, excluding the escape character.
     */
    string getBackslashEquivalent() {
      exists(string eq | if inverted = true then result = eq.toUpperCase() else result = eq |
        name = ["Digit", "IsDigit"] and
        eq = "d"
        or
        name = ["Space", "IsWhite_Space"] and
        eq = "s"
      )
    }
  }

  /**
   * A character class in a regular expression.
   *
   * Examples:
   *
   * ```
   * [a-z_]
   * [^<>&]
   * ```
   */
  class RegExpCharacterClass extends RegExpTerm, TRegExpCharacterClass {
    RegExpCharacterClass() { this = TRegExpCharacterClass(re, start, end) }

    /** Holds if this character class is inverted, matching the opposite of its content. */
    predicate isInverted() { re.getChar(start + 1) = "^" }

    /** Holds if this character class can match anything. */
    predicate isUniversalClass() {
      // [^]
      this.isInverted() and not exists(this.getAChild())
      or
      // [\w\W] and similar
      not this.isInverted() and
      exists(string cce1, string cce2 |
        cce1 = this.getAChild().(RegExpCharacterClassEscape).getValue() and
        cce2 = this.getAChild().(RegExpCharacterClassEscape).getValue()
      |
        cce1 != cce2 and cce1.toLowerCase() = cce2.toLowerCase()
      )
    }

    override RegExpTerm getChild(int i) {
      i = 0 and
      exists(int itemStart, int itemEnd |
        re.charSetStart(start, itemStart) and
        re.charSetChild(start, itemStart, itemEnd) and
        result.occursInRegex(re, itemStart, itemEnd)
      )
      or
      i > 0 and
      exists(int itemStart, int itemEnd | itemStart = this.getChild(i - 1).getEnd() |
        result.occursInRegex(re, itemStart, itemEnd) and
        re.charSetChild(start, itemStart, itemEnd)
      )
    }

    override string getPrimaryQLClass() { result = "RegExpCharacterClass" }
  }

  /**
   * A character range in a character class in a regular expression.
   *
   * Example:
   *
   * ```
   * a-z
   * ```
   */
  class RegExpCharacterRange extends RegExpTerm, TRegExpCharacterRange {
    int lower_end;
    int upper_start;

    RegExpCharacterRange() {
      this = TRegExpCharacterRange(re, start, end) and
      re.charRange(_, start, lower_end, upper_start, end)
    }

    /** Holds if this range goes from `lo` to `hi`, in effect is `lo-hi`. */
    predicate isRange(string lo, string hi) {
      lo = re.getText().substring(start, lower_end) and
      hi = re.getText().substring(upper_start, end)
    }

    override RegExpTerm getChild(int i) {
      i = 0 and
      result.occursInRegex(re, start, lower_end)
      or
      i = 1 and
      result.occursInRegex(re, upper_start, end)
    }

    override string getPrimaryQLClass() { result = "RegExpCharacterRange" }
  }

  /**
   * A normal character in a regular expression, that is, a character
   * without special meaning. This includes escaped characters.
   * It also includes escape sequences that represent character classes.
   *
   * Examples:
   * ```
   * t
   * \t
   * ```
   */
  additional class RegExpNormalChar extends RegExpTerm, TRegExpNormalChar {
    RegExpNormalChar() { this = TRegExpNormalChar(re, start, end) }

    /**
     * Holds if this constant represents a valid Unicode character (as opposed
     * to a surrogate code point that does not correspond to a character by itself.)
     */
    predicate isCharacter() { any() }

    /** Gets the string representation of the char matched by this term. */
    string getValue() { result = re.getText().substring(start, end) }

    override RegExpTerm getChild(int i) { none() }

    override string getPrimaryQLClass() { result = "RegExpNormalChar" }
  }

  /**
   * A quoted sequence.
   *
   * Example:
   * ```
   * \Qabc\E
   * ```
   */
  additional class RegExpQuote extends RegExpTerm, TRegExpQuote {
    string value;

    RegExpQuote() {
      exists(int inner_start, int inner_end |
        this = TRegExpQuote(re, start, end) and
        re.quote(start, end, inner_start, inner_end) and
        value = re.getText().substring(inner_start, inner_end)
      )
    }

    /** Gets the string matched by this quote term. */
    string getValue() { result = value }

    override string getPrimaryQLClass() { result = "RegExpQuote" }
  }

  /**
   * A constant regular expression term, that is, a regular expression
   * term matching a single string. This can be a single character or a quoted sequence.
   *
   * Example:
   *
   * ```
   * a
   * ```
   */
  class RegExpConstant extends RegExpTerm {
    string value;

    RegExpConstant() {
      (value = this.(RegExpNormalChar).getValue() or value = this.(RegExpQuote).getValue()) and
      not this instanceof RegExpCharacterClassEscape
    }

    /**
     * Holds if this constant represents a valid Unicode character (as opposed
     * to a surrogate code point that does not correspond to a character by itself.)
     */
    predicate isCharacter() { any() }

    /** Gets the string matched by this constant term. */
    string getValue() { result = value }

    override RegExpTerm getChild(int i) { none() }

    override string getPrimaryQLClass() { result = "RegExpConstant" }
  }

  /**
   * A grouped regular expression.
   *
   * Examples:
   *
   * ```
   * (ECMA|Java)
   * (?:ECMA|Java)
   * (?<quote>['"])
   * ```
   */
  class RegExpGroup extends RegExpTerm, TRegExpGroup {
    RegExpGroup() { this = TRegExpGroup(re, start, end) }

    /**
     * Gets the index of this capture group within the enclosing regular
     * expression literal.
     *
     * For example, in the regular expression `/((a?).)(?:b)/`, the
     * group `((a?).)` has index 1, the group `(a?)` nested inside it
     * has index 2, and the group `(?:b)` has no index, since it is
     * not a capture group.
     */
    int getNumber() { result = re.getGroupNumber(start, end) }

    /** Holds if this is a named capture group. */
    predicate isNamed() { exists(this.getName()) }

    /** Gets the name of this capture group, if any. */
    string getName() { result = re.getGroupName(start, end) }

    override RegExpTerm getChild(int i) {
      i = 0 and
      exists(int in_start, int in_end | re.groupContents(start, end, in_start, in_end) |
        result.occursInRegex(re, in_start, in_end)
      )
    }

    override string getPrimaryQLClass() { result = "RegExpGroup" }

    /** Holds if this is the `n`th numbered group of literal `lit`. */
    predicate isNumberedGroupOfLiteral(RegExpLiteral lit, int n) {
      lit = this.getLiteral() and n = this.getNumber()
    }

    /** Holds if this is a group with name `name` of literal `lit`. */
    predicate isNamedGroupOfLiteral(RegExpLiteral lit, string name) {
      lit = this.getLiteral() and name = this.getName()
    }

    /** Holds if this is a capture group. */
    predicate isCapture() { exists(this.getNumber()) }
  }

  /**
   * A special character in a regular expression.
   *
   * Examples:
   * ```
   * ^
   * $
   * .
   * ```
   */
  additional class RegExpSpecialChar extends RegExpTerm, TRegExpSpecialChar {
    string char;

    RegExpSpecialChar() {
      this = TRegExpSpecialChar(re, start, end) and
      re.specialCharacter(start, end, char)
    }

    /**
     * Holds if this constant represents a valid Unicode character (as opposed
     * to a surrogate code point that does not correspond to a character by itself.)
     */
    predicate isCharacter() { any() }

    /** Gets the char for this term. */
    string getChar() { result = char }

    override RegExpTerm getChild(int i) { none() }

    override string getPrimaryQLClass() { result = "RegExpSpecialChar" }
  }

  /**
   * A dot regular expression.
   *
   * Example:
   *
   * ```
   * .
   * ```
   */
  class RegExpDot extends RegExpSpecialChar {
    RegExpDot() { this.getChar() = "." }

    override string getPrimaryQLClass() { result = "RegExpDot" }
  }

  /**
   * A term that matches a specific position between characters in the string.
   *
   * Example:
   *
   * ```
   * ^
   * ```
   */
  class RegExpAnchor extends RegExpSpecialChar {
    RegExpAnchor() { this.getChar() = ["$", "^"] }

    override string getPrimaryQLClass() { result = "RegExpAnchor" }
  }

  /**
   * A dollar assertion `$` matching the end of a line.
   *
   * Example:
   *
   * ```
   * $
   * ```
   */
  class RegExpDollar extends RegExpAnchor {
    RegExpDollar() { this.getChar() = "$" }

    override string getPrimaryQLClass() { result = "RegExpDollar" }
  }

  /**
   * A caret assertion `^` matching the beginning of a line.
   *
   * Example:
   *
   * ```
   * ^
   * ```
   */
  class RegExpCaret extends RegExpAnchor {
    RegExpCaret() { this.getChar() = "^" }

    override string getPrimaryQLClass() { result = "RegExpCaret" }
  }

  /**
   * A zero-width match, that is, either an empty group or an assertion.
   *
   * Examples:
   * ```
   * ()
   * (?=\w)
   * ```
   */
  additional class RegExpZeroWidthMatch extends RegExpGroup {
    RegExpZeroWidthMatch() { re.zeroWidthMatch(start, end) }

    override RegExpTerm getChild(int i) { none() }

    override string getPrimaryQLClass() { result = "RegExpZeroWidthMatch" }
  }

  /**
   * A zero-width lookahead or lookbehind assertion.
   *
   * Examples:
   *
   * ```
   * (?=\w)
   * (?!\n)
   * (?<=\.)
   * (?<!\\)
   * ```
   */
  class RegExpSubPattern extends RegExpZeroWidthMatch {
    RegExpSubPattern() { not re.emptyGroup(start, end) }

    /** Gets the lookahead term. */
    RegExpTerm getOperand() {
      exists(int in_start, int in_end | re.groupContents(start, end, in_start, in_end) |
        result.occursInRegex(re, in_start, in_end)
      )
    }
  }

  /**
   * A zero-width lookahead assertion.
   *
   * Examples:
   *
   * ```
   * (?=\w)
   * (?!\n)
   * ```
   */
  abstract class RegExpLookahead extends RegExpSubPattern { }

  /**
   * A positive-lookahead assertion.
   *
   * Examples:
   *
   * ```
   * (?=\w)
   * ```
   */
  class RegExpPositiveLookahead extends RegExpLookahead {
    RegExpPositiveLookahead() { re.positiveLookaheadAssertionGroup(start, end) }

    override string getPrimaryQLClass() { result = "RegExpPositiveLookahead" }
  }

  /**
   * A negative-lookahead assertion.
   *
   * Examples:
   *
   * ```
   * (?!\n)
   * ```
   */
  additional class RegExpNegativeLookahead extends RegExpLookahead {
    RegExpNegativeLookahead() { re.negativeLookaheadAssertionGroup(start, end) }

    override string getPrimaryQLClass() { result = "RegExpNegativeLookahead" }
  }

  /**
   * A zero-width lookbehind assertion.
   *
   * Examples:
   *
   * ```
   * (?<=\.)
   * (?<!\\)
   * ```
   */
  abstract class RegExpLookbehind extends RegExpSubPattern { }

  /**
   * A positive-lookbehind assertion.
   *
   * Examples:
   *
   * ```
   * (?<=\.)
   * ```
   */
  class RegExpPositiveLookbehind extends RegExpLookbehind {
    RegExpPositiveLookbehind() { re.positiveLookbehindAssertionGroup(start, end) }

    override string getPrimaryQLClass() { result = "RegExpPositiveLookbehind" }
  }

  /**
   * A negative-lookbehind assertion.
   *
   * Examples:
   *
   * ```
   * (?<!\\)
   * ```
   */
  additional class RegExpNegativeLookbehind extends RegExpLookbehind {
    RegExpNegativeLookbehind() { re.negativeLookbehindAssertionGroup(start, end) }

    override string getPrimaryQLClass() { result = "RegExpNegativeLookbehind" }
  }

  /**
   * A back reference, that is, a term of the form `\i` or `\k<name>`
   * in a regular expression.
   *
   * Examples:
   *
   * ```
   * \1
   * (?P=quote)
   * ```
   */
  class RegExpBackRef extends RegExpTerm, TRegExpBackRef {
    RegExpBackRef() { this = TRegExpBackRef(re, start, end) }

    /**
     * Gets the number of the capture group this back reference refers to, if any.
     */
    int getNumber() { result = re.getBackrefNumber(start, end) }

    /**
     * Gets the name of the capture group this back reference refers to, if any.
     */
    string getName() { result = re.getBackrefName(start, end) }

    /** Gets the capture group this back reference refers to. */
    RegExpGroup getGroup() {
      result.isNumberedGroupOfLiteral(this.getLiteral(), this.getNumber())
      or
      result.isNamedGroupOfLiteral(this.getLiteral(), this.getName())
    }

    override RegExpTerm getChild(int i) { none() }

    override string getPrimaryQLClass() { result = "RegExpBackRef" }
  }

  class Top = RegExpParent;

  /**
   * Holds if `term` is an escape class representing e.g. `\d`.
   * `clazz` is which character class it represents, e.g. "d" for `\d`.
   */
  predicate isEscapeClass(RegExpTerm term, string clazz) {
    term.(RegExpCharacterClassEscape).getValue() = clazz
    or
    term.(RegExpNamedProperty).getBackslashEquivalent() = clazz
  }

  /**
   * Holds if `term` is a possessive quantifier, e.g. `a*+`.
   */
  predicate isPossessive(RegExpQuantifier term) { term.isPossessive() }

  /**
   * Holds if the regex that `term` is part of is used in a way that ignores any leading prefix of the input it's matched against.
   */
  predicate matchesAnyPrefix(RegExpTerm term) { not term.getRegex().matchesFullString() }

  /**
   * Holds if the regex that `term` is part of is used in a way that ignores any trailing suffix of the input it's matched against.
   */
  predicate matchesAnySuffix(RegExpTerm term) { not term.getRegex().matchesFullString() }

  /**
   * Holds if the regular expression should not be considered.
   *
   * We make the pragmatic performance optimization to ignore regular expressions in files
   * that do not belong to the project code (such as installed dependencies).
   */
  predicate isExcluded(RegExpParent parent) {
    not exists(parent.getRegex().getLocation().getFile().getRelativePath())
    or
    // Regexes with many occurrences of ".*" may cause the polynomial ReDoS computation to explode, so
    // we explicitly exclude these.
    strictcount(int i | exists(parent.getRegex().getText().regexpFind("\\.\\*", i, _)) | i) > 10
  }

  /**
   * Holds if `root` has the `i` flag for case-insensitive matching.
   */
  predicate isIgnoreCase(RegExpTerm root) {
    root.isRootTerm() and
    root.getLiteral().isIgnoreCase()
  }

  /**
   * Holds if `root` has the `s` flag for multi-line matching.
   */
  predicate isDotAll(RegExpTerm root) {
    root.isRootTerm() and
    root.getLiteral().isDotAll()
  }
}

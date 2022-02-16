/** Provides a class hierarchy corresponding to a parse tree of regular expressions. */

private import internal.ParseRegExp
private import codeql.NumberUtils
private import codeql.ruby.ast.Literal as AST
private import codeql.Locations

/**
 * An element containing a regular expression term, that is, either
 * a string literal (parsed as a regular expression)
 * or another regular expression term.
 *
 * For sequences and alternations, we require at least one child.
 * Otherwise, we wish to represent the term differently.
 * This avoids multiple representations of the same term.
 */
private newtype TRegExpParent =
  /** A string literal used as a regular expression */
  TRegExpLiteral(RegExp re) or
  /** A quantified term */
  TRegExpQuantifier(RegExp re, int start, int end) { re.qualifiedItem(start, end, _, _) } or
  /** A sequence term */
  TRegExpSequence(RegExp re, int start, int end) { re.sequence(start, end) } or
  /** An alternation term */
  TRegExpAlt(RegExp re, int start, int end) { re.alternation(start, end) } or
  /** A character class term */
  TRegExpCharacterClass(RegExp re, int start, int end) { re.charSet(start, end) } or
  /** A character range term */
  TRegExpCharacterRange(RegExp re, int start, int end) { re.charRange(_, start, _, _, end) } or
  /** A group term */
  TRegExpGroup(RegExp re, int start, int end) { re.group(start, end) } or
  /** A special character */
  TRegExpSpecialChar(RegExp re, int start, int end) { re.specialCharacter(start, end, _) } or
  /** A normal character */
  TRegExpNormalChar(RegExp re, int start, int end) {
    re.normalCharacterSequence(start, end)
    or
    re.escapedCharacter(start, end) and
    not re.specialCharacter(start, end, _)
  } or
  /** A back reference */
  TRegExpBackRef(RegExp re, int start, int end) { re.backreference(start, end) } or
  /** A named character property */
  TRegExpNamedCharacterProperty(RegExp re, int start, int end) {
    re.namedCharacterProperty(start, end, _)
  }

/**
 * An element containing a regular expression term, that is, either
 * a string literal (parsed as a regular expression)
 * or another regular expression term.
 */
class RegExpParent extends TRegExpParent {
  /** Gets a textual representation of this element. */
  string toString() { result = "RegExpParent" }

  /** Gets the `i`th child term. */
  RegExpTerm getChild(int i) { none() }

  /** Gets a child term . */
  final RegExpTerm getAChild() { result = this.getChild(_) }

  /** Gets the number of child terms. */
  int getNumChild() { result = count(this.getAChild()) }

  /**
   * Gets the name of a primary CodeQL class to which this regular
   * expression term belongs.
   */
  string getAPrimaryQlClass() { result = "RegExpParent" }

  /**
   * Gets a comma-separated list of the names of the primary CodeQL classes to
   * which this regular expression term belongs.
   */
  final string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }
}

/** A string literal used as a regular expression */
class RegExpLiteral extends TRegExpLiteral, RegExpParent {
  RegExp re;

  RegExpLiteral() { this = TRegExpLiteral(re) }

  override RegExpTerm getChild(int i) { i = 0 and result.getRegExp() = re and result.isRootTerm() }

  /** Holds if dot, `.`, matches all characters, including newlines. */
  predicate isDotAll() { re.isDotAll() }

  /** Holds if this regex matching is case-insensitive for this regex. */
  predicate isIgnoreCase() { re.isIgnoreCase() }

  /** Get a string representing all modes for this regex. */
  string getFlags() { result = re.getFlags() }

  /** Gets the primary QL class for this regex. */
  override string getAPrimaryQlClass() { result = "RegExpLiteral" }
}

/**
 * A regular expression term, that is, a syntactic part of a regular expression.
 */
class RegExpTerm extends RegExpParent {
  RegExp re;
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
    this = TRegExpGroup(re, start, end)
    or
    this = TRegExpQuantifier(re, start, end)
    or
    this = TRegExpSequence(re, start, end) and
    exists(seqChild(re, start, end, 1)) // if a sequence does not have more than one element, it should be treated as that element instead.
    or
    this = TRegExpSpecialChar(re, start, end)
    or
    this = TRegExpNamedCharacterProperty(re, start, end)
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

  override RegExpTerm getChild(int i) {
    result = this.(RegExpAlt).getChild(i)
    or
    result = this.(RegExpBackRef).getChild(i)
    or
    result = this.(RegExpCharacterClass).getChild(i)
    or
    result = this.(RegExpCharacterRange).getChild(i)
    or
    result = this.(RegExpNormalChar).getChild(i)
    or
    result = this.(RegExpGroup).getChild(i)
    or
    result = this.(RegExpQuantifier).getChild(i)
    or
    result = this.(RegExpSequence).getChild(i)
    or
    result = this.(RegExpSpecialChar).getChild(i)
    or
    result = this.(RegExpNamedCharacterProperty).getChild(i)
  }

  /**
   * Gets the parent term of this regular expression term, or the
   * regular expression literal if this is the root term.
   */
  RegExpParent getParent() { result.getAChild() = this }

  /** Gets the associated `RegExp`. */
  RegExp getRegExp() { result = re }

  /** Gets the offset at which this term starts. */
  int getStart() { result = start }

  /** Gets the offset at which this term ends. */
  int getEnd() { result = end }

  override string toString() { result = re.getText().substring(start, end) }

  /**
   * Gets the location of the surrounding regex, as locations inside the regex do not exist.
   * To get location information corresponding to the term inside the regex,
   * use `hasLocationInfo`.
   */
  Location getLocation() { result = re.getLocation() }

  pragma[noinline]
  private predicate componentHasLocationInfo(
    int i, string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    re.getComponent(i)
        .getLocation()
        .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Holds if this term is found at the specified location offsets. */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(int re_start, int re_end |
      this.componentHasLocationInfo(0, filepath, startline, re_start, _, _) and
      this.componentHasLocationInfo(re.getNumberOfComponents() - 1, filepath, _, _, endline, re_end) and
      startcolumn = re_start + start and
      endcolumn = re_start + end - 1
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

  /**
   * Gets the single string this regular-expression term matches.
   *
   * This predicate is only defined for (sequences/groups of) constant regular
   * expressions.  In particular, terms involving zero-width assertions like `^`
   * or `\b` are not considered to have a constant value.
   *
   * Note that this predicate does not take flags of the enclosing
   * regular-expression literal into account.
   */
  string getConstantValue() { none() }

  /**
   * Gets a string that is matched by this regular-expression term.
   */
  string getAMatchedString() { result = this.getConstantValue() }

  /** Gets the primary QL class for this term. */
  override string getAPrimaryQlClass() { result = "RegExpTerm" }
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
  boolean may_repeat_forever;

  RegExpQuantifier() {
    this = TRegExpQuantifier(re, start, end) and
    re.qualifiedPart(start, part_end, end, _, may_repeat_forever)
  }

  override RegExpTerm getChild(int i) {
    i = 0 and
    result.getRegExp() = re and
    result.getStart() = start and
    result.getEnd() = part_end
  }

  /** Hols if this term may match an unlimited number of times. */
  predicate mayRepeatForever() { may_repeat_forever = true }

  /** Gets the qualifier for this term. That is e.g "?" for "a?". */
  string getQualifier() { result = re.getText().substring(part_end, end) }

  override string getAPrimaryQlClass() { result = "RegExpQuantifier" }
}

/**
 * A regular expression term that permits unlimited repetitions.
 */
class InfiniteRepetitionQuantifier extends RegExpQuantifier {
  InfiniteRepetitionQuantifier() { this.mayRepeatForever() }

  override string getAPrimaryQlClass() { result = "InfiniteRepetitionQuantifier" }
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
  RegExpStar() { this.getQualifier().charAt(0) = "*" }

  override string getAPrimaryQlClass() { result = "RegExpStar" }
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
  RegExpPlus() { this.getQualifier().charAt(0) = "+" }

  override string getAPrimaryQlClass() { result = "RegExpPlus" }
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
  RegExpOpt() { this.getQualifier().charAt(0) = "?" }

  override string getAPrimaryQlClass() { result = "RegExpOpt" }
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

  /** Gets the string defining the upper bound of this range, if any. */
  string getUpper() { result = upper }

  /** Gets the string defining the lower bound of this range, if any. */
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

  override string getAPrimaryQlClass() { result = "RegExpRange" }
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
  RegExpSequence() {
    this = TRegExpSequence(re, start, end) and
    exists(seqChild(re, start, end, 1)) // if a sequence does not have more than one element, it should be treated as that element instead.
  }

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

  override string getConstantValue() { result = this.getConstantValue(0) }

  /**
   * Gets the single string matched by the `i`th child and all following
   * children of this sequence, if any.
   */
  private string getConstantValue(int i) {
    i = this.getNumChild() and
    result = ""
    or
    result = this.getChild(i).getConstantValue() + this.getConstantValue(i + 1)
  }

  override string getAPrimaryQlClass() { result = "RegExpSequence" }
}

pragma[nomagic]
private int seqChildEnd(RegExp re, int start, int end, int i) {
  result = seqChild(re, start, end, i).getEnd()
}

// moved out so we can use it in the charpred
private RegExpTerm seqChild(RegExp re, int start, int end, int i) {
  re.sequence(start, end) and
  (
    i = 0 and
    result.getRegExp() = re and
    result.getStart() = start and
    exists(int itemEnd |
      re.item(start, itemEnd) and
      result.getEnd() = itemEnd
    )
    or
    i > 0 and
    result.getRegExp() = re and
    exists(int itemStart | itemStart = seqChildEnd(re, start, end, i - 1) |
      result.getStart() = itemStart and
      re.item(itemStart, result.getEnd())
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
    result.getRegExp() = re and
    result.getStart() = start and
    exists(int part_end |
      re.alternationOption(start, end, start, part_end) and
      result.getEnd() = part_end
    )
    or
    i > 0 and
    result.getRegExp() = re and
    exists(int part_start |
      part_start = this.getChild(i - 1).getEnd() + 1 // allow for the |
    |
      result.getStart() = part_start and
      re.alternationOption(start, end, part_start, result.getEnd())
    )
  }

  /** Gets an alternative of this term. */
  RegExpTerm getAlternative() { result = this.getAChild() }

  override string getAMatchedString() { result = this.getAlternative().getAMatchedString() }

  override string getAPrimaryQlClass() { result = "RegExpAlt" }
}

class RegExpCharEscape = RegExpEscape;

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
    this.isIdentityEscape() and result = this.getUnescaped()
    or
    this.getUnescaped() = "n" and result = "\n"
    or
    this.getUnescaped() = "r" and result = "\r"
    or
    this.getUnescaped() = "t" and result = "\t"
    or
    this.getUnescaped() = "f" and result = 12.toUnicode()
    or
    this.getUnescaped() = "v" and result = 11.toUnicode()
    or
    this.isUnicode() and
    result = this.getUnicode()
  }

  /** Holds if this terms name is given by the part following the escape character. */
  predicate isIdentityEscape() {
    not this.getUnescaped() in ["n", "r", "t", "f", "v"] and not this.isUnicode()
  }

  override string getAPrimaryQlClass() { result = "RegExpEscape" }

  /** Gets the part of the term following the escape character. That is e.g. "w" if the term is "\w". */
  string getUnescaped() { result = this.getText().suffix(1) }

  /**
   * Gets the text for this escape. That is e.g. "\w".
   */
  private string getText() { result = re.getText().substring(start, end) }

  /**
   * Holds if this is a unicode escape.
   */
  private predicate isUnicode() { this.getText().prefix(2) = ["\\u", "\\U"] }

  /**
   * Gets the unicode char for this escape.
   * E.g. for `\u0061` this returns "a".
   */
  private string getUnicode() {
    this.isUnicode() and
    result = parseHexInt(this.getText().suffix(2)).toUnicode()
  }
}

/**
 * A word boundary, that is, a regular expression term of the form `\b`.
 */
class RegExpWordBoundary extends RegExpSpecialChar {
  RegExpWordBoundary() { this.getChar() = "\\b" }
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
  RegExpCharacterClassEscape() { this.getValue() in ["d", "D", "s", "S", "w", "W", "h", "H"] }

  override RegExpTerm getChild(int i) { none() }

  override string getAPrimaryQlClass() { result = "RegExpCharacterClassEscape" }
}

/**
 * A character class in a regular expression.
 *
 * Examples:
 *
 * ```rb
 * /[a-fA-F0-9]/
 * /[^abc]/
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
    result.getRegExp() = re and
    exists(int itemStart, int itemEnd |
      result.getStart() = itemStart and
      re.charSetStart(start, itemStart) and
      re.charSetChild(start, itemStart, itemEnd) and
      result.getEnd() = itemEnd
    )
    or
    i > 0 and
    result.getRegExp() = re and
    exists(int itemStart | itemStart = this.getChild(i - 1).getEnd() |
      result.getStart() = itemStart and
      re.charSetChild(start, itemStart, result.getEnd())
    )
  }

  override string getAMatchedString() {
    not this.isInverted() and result = this.getAChild().getAMatchedString()
  }

  override string getAPrimaryQlClass() { result = "RegExpCharacterClass" }
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
    result.getRegExp() = re and
    result.getStart() = start and
    result.getEnd() = lower_end
    or
    i = 1 and
    result.getRegExp() = re and
    result.getStart() = upper_start and
    result.getEnd() = end
  }

  override string getAPrimaryQlClass() { result = "RegExpCharacterRange" }
}

/**
 * A normal character in a regular expression, that is, a character
 * without special meaning. This includes escaped characters.
 *
 * Examples:
 * ```
 * t
 * \t
 * ```
 */
class RegExpNormalChar extends RegExpTerm, TRegExpNormalChar {
  RegExpNormalChar() { this = TRegExpNormalChar(re, start, end) }

  /**
   * Holds if this constant represents a valid Unicode character (as opposed
   * to a surrogate code point that does not correspond to a character by itself.)
   */
  predicate isCharacter() { any() }

  /** Gets the string representation of the char matched by this term. */
  string getValue() { result = re.getText().substring(start, end) }

  override RegExpTerm getChild(int i) { none() }

  override string getAPrimaryQlClass() { result = "RegExpNormalChar" }
}

/**
 * A constant regular expression term, that is, a regular expression
 * term matching a single string. Currently, this will always be a single character.
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
    this = TRegExpNormalChar(re, start, end) and
    not this instanceof RegExpCharacterClassEscape and
    // exclude chars in qualifiers
    // TODO: push this into regex library
    not exists(int qstart, int qend | re.qualifiedPart(_, qstart, qend, _, _) |
      qstart <= start and end <= qend
    ) and
    value = this.(RegExpNormalChar).getValue()
    or
    this = TRegExpSpecialChar(re, start, end) and
    re.inCharSet(start) and
    value = this.(RegExpSpecialChar).getChar()
  }

  /**
   * Holds if this constant represents a valid Unicode character (as opposed
   * to a surrogate code point that does not correspond to a character by itself.)
   */
  predicate isCharacter() { any() }

  /** Gets the string matched by this constant term. */
  string getValue() { result = value }

  override RegExpTerm getChild(int i) { none() }

  override string getConstantValue() { result = this.getValue() }

  override string getAPrimaryQlClass() { result = "RegExpConstant" }
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

  /** Holds if this is a capture group. */
  predicate isCapture() { exists(this.getNumber()) }

  /** Holds if this is a named capture group. */
  predicate isNamed() { exists(this.getName()) }

  /** Gets the name of this capture group, if any. */
  string getName() { result = re.getGroupName(start, end) }

  override RegExpTerm getChild(int i) {
    result.getRegExp() = re and
    i = 0 and
    re.groupContents(start, end, result.getStart(), result.getEnd())
  }

  override string getConstantValue() { result = this.getAChild().getConstantValue() }

  override string getAMatchedString() { result = this.getAChild().getAMatchedString() }

  override string getAPrimaryQlClass() { result = "RegExpGroup" }
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
class RegExpSpecialChar extends RegExpTerm, TRegExpSpecialChar {
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

  override string getAPrimaryQlClass() { result = "RegExpSpecialChar" }
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

  override string getAPrimaryQlClass() { result = "RegExpDot" }
}

/**
 * A dollar assertion `$` or `\Z` matching the end of a line.
 *
 * Example:
 *
 * ```
 * $
 * ```
 */
class RegExpDollar extends RegExpSpecialChar {
  RegExpDollar() { this.getChar() = ["$", "\\Z", "\\z"] }

  override string getAPrimaryQlClass() { result = "RegExpDollar" }
}

/**
 * A caret assertion `^` or `\A` matching the beginning of a line.
 *
 * Example:
 *
 * ```
 * ^
 * ```
 */
class RegExpCaret extends RegExpSpecialChar {
  RegExpCaret() { this.getChar() = ["^", "\\A"] }

  override string getAPrimaryQlClass() { result = "RegExpCaret" }
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
class RegExpZeroWidthMatch extends RegExpGroup {
  RegExpZeroWidthMatch() { re.zeroWidthMatch(start, end) }

  override RegExpTerm getChild(int i) { none() }

  override string getAPrimaryQlClass() { result = "RegExpZeroWidthMatch" }
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
      result.getRegExp() = re and
      result.getStart() = in_start and
      result.getEnd() = in_end
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

  override string getAPrimaryQlClass() { result = "RegExpPositiveLookahead" }
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
class RegExpNegativeLookahead extends RegExpLookahead {
  RegExpNegativeLookahead() { re.negativeLookaheadAssertionGroup(start, end) }

  override string getAPrimaryQlClass() { result = "RegExpNegativeLookahead" }
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

  override string getAPrimaryQlClass() { result = "RegExpPositiveLookbehind" }
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
class RegExpNegativeLookbehind extends RegExpLookbehind {
  RegExpNegativeLookbehind() { re.negativeLookbehindAssertionGroup(start, end) }

  override string getAPrimaryQlClass() { result = "RegExpNegativeLookbehind" }
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
  int getNumber() { result = re.getBackRefNumber(start, end) }

  /**
   * Gets the name of the capture group this back reference refers to, if any.
   */
  string getName() { result = re.getBackRefName(start, end) }

  /** Gets the capture group this back reference refers to. */
  RegExpGroup getGroup() {
    result.getLiteral() = this.getLiteral() and
    (
      result.getNumber() = this.getNumber() or
      result.getName() = this.getName()
    )
  }

  override RegExpTerm getChild(int i) { none() }

  override string getAPrimaryQlClass() { result = "RegExpBackRef" }
}

/**
 * A named character property. For example, the POSIX bracket expression
 * `[[:digit:]]`.
 */
class RegExpNamedCharacterProperty extends RegExpTerm, TRegExpNamedCharacterProperty {
  RegExpNamedCharacterProperty() { this = TRegExpNamedCharacterProperty(re, start, end) }

  override RegExpTerm getChild(int i) { none() }

  override string getAPrimaryQlClass() { result = "RegExpNamedCharacterProperty" }

  /**
   * Gets the property name. For example, in `\p{Space}`, the result is
   * `"Space"`.
   */
  string getName() { result = re.getCharacterPropertyName(start, end) }

  /**
   * Holds if the property is inverted. For example, it holds for `\p{^Digit}`,
   * which matches non-digits.
   */
  predicate isInverted() { re.namedCharacterPropertyIsInverted(start, end) }
}

/** Gets the parse tree resulting from parsing `re`, if such has been constructed. */
RegExpTerm getParsedRegExp(AST::RegExpLiteral re) {
  result.getRegExp() = re and result.isRootTerm()
}

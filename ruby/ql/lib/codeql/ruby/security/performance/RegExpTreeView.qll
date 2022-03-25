private import codeql.ruby.ast.Literal as AST
private import ParseRegExp
private import codeql.NumberUtils
import codeql.Locations
private import codeql.ruby.DataFlow

/**
 * Holds if `term` is an ecape class representing e.g. `\d`.
 * `clazz` is which character class it represents, e.g. "d" for `\d`.
 */
predicate isEscapeClass(RegExpTerm term, string clazz) {
  exists(RegExpCharacterClassEscape escape | term = escape | escape.getValue() = clazz)
  or
  // TODO: expand to cover more properties
  exists(RegExpNamedCharacterProperty escape | term = escape |
    escape.getName().toLowerCase() = "digit" and
    if escape.isInverted() then clazz = "D" else clazz = "d"
    or
    escape.getName().toLowerCase() = "space" and
    if escape.isInverted() then clazz = "S" else clazz = "s"
    or
    escape.getName().toLowerCase() = "word" and
    if escape.isInverted() then clazz = "W" else clazz = "w"
  )
}

/**
 * Holds if the regular expression should not be considered.
 */
predicate isExcluded(RegExpParent parent) {
  parent.(RegExpTerm).getRegExp().(AST::RegExpLiteral).hasFreeSpacingFlag() // exclude free-spacing mode regexes
}

/**
 * A module containing predicates for determining which flags a regular expression have.
 */
module RegExpFlags {
  /**
   * Holds if `root` has the `i` flag for case-insensitive matching.
   */
  predicate isIgnoreCase(RegExpTerm root) {
    root.isRootTerm() and
    root.getLiteral().isIgnoreCase()
  }

  /**
   * Gets the flags for `root`, or the empty string if `root` has no flags.
   */
  string getFlags(RegExpTerm root) {
    root.isRootTerm() and
    result = root.getLiteral().getFlags()
  }

  /**
   * Holds if `root` has the `s` flag for multi-line matching.
   */
  predicate isDotAll(RegExpTerm root) {
    root.isRootTerm() and
    root.getLiteral().isDotAll()
  }
}

/**
 * Provides utility predicates related to regular expressions.
 */
module RegExpPatterns {
  /**
   * Gets a pattern that matches common top-level domain names in lower case.
   */
  string getACommonTld() {
    // according to ranking by http://google.com/search?q=site:.<<TLD>>
    result = "(?:com|org|edu|gov|uk|net|io)(?![a-z0-9])"
  }
}

/**
 * An element containing a regular expression term, that is, either
 * a string literal (parsed as a regular expression)
 * or another regular expression term.
 */
class RegExpParent extends TRegExpParent {
  string toString() { result = "RegExpParent" }

  RegExpTerm getChild(int i) { none() }

  final RegExpTerm getAChild() { result = this.getChild(_) }

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

class RegExpLiteral extends TRegExpLiteral, RegExpParent {
  RegExp re;

  RegExpLiteral() { this = TRegExpLiteral(re) }

  override RegExpTerm getChild(int i) { i = 0 and result.getRegExp() = re and result.isRootTerm() }

  predicate isDotAll() { re.isDotAll() }

  predicate isIgnoreCase() { re.isIgnoreCase() }

  string getFlags() { result = re.getFlags() }

  override string getAPrimaryQlClass() { result = "RegExpLiteral" }
}

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

  RegExpTerm getRootTerm() {
    this.isRootTerm() and result = this
    or
    result = this.getParent().(RegExpTerm).getRootTerm()
  }

  predicate isUsedAsRegExp() { any() }

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

  RegExpParent getParent() { result.getAChild() = this }

  RegExp getRegExp() { result = re }

  int getStart() { result = start }

  int getEnd() { result = end }

  override string toString() { result = re.getText().substring(start, end) }

  override string getAPrimaryQlClass() { result = "RegExpTerm" }

  Location getLocation() { result = re.getLocation() }

  pragma[noinline]
  private predicate componentHasLocationInfo(
    int i, string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    re.getComponent(i)
        .getLocation()
        .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

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

  File getFile() { result = this.getLocation().getFile() }

  string getRawValue() { result = this.toString() }

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
}

newtype TRegExpParent =
  TRegExpLiteral(RegExp re) or
  TRegExpQuantifier(RegExp re, int start, int end) { re.qualifiedItem(start, end, _, _) } or
  TRegExpSequence(RegExp re, int start, int end) { re.sequence(start, end) } or
  TRegExpAlt(RegExp re, int start, int end) { re.alternation(start, end) } or
  TRegExpCharacterClass(RegExp re, int start, int end) { re.charSet(start, end) } or
  TRegExpCharacterRange(RegExp re, int start, int end) { re.charRange(_, start, _, _, end) } or
  TRegExpGroup(RegExp re, int start, int end) { re.group(start, end) } or
  TRegExpSpecialChar(RegExp re, int start, int end) { re.specialCharacter(start, end, _) } or
  TRegExpNormalChar(RegExp re, int start, int end) {
    re.normalCharacterSequence(start, end)
    or
    re.escapedCharacter(start, end) and
    not re.specialCharacter(start, end, _)
  } or
  TRegExpBackRef(RegExp re, int start, int end) { re.backreference(start, end) } or
  TRegExpNamedCharacterProperty(RegExp re, int start, int end) {
    re.namedCharacterProperty(start, end, _)
  }

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

  predicate mayRepeatForever() { may_repeat_forever = true }

  string getQualifier() { result = re.getText().substring(part_end, end) }

  override string getAPrimaryQlClass() { result = "RegExpQuantifier" }
}

class InfiniteRepetitionQuantifier extends RegExpQuantifier {
  InfiniteRepetitionQuantifier() { this.mayRepeatForever() }

  override string getAPrimaryQlClass() { result = "InfiniteRepetitionQuantifier" }
}

class RegExpStar extends InfiniteRepetitionQuantifier {
  RegExpStar() { this.getQualifier().charAt(0) = "*" }

  override string getAPrimaryQlClass() { result = "RegExpStar" }
}

class RegExpPlus extends InfiniteRepetitionQuantifier {
  RegExpPlus() { this.getQualifier().charAt(0) = "+" }

  override string getAPrimaryQlClass() { result = "RegExpPlus" }
}

class RegExpOpt extends RegExpQuantifier {
  RegExpOpt() { this.getQualifier().charAt(0) = "?" }

  override string getAPrimaryQlClass() { result = "RegExpOpt" }
}

class RegExpRange extends RegExpQuantifier {
  string upper;
  string lower;

  RegExpRange() { re.multiples(part_end, end, lower, upper) }

  string getUpper() { result = upper }

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

  override string getAPrimaryQlClass() { result = "RegExpAlt" }
}

class RegExpCharEscape = RegExpEscape;

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
    this.isUnicode() and
    result = this.getUnicode()
  }

  predicate isIdentityEscape() {
    not this.getUnescaped() in ["n", "r", "t"] and not this.isUnicode()
  }

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

  string getUnescaped() { result = this.getText().suffix(1) }

  override string getAPrimaryQlClass() { result = "RegExpEscape" }
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

  /** Gets the name of the character class; for example, `w` for `\w`. */
  // override string getValue() { result = value }
  override RegExpTerm getChild(int i) { none() }

  override string getAPrimaryQlClass() { result = "RegExpCharacterClassEscape" }
}

/**
 * A character class.
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

  predicate isInverted() { re.getChar(start + 1) = "^" }

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

  override string getAPrimaryQlClass() { result = "RegExpCharacterClass" }
}

class RegExpCharacterRange extends RegExpTerm, TRegExpCharacterRange {
  int lower_end;
  int upper_start;

  RegExpCharacterRange() {
    this = TRegExpCharacterRange(re, start, end) and
    re.charRange(_, start, lower_end, upper_start, end)
  }

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

class RegExpNormalChar extends RegExpTerm, TRegExpNormalChar {
  RegExpNormalChar() { this = TRegExpNormalChar(re, start, end) }

  predicate isCharacter() { any() }

  string getValue() { result = re.getText().substring(start, end) }

  override RegExpTerm getChild(int i) { none() }

  override string getAPrimaryQlClass() { result = "RegExpNormalChar" }
}

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

  predicate isCharacter() { any() }

  string getValue() { result = value }

  override RegExpTerm getChild(int i) { none() }

  override string getAPrimaryQlClass() { result = "RegExpConstant" }
}

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

  predicate isCharacter() { any() }

  string getValue() { result = re.getText().substring(start, end) }

  override RegExpTerm getChild(int i) {
    result.getRegExp() = re and
    i = 0 and
    re.groupContents(start, end, result.getStart(), result.getEnd())
  }

  override string getAPrimaryQlClass() { result = "RegExpGroup" }
}

class RegExpSpecialChar extends RegExpTerm, TRegExpSpecialChar {
  string char;

  RegExpSpecialChar() {
    this = TRegExpSpecialChar(re, start, end) and
    re.specialCharacter(start, end, char)
  }

  predicate isCharacter() { any() }

  string getChar() { result = char }

  override RegExpTerm getChild(int i) { none() }

  override string getAPrimaryQlClass() { result = "RegExpSpecialChar" }
}

class RegExpDot extends RegExpSpecialChar {
  RegExpDot() { this.getChar() = "." }

  override string getAPrimaryQlClass() { result = "RegExpDot" }
}

class RegExpDollar extends RegExpSpecialChar {
  RegExpDollar() { this.getChar() = ["$", "\\Z", "\\z"] }

  override string getAPrimaryQlClass() { result = "RegExpDollar" }
}

class RegExpCaret extends RegExpSpecialChar {
  RegExpCaret() { this.getChar() = ["^", "\\A"] }

  override string getAPrimaryQlClass() { result = "RegExpCaret" }
}

class RegExpZeroWidthMatch extends RegExpGroup {
  RegExpZeroWidthMatch() { re.zeroWidthMatch(start, end) }

  override predicate isCharacter() { any() }

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

abstract class RegExpLookahead extends RegExpSubPattern { }

class RegExpPositiveLookahead extends RegExpLookahead {
  RegExpPositiveLookahead() { re.positiveLookaheadAssertionGroup(start, end) }

  override string getAPrimaryQlClass() { result = "RegExpPositiveLookahead" }
}

class RegExpNegativeLookahead extends RegExpLookahead {
  RegExpNegativeLookahead() { re.negativeLookaheadAssertionGroup(start, end) }

  override string getAPrimaryQlClass() { result = "RegExpNegativeLookahead" }
}

abstract class RegExpLookbehind extends RegExpSubPattern { }

class RegExpPositiveLookbehind extends RegExpLookbehind {
  RegExpPositiveLookbehind() { re.positiveLookbehindAssertionGroup(start, end) }

  override string getAPrimaryQlClass() { result = "RegExpPositiveLookbehind" }
}

class RegExpNegativeLookbehind extends RegExpLookbehind {
  RegExpNegativeLookbehind() { re.negativeLookbehindAssertionGroup(start, end) }

  override string getAPrimaryQlClass() { result = "RegExpNegativeLookbehind" }
}

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

RegExpTerm getParsedRegExp(AST::RegExpLiteral re) {
  result.getRegExp() = re and result.isRootTerm()
}

/**
 * A node whose value may flow to a position where it is interpreted
 * as a part of a regular expression.
 */
abstract class RegExpPatternSource extends DataFlow::Node {
  /**
   * Gets a node where the pattern of this node is parsed as a part of
   * a regular expression.
   */
  abstract DataFlow::Node getAParse();

  /**
   * Gets the root term of the regular expression parsed from this pattern.
   */
  abstract RegExpTerm getRegExpTerm();
}

/**
 * A regular expression literal, viewed as the pattern source for itself.
 */
private class RegExpLiteralPatternSource extends RegExpPatternSource {
  private AST::RegExpLiteral astNode;

  RegExpLiteralPatternSource() { astNode = this.asExpr().getExpr() }

  override DataFlow::Node getAParse() { result = this }

  override RegExpTerm getRegExpTerm() { result = astNode.getParsed() }
}

/**
 * A node whose string value may flow to a position where it is interpreted
 * as a part of a regular expression.
 */
private class StringRegExpPatternSource extends RegExpPatternSource {
  private DataFlow::Node parse;

  StringRegExpPatternSource() { this = regExpSource(parse) }

  override DataFlow::Node getAParse() { result = parse }

  override RegExpTerm getRegExpTerm() { result.getRegExp() = this.asExpr().getExpr() }
}

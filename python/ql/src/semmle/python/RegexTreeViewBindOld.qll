import python
private import semmle.python.regex

/**
 * An element containing a regular expression term, that is, either
 * a string literal (parsed as a regular expression)
 * or another regular expression term.
 */
class RegExpParent extends TRegExpParent {
  string toString() { result = "RegExpParent" }

  abstract RegExpTerm getChild(int i);

  RegExpTerm getAChild() { result = getChild(_) }

  int getNumChild() { result = count(getAChild()) }
}

class RegExpLiteral extends TRegExpLiteral, RegExpParent {
  Regex re;

  RegExpLiteral() { this = TRegExpLiteral(re) }

  override RegExpTerm getChild(int i) { i = 0 and result.getRegex() = re and result.isRootTerm() }

  predicate isDotAll() { re.getAMode() = "DOTALL" }

  override string toString() { result = re.toString() }
}

predicate colocated(RegExpTerm a, string rawA, RegExpTerm b, string rawB) {
  a.getRegex() = b.getRegex() and
  a.getStart() = b.getStart() and
  a.getEnd() = b.getEnd() and
  not a = b and
  rawA = a.getAQlClass() and
  rawB = b.getAQlClass()
}

class RegExpTerm extends RegExpParent {
  Regex re;
  int start;
  int end;

  RegExpTerm() {
    this = TRegExpAlt(re, start, end)
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
  }

  RegExpTerm getRootTerm() {
    this.isRootTerm() and result = this
    or
    result = getParent().(RegExpTerm).getRootTerm()
  }

  predicate isUsedAsRegExp() { any() }

  predicate isRootTerm() { start = 0 and end = re.getText().length() }

  override RegExpTerm getChild(int i) {
    result = this.(RegExpAlt).getChild(i)
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
  }

  RegExpParent getParent() { result.getAChild() = this }

  Regex getRegex() { result = re }

  int getStart() { result = start }

  int getEnd() { result = end }

  override string toString() { result = re.getText().substring(start, end) }

  Location getLocation() { result = re.getLocation() }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(int re_start, int re_end |
      re.getLocation().hasLocationInfo(filepath, startline, re_start, endline, re_end) and
      startcolumn = re_start + start + 4 and
      endcolumn = re_start + end + 3
    )
  }

  File getFile() { result = this.getLocation().getFile() }

  string getRawValue() { result = re.getText() }

  RegExpLiteral getLiteral() { result = TRegExpLiteral(re) }

  string getPrimaryQLClass() { result = "RegExpTerm" }
}

newtype TRegExpParent =
  TRegExpLiteral(Regex re) or
  TRegExpQuantifier(Regex re, int start, int end) { re.qualifiedItem(start, end, _, _) } or
  TRegExpSequence(Regex re, int start, int end) { re.sequence(start, end) } or
  TRegExpAlt(Regex re, int start, int end) { re.alternation(start, end) } or
  TRegExpCharacterClass(Regex re, int start, int end) { re.charSet(start, end) } or
  TRegExpCharacterRange(Regex re, int start, int end) { re.charRange(_, start, _, _, end) } or
  TRegExpGroup(Regex re, int start, int end) { re.group(start, end) } or
  TRegExpSpecialChar(Regex re, int start, int end) { re.specialCharacter(start, end, _) } or
  TRegExpNormalChar(Regex re, int start, int end) { re.normalCharacter(start, end) }

class RegExpQuantifier extends RegExpTerm, TRegExpQuantifier {
  int part_end;
  boolean maybe_empty;
  boolean may_repeat_forever;

  RegExpQuantifier() {
    this = TRegExpQuantifier(re, start, end) and
    re.qualifiedPart(start, part_end, end, maybe_empty, may_repeat_forever)
  }

  override RegExpTerm getChild(int i) {
    i = 0 and
    result.getRegex() = re and
    result.getStart() = start and
    result.getEnd() = part_end
  }

  predicate mayRepeatForever() { may_repeat_forever = true }

  string getQualifier() { result = re.getText().substring(part_end, end) }

  override string getPrimaryQLClass() { result = "RegExpQuantifier" }
}

class InfiniteRepetitionQuantifier extends RegExpQuantifier {
  InfiniteRepetitionQuantifier() { this.mayRepeatForever() }
}

class RegExpStar extends InfiniteRepetitionQuantifier {
  RegExpStar() { this.getQualifier().charAt(0) = "*" }

  override string getPrimaryQLClass() { result = "RegExpStar" }
}

class RegExpPlus extends InfiniteRepetitionQuantifier {
  RegExpPlus() { this.getQualifier().charAt(0) = "+" }

  override string getPrimaryQLClass() { result = "RegExpPlus" }
}

class RegExpOpt extends RegExpQuantifier {
  RegExpOpt() { this.getQualifier().charAt(0) = "?" }

  override string getPrimaryQLClass() { result = "RegExpOpt" }
}

class RegExpRange extends RegExpQuantifier {
  string upper;
  string lower;

  RegExpRange() { re.multiples(part_end, end, lower, upper) }

  string getUpper() { result = upper }

  string getLower() { result = lower }

  override string getPrimaryQLClass() { result = "RegExpRange" }
}

class RegExpSequence extends RegExpTerm, TRegExpSequence {
  RegExpSequence() {
    this = TRegExpSequence(re, start, end) and
    exists(seqChild(re, start, end, 1)) // if a sequence does not have more than one element, it should be treated as that element instead.
  }

  override RegExpTerm getChild(int i) { result = seqChild(re, start, end, i) }

  override string getPrimaryQLClass() { result = "RegExpSequence" }
}

// moved out so we can use it in the charpred
private RegExpTerm seqChild(Regex re, int start, int end, int i) {
  re.sequence(start, end) and
  (
    i = 0 and
    result.getRegex() = re and
    result.getStart() = start and
    exists(int itemEnd |
      re.item(start, itemEnd) and
      result.getEnd() = itemEnd
    )
    or
    i > 0 and
    result.getRegex() = re and
    exists(int itemStart | itemStart = seqChild(re, start, end, i - 1).getEnd() |
      result.getStart() = itemStart and
      re.item(itemStart, result.getEnd())
    )
  )
}

class RegExpAlt extends RegExpTerm, TRegExpAlt {
  RegExpAlt() { this = TRegExpAlt(re, start, end) }

  override RegExpTerm getChild(int i) {
    i = 0 and
    result.getRegex() = re and
    result.getStart() = start and
    exists(int part_end |
      re.alternationOption(start, end, start, part_end) and
      result.getEnd() = part_end
    )
    or
    i > 0 and
    result.getRegex() = re and
    exists(int part_start |
      part_start = this.getChild(i - 1).getEnd() + 1 // allow for the |
    |
      result.getStart() = part_start and
      re.alternationOption(start, end, part_start, result.getEnd())
    )
  }

  override string getPrimaryQLClass() { result = "RegExpAlt" }
}

class RegExpEscape extends RegExpNormalChar {
  RegExpEscape() { re.escapedCharacter(start, end) }

  /**
   * Gets the name of the escaped; for example, `w` for `\w`.
   * TODO: Handle unicode and named escapes.
   */
  override string getValue() { result = re.getText().substring(start + 1, end) }
}

/**
 * A character class escape in a regular expression.
 * That is, an escaped charachter that denotes multiple characters.
 *
 * Examples:
 *
 * ```
 * \w
 * \S
 * ```
 */
class RegExpCharacterClassEscape extends RegExpEscape {
  // string value;
  RegExpCharacterClassEscape() {
    // value = re.getText().substring(start + 1, end) and
    // value in ["b", "B", "d", "D", "s", "S", "w", "W"]
    this.getValue() in ["b", "B", "d", "D", "s", "S", "w", "W"]
  }

  /** Gets the name of the character class; for example, `w` for `\w`. */
  // override string getValue() { result = value }
  override RegExpTerm getChild(int i) { none() }

  override string getPrimaryQLClass() { result = "RegExpCharacterClassEscape" }
}

class RegExpCharacterClass extends RegExpTerm, TRegExpCharacterClass {
  RegExpCharacterClass() { this = TRegExpCharacterClass(re, start, end) }

  predicate isInverted() { re.getChar(start + 1) = "^" }

  string getCharThing(int i) { result = re.getChar(i + start) }

  predicate isUniversalClass() {
    // [^]
    isInverted() and not exists(getAChild())
    or
    // [\w\W] and similar
    not isInverted() and
    exists(string cce1, string cce2 |
      cce1 = getAChild().(RegExpCharacterClassEscape).getValue() and
      cce2 = getAChild().(RegExpCharacterClassEscape).getValue()
    |
      cce1 != cce2 and cce1.toLowerCase() = cce2.toLowerCase()
    )
  }

  override RegExpTerm getChild(int i) {
    i = 0 and
    result.getRegex() = re and
    exists(int itemStart, int itemEnd |
      result.getStart() = itemStart and
      re.char_set_start(start, itemStart) and
      re.char_set_child(start, itemStart, itemEnd) and
      result.getEnd() = itemEnd
    )
    or
    i > 0 and
    result.getRegex() = re and
    exists(int itemStart | itemStart = this.getChild(i - 1).getEnd() |
      result.getStart() = itemStart and
      re.char_set_child(start, itemStart, result.getEnd())
    )
  }

  override string getPrimaryQLClass() { result = "RegExpCharacterClass" }
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
    result.getRegex() = re and
    result.getStart() = start and
    result.getEnd() = lower_end
    or
    i = 1 and
    result.getRegex() = re and
    result.getStart() = upper_start and
    result.getEnd() = end
  }

  override string getPrimaryQLClass() { result = "RegExpCharacterRange" }
}

class RegExpNormalChar extends RegExpTerm, TRegExpNormalChar {
  RegExpNormalChar() { this = TRegExpNormalChar(re, start, end) }

  predicate isCharacter() { any() }

  string getValue() { result = re.getText().substring(start, end) }

  override RegExpTerm getChild(int i) { none() }

  override string getPrimaryQLClass() { result = "RegExpNormalChar" }
}

class RegExpConstant extends RegExpTerm {
  string value;

  RegExpConstant() {
    this = TRegExpNormalChar(re, start, end) and
    not this instanceof RegExpCharacterClassEscape and
    // exclude chars in qualifiers
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

  override string getPrimaryQLClass() { result = "RegExpConstant" }
}

class RegExpGroup extends RegExpTerm, TRegExpGroup {
  RegExpGroup() { this = TRegExpGroup(re, start, end) }

  predicate isCharacter() { any() }

  string getValue() { result = re.getText().substring(start, end) }

  override RegExpTerm getChild(int i) {
    result.getRegex() = re and
    i = 0 and
    re.groupContents(start, end, result.getStart(), result.getEnd())
  }

  override string getPrimaryQLClass() { result = "RegExpGroup" }
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

  override string getPrimaryQLClass() { result = "RegExpSpecialChar" }
}

class RegExpDot extends RegExpSpecialChar {
  RegExpDot() { this.getChar() = "." }

  override string getPrimaryQLClass() { result = "RegExpDot" }
}

class RegExpDollar extends RegExpSpecialChar {
  RegExpDollar() { this.getChar() = "$" }

  override string getPrimaryQLClass() { result = "RegExpDollar" }
}

class RegExpCaret extends RegExpSpecialChar {
  RegExpCaret() { this.getChar() = "^" }

  override string getPrimaryQLClass() { result = "RegExpCaret" }
}

class RegExpZeroWidthMatch extends RegExpGroup {
  RegExpZeroWidthMatch() { re.zeroWidthMatch(start, end) }

  override predicate isCharacter() { any() }

  override RegExpTerm getChild(int i) { none() }

  override string getPrimaryQLClass() { result = "RegExpZeroWidthMatch" }
}

abstract class RegExpLookahead extends RegExpZeroWidthMatch { }

class RegExpPositiveLookahead extends RegExpLookahead {
  RegExpPositiveLookahead() { re.positiveLookaheadAssertionGroup(start, end) }

  override string getPrimaryQLClass() { result = "RegExpPositiveLookahead" }
}

class RegExpNegativeLookahead extends RegExpLookahead {
  RegExpNegativeLookahead() { re.negativeLookaheadAssertionGroup(start, end) }

  override string getPrimaryQLClass() { result = "RegExpNegativeLookahead" }
}

abstract class RegExpLookbehind extends RegExpZeroWidthMatch { }

class RegExpPositiveLookbehind extends RegExpLookbehind {
  RegExpPositiveLookbehind() { re.positiveLookbehindAssertionGroup(start, end) }

  override string getPrimaryQLClass() { result = "RegExpPositiveLookbehind" }
}

class RegExpNegativeLookbehind extends RegExpLookbehind {
  RegExpNegativeLookbehind() { re.negativeLookbehindAssertionGroup(start, end) }

  override string getPrimaryQLClass() { result = "RegExpNegativeLookbehind" }
}

RegExpTerm getParsedRegExp(StrConst re) { result.getRegex() = re and result.isRootTerm() }

import python
private import semmle.python.RegexLiteral as L
private import semmle.python.RegexParserExtended as P

/** Defenitions for compatibility with the JS ReDoS query */
private newtype TRegExpParent =
  TRegExpLiteral(L::RegexLiteral re) { exists(re.getRegex()) } or
  TRegExp(P::Regex re) {
    re.isRooted() and
    not exists(P::OrRegex par | par.isRooted() and re.(P::OrRegex) = par.getLeft())
  } or
  TClassChar(P::ClassChar ch) { ch.getClass().isRooted() and ch.isRooted() } or
  TClassRange(P::ClassRange rn) { rn.isRooted() }

class RegExpParent extends TRegExpParent {
  RegExpTerm getChild(int i) { none() }

  RegExpTerm getAChild() { result = getChild(_) }

  RegExpParent getParent() { result.getAChild() = this }

  int getNumChild() { result = count(getAChild()) }

  string toString() { result = "" }

  predicate hasLocationInfo(string file, int startline, int startcol, int endline, int endcol) {
    none()
  }

  Location getLocation() {
    result
        .hasLocationInfo(this.getFile().getRelativePath(), this.getStartline(), this.getStartcol(),
          this.getEndline(), this.getEndcol())
  }

  File getFile() { this.hasLocationInfo(result.getRelativePath(), _, _, _, _) }

  int getStartline() { this.hasLocationInfo(_, result, _, _, _) }

  int getStartcol() { this.hasLocationInfo(_, _, result, _, _) }

  int getEndline() { this.hasLocationInfo(_, _, _, result, _) }

  int getEndcol() { this.hasLocationInfo(_, _, _, _, result) }

  string getRawValue() { result = this.toString() }
}

class RegExpLiteral extends RegExpParent, TRegExpLiteral {
  L::RegexLiteral re;

  RegExpLiteral() { this = TRegExpLiteral(re) }

  override RegExpTerm getChild(int i) { result = TRegExp(re.getRegex()) and i = 0 }

  predicate isDotAll() { none() }

  override string toString() { result = re.toString() }

  override predicate hasLocationInfo(
    string file, int startline, int startcol, int endline, int endcol
  ) {
    re.getLocation().hasLocationInfo(file, startline, startcol, endline, endcol)
  }
}

class RegExpTerm extends RegExpParent {
  P::Node node;

  RegExpTerm() {
    this = TRegExp(node) or
    this = TClassChar(node) or
    this = TClassRange(node)
  }

  predicate isUsedAsRegExp() { any() }

  predicate isRootTerm() { node.isRoot() }

  override string toString() { result = node.toString() }

  RegExpLiteral getLiteral() { result = getRootTerm().getParent() }

  /**
   * Gets the outermost term of this regular expression.
   */
  RegExpTerm getRootTerm() {
    isRootTerm() and
    result = this
    or
    result = getParent().(RegExpTerm).getRootTerm()
  }

  override predicate hasLocationInfo(
    string file, int startline, int startcol, int endline, int endcol
  ) {
    node.hasLocationInfo(file, startline, startcol, endline, endcol)
  }
}

private class NormalRegExpTerm extends RegExpTerm, TRegExp {
  override P::Regex node;

  NormalRegExpTerm() { this = TRegExp(node) }
}

class RegExpAlt extends NormalRegExpTerm {
  override P::OrRegex node;

  override RegExpTerm getChild(int i) {
    result = TRegExp(orRevChild(node, orNumChild(node) - i - 1))
  }
}

private P::Regex orRevChild(P::Regex re, int i) {
  i = 0 and
  not re instanceof P::OrRegex and
  result = re
  or
  i = 0 and
  result = re.(P::OrRegex).getRight()
  or
  i > 0 and
  result = orRevChild(re.(P::OrRegex).getLeft(), i - 1)
}

private int orNumChild(P::OrRegex re) { result = strictcount(orRevChild(re, _)) }

class RegExpQuantifier extends NormalRegExpTerm {
  override P::SuffixRegex node;

  override RegExpTerm getChild(int i) { i = 0 and result = TRegExp(node.getBody()) }
}

class RegExpLookbehind extends NormalRegExpTerm {
  RegExpLookbehind() {
    node instanceof P::NegativeLookbehindRegex or node instanceof P::PositiveLookbehindRegex
  }
}

class RegExpStar extends RegExpQuantifier {
  override P::StarRegex node;
}

class RegExpPlus extends RegExpQuantifier {
  override P::PlusRegex node;
}

class RegExpRange extends RegExpQuantifier {
  override P::RepeatRegex node;

  int getLowerBound() { result = node.getLowerBound() }

  int getUpperBound() { result = node.getUpperBound() }
}

class RegExpOpt extends RegExpQuantifier {
  override P::OptionalRegex node;
}

class RegExpConstant extends RegExpTerm {
  RegExpConstant() {
    this = TRegExp(node.(P::ChRegex))
    or
    this = TClassChar(node)
  }

  predicate isCharacter() { any() }

  string getValue() {
    result = node.(P::ChRegex).getChar()
    or
    result = node.(P::ClassChar).getChar()
  }
}

class RegExpDot extends NormalRegExpTerm {
  override P::DotRegex node;
}

class RegExpDollar extends NormalRegExpTerm {
  override P::DollarRegex node;
}

class RegExpCaret extends NormalRegExpTerm {
  override P::CaretRegex node;
}

// predicate findIt()
class RegExpCharacterClass extends NormalRegExpTerm {
  override P::ClassRegex node;

  override RegExpTerm getChild(int i) {
    result = classPart(classChildHelper0(node.getLeftNode().getRightNode(), i))
  }

  predicate isInverted() { node.isInverted() }

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
}

private RegExpTerm classPart(P::Node node) {
  result = TClassChar(node) or
  result = TClassRange(node) or
  result = TRegExp(node.(P::EscapeClassRegex))
}

private P::Node classChildHelper0(P::Node node, int i) {
  node.hasId("classstart") and i = 0 and result = node
  or
  node.getId() = "classstartclassinner1" and
  (
    i = 0 and result = node.getLeftNode()
    or
    i > 0 and result = classChildHelper1(node.getRightNode(), i - 1)
  )
}

private P::Node classChildHelper1(P::Node node, int i) {
  node.hasId("classinner2") and result = classChildHelper2(node, i)
  or
  node.getId() = "classinner2-" and
  exists(P::Node left, int num |
    left = node.getLeftNode() and
    num = classInner2NumChild(left) and
    (
      i = num and
      result = node.getRightNode()
      or
      i < num and
      i >= 0 and
      result = classChildHelper2(left, i)
    )
  )
}

private int classInner2NumChild(P::Node node) { result = strictcount(classChildHelper2(node, _)) }

private P::Node classChildHelper2(P::Node node, int i) {
  node.hasId("classpart") and i = 0 and result = node
  or
  node.getId() = "classpartclassinner2" and
  (
    i = 0 and result = node.getLeftNode()
    or
    i > 0 and result = classChildHelper2(node.getRightNode(), i - 1)
  )
}

class RegExpCharacterClassEscape extends NormalRegExpTerm {
  override P::EscapeClassRegex node;

  string getValue() { result = node.getClass() }
}

class RegExpCharacterRange extends RegExpTerm {
  override P::ClassRange node;

  RegExpCharacterRange() { this = TClassRange(node) }

  override RegExpTerm getChild(int i) {
    i = 0 and
    result = TClassChar(node.getLowerBound())
    or
    i = 1 and
    result = TClassChar(node.getUpperBound())
  }

  /** Holds if `lo` is the lower bound of this character range and `hi` the upper bound. */
  predicate isRange(string lo, string hi) {
    lo = getChild(0).(RegExpConstant).getValue() and
    hi = getChild(1).(RegExpConstant).getValue()
  }
}

class RegExpSequence extends NormalRegExpTerm {
  override P::SequenceRegex node;

  override RegExpTerm getChild(int i) {
    i = 0 and
    result = TRegExp(node.getLeft())
    or
    i = 1 and
    result = TRegExp(node.getRight())
  }
}

class RegExpGroup extends NormalRegExpTerm {
  override P::CaptureRegex node;

  override RegExpTerm getChild(int i) {
    i = 0 and
    result = TRegExp(node.getBody())
  }
}

RegExpTerm getParsedRegExp(StrConst re) { result = TRegExpLiteral(re).(RegExpLiteral).getChild(0) }

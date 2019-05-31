/**
 * Provides classes for working with regular expressions.
 *
 * Regular expression literals are represented as an abstract syntax tree of regular expression
 * terms.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes

/**
 * An element containing a regular expression term, that is, either
 * a regular expression literal or another regular expression term.
 */
class RegExpParent extends Locatable, @regexpparent { }

/**
 * A regular expression term, that is, a syntactic part of a regular
 * expression literal.
 */
abstract class RegExpTerm extends Locatable, @regexpterm {
  override Location getLocation() { hasLocation(this, result) }

  /** Gets the `i`th child term of this term. */
  RegExpTerm getChild(int i) { regexpterm(result, _, this, i, _) }

  /** Gets a child term of this term. */
  RegExpTerm getAChild() { result = getChild(_) }

  /** Gets the number of child terms of this term. */
  int getNumChild() { result = count(getAChild()) }

  /**
   * Gets the parent term of this regular expression term, or the
   * regular expression literal if this is the root term.
   */
  RegExpParent getParent() { regexpterm(this, _, result, _, _) }

  /** Gets the regular expression literal this term belongs to. */
  RegExpLiteral getLiteral() { result = getParent+() }

  override string toString() { regexpterm(this, _, _, _, result) }

  /** Holds if this regular expression term can match the empty string. */
  abstract predicate isNullable();

  /** Gets the regular expression term that is matched before this one, if any. */
  RegExpTerm getPredecessor() {
    exists(RegExpSequence seq, int i |
      seq.getChild(i) = this and
      seq.getChild(i - getDirection()) = result
    )
    or
    result = getParent().(RegExpTerm).getPredecessor()
  }

  /** Gets the regular expression term that is matched after this one, if any. */
  RegExpTerm getSuccessor() {
    exists(RegExpSequence seq, int i |
      seq.getChild(i) = this and
      seq.getChild(i + getDirection()) = result
    )
    or
    exists(RegExpTerm parent |
      parent = getParent() and
      not parent instanceof RegExpSubPattern
    |
      result = parent.getSuccessor()
    )
  }

  /**
   * Gets the matching direction of this term: `1` if it is in a forward-matching
   * context, `-1` if it is in a backward-matching context.
   */
  private int getDirection() { if isInBackwardMatchingContext() then result = -1 else result = 1 }

  /**
   * Holds if this regular term is in a forward-matching context, that is,
   * it has no enclosing lookbehind assertions.
   */
  predicate isInForwardMatchingContext() { not isInBackwardMatchingContext() }

  /**
   * Holds if this regular term is in a backward-matching context, that is,
   * it has an enclosing lookbehind assertions.
   */
  predicate isInBackwardMatchingContext() { this = any(RegExpLookbehind lbh).getAChild+() }
}

/** A quantified regular expression term. */
abstract class RegExpQuantifier extends RegExpTerm, @regexp_quantifier {
  /** Holds if the quantifier of this term is a greedy quantifier. */
  predicate isGreedy() { isGreedy(this) }
}

/**
 * An escaped regular expression term, that is, a regular expression
 * term starting with a backslash.
 */
abstract class RegExpEscape extends RegExpTerm, @regexp_escape { }

/**
 * A constant regular expression term, that is, a regular expression
 * term matching a single string.
 */
class RegExpConstant extends RegExpTerm, @regexp_constant {
  /** Gets the string matched by this constant term. */
  string getValue() { regexpConstValue(this, result) }

  /**
   * Holds if this constant represents a valid Unicode character (as opposed
   * to a surrogate code point that does not correspond to a character by itself.)
   */
  predicate isCharacter() { any() }

  override predicate isNullable() { none() }
}

/** A character escape in a regular expression. */
class RegExpCharEscape extends RegExpEscape, RegExpConstant, @regexp_char_escape {
  override predicate isCharacter() {
    not (
      // unencodable characters are represented as '?' in the database
      getValue() = "?" and
      exists(string s | s = toString().toLowerCase() |
        // only Unicode escapes give rise to unencodable characters
        s.matches("\\\\u%") and
        // but '\u003f' actually is the '?' character itself
        s != "\\u003f"
      )
    )
  }
}

/** An alternative term, that is, a term of the form `a|b`. */
class RegExpAlt extends RegExpTerm, @regexp_alt {
  /** Gets an alternative of this term. */
  RegExpTerm getAlternative() { result = getAChild() }

  /** Gets the number of alternatives of this term. */
  int getNumAlternative() { result = getNumChild() }

  override predicate isNullable() { getAlternative().isNullable() }
}

/** A sequence term, that is, a term of the form `ab`. */
class RegExpSequence extends RegExpTerm, @regexp_seq {
  /** Gets an element of this sequence. */
  RegExpTerm getElement() { result = getAChild() }

  /** Gets the number of elements in this sequence. */
  int getNumElement() { result = getNumChild() }

  override predicate isNullable() {
    forall(RegExpTerm child | child = getAChild() | child.isNullable())
  }
}

/** A caret assertion `^` matching the beginning of a line. */
class RegExpCaret extends RegExpTerm, @regexp_caret {
  override predicate isNullable() { any() }
}

/** A dollar assertion `$` matching the end of a line. */
class RegExpDollar extends RegExpTerm, @regexp_dollar {
  override predicate isNullable() { any() }
}

/** A word boundary assertion `\b`. */
class RegExpWordBoundary extends RegExpTerm, @regexp_wordboundary {
  override predicate isNullable() { any() }
}

/** A non-word boundary assertion `\B`. */
class RegExpNonWordBoundary extends RegExpTerm, @regexp_nonwordboundary {
  override predicate isNullable() { any() }
}

/** A zero-width lookahead or lookbehind assertion. */
class RegExpSubPattern extends RegExpTerm, @regexp_subpattern {
  /** Gets the lookahead term. */
  RegExpTerm getOperand() { result = getAChild() }

  override predicate isNullable() { any() }
}

/** A zero-width lookahead assertion. */
class RegExpLookahead extends RegExpSubPattern, @regexp_lookahead { }

/** A zero-width lookbehind assertion. */
class RegExpLookbehind extends RegExpSubPattern, @regexp_lookbehind { }

/** A positive-lookahead assertion, that is, a term of the form `(?=...)`. */
class RegExpPositiveLookahead extends RegExpLookahead, @regexp_positive_lookahead { }

/** A negative-lookahead assertion, that is, a term of the form `(?!...)`. */
class RegExpNegativeLookahead extends RegExpLookahead, @regexp_negative_lookahead { }

/** A positive-lookbehind assertion, that is, a term of the form `(?<=...)`. */
class RegExpPositiveLookbehind extends RegExpLookbehind, @regexp_positive_lookbehind { }

/** A negative-lookbehind assertion, that is, a term of the form `(?<!...)`. */
class RegExpNegativeLookbehind extends RegExpLookbehind, @regexp_negative_lookbehind { }

/** A star-quantified term, that is, a term of the form `...*`. */
class RegExpStar extends RegExpQuantifier, @regexp_star {
  override predicate isNullable() { any() }
}

/** A plus-quantified term, that is, a term of the form `...+`. */
class RegExpPlus extends RegExpQuantifier, @regexp_plus {
  override predicate isNullable() { getAChild().isNullable() }
}

/** An optional term, that is, a term of the form `...?`. */
class RegExpOpt extends RegExpQuantifier, @regexp_opt {
  override predicate isNullable() { any() }
}

/** A range-quantified term, that is, a term of the form `...{m,n}`. */
class RegExpRange extends RegExpQuantifier, @regexp_range {
  /** Gets the lower bound of the range, if any. */
  int getLowerBound() { rangeQuantifierLowerBound(this, result) }

  /** Gets the upper bound of the range, if any. */
  int getUpperBound() { rangeQuantifierUpperBound(this, result) }

  override predicate isNullable() {
    getAChild().isNullable() or
    getLowerBound() = 0
  }
}

/** A dot regular expression `.`. */
class RegExpDot extends RegExpTerm, @regexp_dot {
  override predicate isNullable() { none() }
}

/** A grouped regular expression, that is, a term of the form `(...)` or `(?:...)` */
class RegExpGroup extends RegExpTerm, @regexp_group {
  /** Holds if this is a capture group. */
  predicate isCapture() { isCapture(this, _) }

  /**
   * Gets the index of this capture group within the enclosing regular
   * expression literal.
   *
   * For example, in the regular expression `/((a?).)(?:b)/`, the
   * group `((a?).)` has index 1, the group `(a?)` nested inside it
   * has index 2, and the group `(?:b)` has no index, since it is
   * not a capture group.
   */
  int getNumber() { isCapture(this, result) }

  /** Holds if this is a named capture group. */
  predicate isNamed() { isNamedCapture(this, _) }

  /** Gets the name of this capture group, if any. */
  string getName() { isNamedCapture(this, result) }

  override predicate isNullable() { getAChild().isNullable() }
}

/** A normal character without special meaning in a regular expression. */
class RegExpNormalChar extends RegExpConstant, @regexp_normal_char { }

/** A hexadecimal character escape such as `\x0a` in a regular expression. */
class RegExpHexEscape extends RegExpCharEscape, @regexp_hex_escape { }

/** A unicode character escape such as `\u000a` in a regular expression. */
class RegExpUnicodeEscape extends RegExpCharEscape, @regexp_unicode_escape { }

/** A decimal character escape such as `\0` in a regular expression. */
class RegExpDecimalEscape extends RegExpCharEscape, @regexp_dec_escape { }

/** An octal character escape such as `\0177` in a regular expression. */
class RegExpOctalEscape extends RegExpCharEscape, @regexp_oct_escape { }

/** A control character escape such as `\ca` in a regular expression. */
class RegExpControlEscape extends RegExpCharEscape, @regexp_ctrl_escape { }

/** A character class escape such as `\w` or `\S` in a regular expression. */
class RegExpCharacterClassEscape extends RegExpEscape, @regexp_char_class_escape {
  /** Gets the name of the character class; for example, `w` for `\w`. */
  string getValue() { charClassEscape(this, result) }

  override predicate isNullable() { none() }
}

/** A Unicode property escape such as `\p{Number}` or `\p{Script=Greek}`. */
class RegExpUnicodePropertyEscape extends RegExpEscape, @regexp_unicode_property_escape {
  /**
   * Gets the name of this Unicode property; for example, `Number` for `\p{Number}` and
   * `Script` for `\p{Script=Greek}`.
   */
  string getName() { unicodePropertyEscapeName(this, result) }

  /**
   * Gets the value of this Unicode property, if any.
   *
   * For example, the value of Unicode property `\p{Script=Greek}` is `Greek`, while
   * `\p{Number}` does not have a value.
   */
  string getValue() { unicodePropertyEscapeValue(this, result) }

  override predicate isNullable() { none() }
}

/** An identity escape such as `\\` or `\/` in a regular expression. */
class RegExpIdentityEscape extends RegExpCharEscape, @regexp_id_escape { }

/**
 * A back reference, that is, a term of the form `\i` or `\k<name>`
 * in a regular expression.
 */
class RegExpBackRef extends RegExpTerm, @regexp_backref {
  /**
   * Gets the number of the capture group this back reference refers to, if any.
   */
  int getNumber() { backref(this, result) }

  /**
   * Gets the name of the capture group this back reference refers to, if any.
   */
  string getName() { namedBackref(this, result) }

  /** Gets the capture group this back reference refers to. */
  RegExpGroup getGroup() {
    result.getLiteral() = this.getLiteral() and
    (
      result.getNumber() = this.getNumber() or
      result.getName() = this.getName()
    )
  }

  override predicate isNullable() { getGroup().isNullable() }
}

/** A character class, that is, a term of the form `[...]`. */
class RegExpCharacterClass extends RegExpTerm, @regexp_char_class {
  /** Holds if this is an inverted character class, that is, a term of the form `[^...]`. */
  predicate isInverted() { isInverted(this) }

  override predicate isNullable() { none() }
}

/** A character range in a character class in a regular expression. */
class RegExpCharacterRange extends RegExpTerm, @regexp_char_range {
  override predicate isNullable() { none() }

  /** Holds if `lo` is the lower bound of this character range and `hi` the upper bound. */
  predicate isRange(string lo, string hi) {
    lo = getChild(0).(RegExpConstant).getValue() and
    hi = getChild(1).(RegExpConstant).getValue()
  }
}

/** A parse error encountered while processing a regular expression literal. */
class RegExpParseError extends Error, @regexp_parse_error {
  /** Gets the regular expression term that triggered the parse error. */
  RegExpTerm getTerm() { regexpParseErrors(this, result, _) }

  /** Gets the regular expression literal in which the parse error occurred. */
  RegExpLiteral getLiteral() { result = getTerm().getLiteral() }

  override string getMessage() { regexpParseErrors(this, _, result) }

  override string toString() { result = getMessage() }
}

/**
 * Holds if `source` may be interpreted as a regular expression.
 */
predicate isInterpretedAsRegExp(DataFlow::Node source) {
  // The first argument to an invocation of `RegExp` (with or without `new`).
  source = DataFlow::globalVarRef("RegExp").getAnInvocation().getArgument(0)
  or
  // The argument of a call that coerces the argument to a regular expression.
  exists(MethodCallExpr mce, string methodName |
    mce.getReceiver().analyze().getAType() = TTString() and
    mce.getMethodName() = methodName
  |
    methodName = "match" and source.asExpr() = mce.getArgument(0) and mce.getNumArgument() = 1
    or
    methodName = "search" and
    source.asExpr() = mce.getArgument(0) and
    mce.getNumArgument() = 1 and
    // "search" is a common method name, and so we exclude chained accesses
    // because `String.prototype.search` returns a number
    not exists(PropAccess p | p.getBase() = mce)
  )
}

/**
 * Provides regular expression patterns.
 */
module RegExpPatterns {
  /**
   * Gets a pattern that matches common top-level domain names in lower case.
   */
  string commonTLD() {
    // according to ranking by http://google.com/search?q=site:.<<TLD>>
    result = "(?:com|org|edu|gov|uk|net|io)(?![a-z0-9])"
  }
}

/**
 * Gets a node whose value may flow (inter-procedurally) to a position where it is interpreted
 * as a part of a regular expression.
 */
private DataFlow::Node regExpSource(DataFlow::Node re, DataFlow::TypeBackTracker t) {
  t.start() and
  re = result and
  isInterpretedAsRegExp(result)
  or
  exists(DataFlow::TypeBackTracker t2, DataFlow::Node succ | succ = regExpSource(re, t2) |
    t2 = t.smallstep(result, succ)
    or
    any(TaintTracking::AdditionalTaintStep dts).step(result, succ) and
    t = t2
  )
}

/**
 * Gets a node whose value may flow (inter-procedurally) to a position where it is interpreted
 * as a part of a regular expression.
 */
private DataFlow::Node regExpSource(DataFlow::Node re) {
  result = regExpSource(re, DataFlow::TypeBackTracker::end())
}

/**
 * A node whose value may flow to a position where it is interpreted
 * as a part of a regular expression.
 */
abstract class RegExpPatternSource extends DataFlow::Node {
  /**
   * Gets the pattern of this node.
   */
  abstract string getPattern();

  /**
   * Gets a regular expression object that is built from the value of this node.
   */
  abstract DataFlow::SourceNode getARegExpObject();
}

/**
 * A regular expression literal, viewed as the pattern source for itself.
 */
class RegExpLiteralPatternSource extends RegExpPatternSource {
  string pattern;

  RegExpLiteralPatternSource() {
    exists(string raw | raw = asExpr().(RegExpLiteral).getRoot().toString() |
      // hide the fact that `/` is escaped in the literal
      pattern = raw.regexpReplaceAll("\\\\/", "/")
    )
  }

  override string getPattern() { result = pattern }

  override DataFlow::SourceNode getARegExpObject() { result = this }
}

/**
 * A node whose string value may flow to a position where it is interpreted
 * as a part of a regular expression.
 */
class StringRegExpPatternSource extends RegExpPatternSource {
  DataFlow::Node use;

  StringRegExpPatternSource() { this = regExpSource(use) }

  /**
   * Gets a node that use this source as a regular expression pattern.
   */
  DataFlow::Node getAUse() { result = use }

  override DataFlow::SourceNode getARegExpObject() {
    exists(DataFlow::InvokeNode constructor |
      constructor = DataFlow::globalVarRef("RegExp").getAnInvocation() and
      use = constructor.getArgument(0) and
      result = constructor
    )
  }

  override string getPattern() { result = getStringValue() }
}

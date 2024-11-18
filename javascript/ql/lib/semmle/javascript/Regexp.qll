/**
 * Provides classes for working with regular expressions.
 *
 * Regular expression literals are represented as an abstract syntax tree of regular expression
 * terms.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes
private import semmle.javascript.internal.CachedStages

/**
 * An element containing a regular expression term, that is, either
 * a regular expression literal, a string literal (parsed as a regular expression),
 * or another regular expression term.
 *
 * Examples:
 *
 * ```
 * // the regular expression literal and all terms it contains are regexp parents
 * /((ECMA|Java)[sS]cript)*$/
 * ```
 */
class RegExpParent extends Locatable, @regexpparent { }

/**
 * A regular expression term, that is, a syntactic part of a regular expression.
 *
 * Regular expression terms may occur as part of a regular expression literal,
 * such as `/[a-z]+/`, or as part of a string literal, such as `"[a-z]+"`.
 *
 * Note that some terms will occur as part of a string literal that isn't actually
 * interpreted as regular expression at runtime. Use `isPartOfRegExpLiteral`
 * or `isUsedAsRegExp` to check if a term is really used as a regular expression.
 *
 * Examples:
 *
 * ```
 * ((ECMA|Java)[sS]cript)*$
 * ((ECMA|Java)[sS]cript)*
 * (ECMA|Java)
 * $
 * ```
 */
class RegExpTerm extends Locatable, @regexpterm {
  /** Gets the `i`th child term of this term. */
  RegExpTerm getChild(int i) { regexpterm(result, _, this, i, _) }

  /** Gets a child term of this term. */
  RegExpTerm getAChild() { result = this.getChild(_) }

  /** Gets the number of child terms of this term. */
  int getNumChild() { result = count(this.getAChild()) }

  /** Gets the last child term of this term. */
  RegExpTerm getLastChild() { result = this.getChild(this.getNumChild() - 1) }

  /**
   * Gets the parent term of this regular expression term, or the
   * regular expression literal if this is the root term.
   */
  RegExpParent getParent() { regexpterm(this, _, result, _, _) }

  /** Gets the regular expression literal this term belongs to, if any. */
  RegExpLiteral getLiteral() { result = this.getRootTerm().getParent() }

  override string toString() { regexpterm(this, _, _, _, result) }

  /** Gets the raw source text of this term. */
  string getRawValue() { regexpterm(this, _, _, _, result) }

  /** Holds if this regular expression term can match the empty string. */
  predicate isNullable() { none() } // Overridden in subclasses.

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
   * Holds if this regular term is in a forward-matching context, that is,
   * it has no enclosing lookbehind assertions.
   */
  predicate isInForwardMatchingContext() { not this.isInBackwardMatchingContext() }

  /**
   * Holds if this regular term is in a backward-matching context, that is,
   * it has an enclosing lookbehind assertions.
   */
  predicate isInBackwardMatchingContext() { this = any(RegExpLookbehind lbh).getAChild+() }

  /**
   * Holds if this is the root term of a regular expression.
   */
  predicate isRootTerm() { not this.getParent() instanceof RegExpTerm }

  /**
   * Gets the outermost term of this regular expression.
   */
  RegExpTerm getRootTerm() {
    this.isRootTerm() and
    result = this
    or
    result = this.getParent().(RegExpTerm).getRootTerm()
  }

  /**
   * Holds if this term occurs as part of a regular expression literal.
   */
  predicate isPartOfRegExpLiteral() { exists(this.getLiteral()) }

  /**
   * Holds if this term occurs as part of a string literal.
   *
   * This predicate holds regardless of whether the string literal is actually
   * used as a regular expression. See `isUsedAsRegExp`.
   */
  predicate isPartOfStringLiteral() { this.getRootTerm().getParent() instanceof StringLiteral }

  /**
   * Holds if this term is part of a regular expression literal, or a string literal
   * that is interpreted as a regular expression.
   *
   * Unlike `isPartOfRegExpLiteral` and `isPartOfStringLiteral`, this predicate takes
   * data flow into account, to exclude string literals that aren't used as regular expressions.
   *
   * For example:
   * ```js
   * location.href.match("^https://example\\.com/") // YES - String is used as regexpp
   *
   * console.log("Hello world"); // NO - string is not used as regexp
   *
   * /[a-z]+/g; // YES - Regexp literals are always used as regexp
   * ```
   */
  predicate isUsedAsRegExp() {
    exists(RegExpParent parent | parent = this.getRootTerm().getParent() |
      parent instanceof RegExpLiteral
      or
      parent.(Expr).flow() instanceof RegExpPatternSource
    )
  }

  /**
   * Gets the single string this regular-expression term matches.
   *
   * This predicate is only defined for (sequences/groups of) constant regular expressions.
   * In particular, terms involving zero-width assertions like `^` or `\b` are not considered
   * to have a constant value.
   *
   * Note that this predicate does not take flags of the enclosing regular-expression literal
   * into account.
   */
  string getConstantValue() { none() }

  /**
   * Gets a string that is matched by this regular-expression term.
   */
  string getAMatchedString() { result = this.getConstantValue() }

  /** Holds if this term has the specified location. */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
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
class RegExpQuantifier extends RegExpTerm, @regexp_quantifier {
  /** Holds if the quantifier of this term is a greedy quantifier. */
  predicate isGreedy() { is_greedy(this) }
}

/**
 * A regular expression term that permits unlimited repetitions.
 */
class InfiniteRepetitionQuantifier extends RegExpQuantifier {
  InfiniteRepetitionQuantifier() {
    this instanceof RegExpPlus
    or
    this instanceof RegExpStar
    or
    this instanceof RegExpRange and not exists(this.(RegExpRange).getUpperBound())
  }
}

/**
 * An escaped regular expression term, that is, a regular expression
 * term starting with a backslash.
 *
 * Example:
 *
 * ```
 * \.
 * \w
 * ```
 */
class RegExpEscape extends RegExpTerm, @regexp_escape {
  override string getAPrimaryQlClass() { result = "RegExpEscape" }
}

/**
 * A constant regular expression term, that is, a regular expression
 * term matching a single string.
 *
 * Example:
 *
 * ```
 * abc
 * ```
 */
class RegExpConstant extends RegExpTerm, @regexp_constant {
  /** Gets the string matched by this constant term. */
  string getValue() { regexp_const_value(this, result) }

  /**
   * Holds if this constant represents a valid Unicode character (as opposed
   * to a surrogate code point that does not correspond to a character by itself.)
   */
  predicate isCharacter() { any() }

  override predicate isNullable() { none() }

  override string getConstantValue() { result = this.getValue() }

  override string getAPrimaryQlClass() { result = "RegExpConstant" }
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
class RegExpCharEscape extends RegExpEscape, RegExpConstant, @regexp_char_escape {
  override predicate isCharacter() {
    not (
      // unencodable characters are represented as '?' or \uFFFD in the database
      this.getValue() = ["?", 65533.toUnicode()] and
      exists(string s | s = this.toString().toLowerCase() |
        // only Unicode escapes give rise to unencodable characters
        s.matches("\\\\u%") and
        // but '\u003f' actually is the '?' character itself
        s != "\\u003f"
      )
    )
  }

  override string getAPrimaryQlClass() { result = "RegExpCharEscape" }
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
class RegExpAlt extends RegExpTerm, @regexp_alt {
  /** Gets an alternative of this term. */
  RegExpTerm getAlternative() { result = this.getAChild() }

  /** Gets the number of alternatives of this term. */
  int getNumAlternative() { result = this.getNumChild() }

  override predicate isNullable() { this.getAlternative().isNullable() }

  override string getAMatchedString() { result = this.getAlternative().getAMatchedString() }

  override string getAPrimaryQlClass() { result = "RegExpAlt" }
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
class RegExpSequence extends RegExpTerm, @regexp_seq {
  /** Gets an element of this sequence. */
  RegExpTerm getElement() { result = this.getAChild() }

  /** Gets the number of elements in this sequence. */
  int getNumElement() { result = this.getNumChild() }

  override predicate isNullable() {
    forall(RegExpTerm child | child = this.getAChild() | child.isNullable())
  }

  override string getConstantValue() { result = this.getConstantValue(0) }

  /**
   * Gets the single string matched by the `i`th child and all following children of
   * this sequence, if any.
   */
  private string getConstantValue(int i) {
    i = this.getNumChild() and
    result = ""
    or
    result = this.getChild(i).getConstantValue() + this.getConstantValue(i + 1)
  }

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

/**
 * A dollar `$` or caret assertion `^` matching the beginning or end of a line.
 *
 * Example:
 *
 * ```
 * ^
 * $
 * ```
 */
class RegExpAnchor extends RegExpTerm, @regexp_anchor {
  override predicate isNullable() { any() }

  override string getAPrimaryQlClass() { result = "RegExpAnchor" }

  /** Gets the char for this term. */
  abstract string getChar();
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
class RegExpCaret extends RegExpAnchor, @regexp_caret {
  override string getAPrimaryQlClass() { result = "RegExpCaret" }

  override string getChar() { result = "^" }
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
class RegExpDollar extends RegExpAnchor, @regexp_dollar {
  override string getAPrimaryQlClass() { result = "RegExpDollar" }

  override string getChar() { result = "$" }
}

/**
 * A word boundary assertion.
 *
 * Example:
 *
 * ```
 * \b
 * ```
 */
class RegExpWordBoundary extends RegExpTerm, @regexp_wordboundary {
  override predicate isNullable() { any() }

  override string getAPrimaryQlClass() { result = "RegExpWordBoundary" }
}

/**
 * A non-word boundary assertion.
 *
 * Example:
 *
 * ```
 * \B
 * ```
 */
class RegExpNonWordBoundary extends RegExpTerm, @regexp_nonwordboundary {
  override predicate isNullable() { any() }

  override string getAPrimaryQlClass() { result = "RegExpNonWordBoundary" }
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
class RegExpSubPattern extends RegExpTerm, @regexp_subpattern {
  /** Gets the lookahead term. */
  RegExpTerm getOperand() { result = this.getAChild() }

  override predicate isNullable() { any() }
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
class RegExpLookahead extends RegExpSubPattern, @regexp_lookahead {
  override string getAPrimaryQlClass() { result = "RegExpLookahead" }
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
class RegExpLookbehind extends RegExpSubPattern, @regexp_lookbehind {
  override string getAPrimaryQlClass() { result = "RegExpLookbehind" }
}

/**
 * A positive-lookahead assertion.
 *
 * Examples:
 *
 * ```
 * (?=\w)
 * ```
 */
class RegExpPositiveLookahead extends RegExpLookahead, @regexp_positive_lookahead {
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
class RegExpNegativeLookahead extends RegExpLookahead, @regexp_negative_lookahead {
  override string getAPrimaryQlClass() { result = "RegExpNegativeLookahead" }
}

/**
 * A positive-lookbehind assertion.
 *
 * Examples:
 *
 * ```
 * (?<=\.)
 * ```
 */
class RegExpPositiveLookbehind extends RegExpLookbehind, @regexp_positive_lookbehind {
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
class RegExpNegativeLookbehind extends RegExpLookbehind, @regexp_negative_lookbehind {
  override string getAPrimaryQlClass() { result = "RegExpNegativeLookbehind" }
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
class RegExpStar extends RegExpQuantifier, @regexp_star {
  override predicate isNullable() { any() }

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
class RegExpPlus extends RegExpQuantifier, @regexp_plus {
  override predicate isNullable() { this.getAChild().isNullable() }

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
class RegExpOpt extends RegExpQuantifier, @regexp_opt {
  override predicate isNullable() { any() }

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
class RegExpRange extends RegExpQuantifier, @regexp_range {
  /** Gets the lower bound of the range. */
  int getLowerBound() { range_quantifier_lower_bound(this, result) }

  /**
   * Gets the upper bound of the range, if any.
   *
   * If there is no upper bound, any number of repetitions is allowed.
   * For a term of the form `r{lo}`, both the lower and the upper bound
   * are `lo`.
   */
  int getUpperBound() { range_quantifier_upper_bound(this, result) }

  override predicate isNullable() {
    this.getAChild().isNullable() or
    this.getLowerBound() = 0
  }

  override string getAPrimaryQlClass() { result = "RegExpRange" }
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
class RegExpDot extends RegExpTerm, @regexp_dot {
  override predicate isNullable() { none() }

  override string getAPrimaryQlClass() { result = "RegExpDot" }
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
class RegExpGroup extends RegExpTerm, @regexp_group {
  /** Holds if this is a capture group. */
  predicate isCapture() { is_capture(this, _) }

  /**
   * Gets the index of this capture group within the enclosing regular
   * expression literal.
   *
   * For example, in the regular expression `/((a?).)(?:b)/`, the
   * group `((a?).)` has index 1, the group `(a?)` nested inside it
   * has index 2, and the group `(?:b)` has no index, since it is
   * not a capture group.
   */
  int getNumber() { is_capture(this, result) }

  /** Holds if this is a named capture group. */
  predicate isNamed() { is_named_capture(this, _) }

  /** Gets the name of this capture group, if any. */
  string getName() { is_named_capture(this, result) }

  override predicate isNullable() { this.getAChild().isNullable() }

  override string getConstantValue() { result = this.getAChild().getConstantValue() }

  override string getAMatchedString() { result = this.getAChild().getAMatchedString() }

  override string getAPrimaryQlClass() { result = "RegExpGroup" }
}

/**
 * A sequence of normal characters without special meaning in a regular expression.
 *
 * Example:
 *
 * ```
 * abc
 * ;
 * ```
 */
class RegExpNormalConstant extends RegExpConstant, @regexp_normal_constant {
  override string getAPrimaryQlClass() { result = "RegExpNormalConstant" }
}

/**
 * A hexadecimal character escape in a regular expression.
 *
 * Example:
 *
 * ```
 * \x0a
 * ```
 */
class RegExpHexEscape extends RegExpCharEscape, @regexp_hex_escape {
  override string getAPrimaryQlClass() { result = "RegExpHexEscape" }
}

/**
 * A unicode character escape in a regular expression.
 *
 * Example:
 *
 * ```
 * \u000a
 * ```
 */
class RegExpUnicodeEscape extends RegExpCharEscape, @regexp_unicode_escape {
  override string getAPrimaryQlClass() { result = "RegExpUnicodeEscape" }
}

/**
 * A decimal character escape in a regular expression.
 *
 * Example:
 *
 * ```
 * \0
 * ```
 */
class RegExpDecimalEscape extends RegExpCharEscape, @regexp_dec_escape {
  override string getAPrimaryQlClass() { result = "RegExpDecimalEscape" }
}

/**
 * An octal character escape in a regular expression.
 *
 * Example:
 *
 * ```
 * \0177
 * ```
 */
class RegExpOctalEscape extends RegExpCharEscape, @regexp_oct_escape {
  override string getAPrimaryQlClass() { result = "RegExpOctalEscape" }
}

/**
 * A control character escape in a regular expression.
 *
 * Example:
 *
 * ```
 * \ca
 * ```
 */
class RegExpControlEscape extends RegExpCharEscape, @regexp_ctrl_escape {
  override string getAPrimaryQlClass() { result = "RegExpControlEscape" }
}

/**
 * A character class escape in a regular expression.
 *
 * Examples:
 *
 * ```
 * \w
 * \S
 * ```
 */
class RegExpCharacterClassEscape extends RegExpEscape, @regexp_char_class_escape {
  /** Gets the name of the character class; for example, `w` for `\w`. */
  string getValue() { char_class_escape(this, result) }

  override predicate isNullable() { none() }

  override string getAPrimaryQlClass() { result = "RegExpCharacterClassEscape" }
}

/**
 * A Unicode property escape in a regular expression.
 *
 * Examples:
 *
 * ```
 * \p{Number}
 * \p{Script=Greek}
 * ```
 */
class RegExpUnicodePropertyEscape extends RegExpEscape, @regexp_unicode_property_escape {
  /**
   * Gets the name of this Unicode property; for example, `Number` for `\p{Number}` and
   * `Script` for `\p{Script=Greek}`.
   */
  string getName() { unicode_property_escapename(this, result) }

  /**
   * Gets the value of this Unicode property, if any.
   *
   * For example, the value of Unicode property `\p{Script=Greek}` is `Greek`, while
   * `\p{Number}` does not have a value.
   */
  string getValue() { unicode_property_escapevalue(this, result) }

  override predicate isNullable() { none() }

  override string getAPrimaryQlClass() { result = "RegExpUnicodePropertyEscape" }
}

/**
 * An identity escape, that is, an escaped character in a regular expression that just
 * represents itself.
 *
 * Examples:
 *
 * ```
 * \\
 * \/
 * ```
 */
class RegExpIdentityEscape extends RegExpCharEscape, @regexp_id_escape {
  override string getAPrimaryQlClass() { result = "RegExpIdentityEscape" }
}

/**
 * A back reference, that is, a term of the form `\i` or `\k<name>`
 * in a regular expression.
 *
 * Examples:
 *
 * ```
 * \1
 * \k<quote>
 * ```
 */
class RegExpBackRef extends RegExpTerm, @regexp_backref {
  /**
   * Gets the number of the capture group this back reference refers to, if any.
   */
  int getNumber() { backref(this, result) }

  /**
   * Gets the name of the capture group this back reference refers to, if any.
   */
  string getName() { named_backref(this, result) }

  /** Gets the capture group this back reference refers to. */
  RegExpGroup getGroup() {
    result.getLiteral() = this.getLiteral() and
    (
      result.getNumber() = this.getNumber() or
      result.getName() = this.getName()
    )
  }

  override predicate isNullable() { this.getGroup().isNullable() }

  override string getAPrimaryQlClass() { result = "RegExpBackRef" }
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
class RegExpCharacterClass extends RegExpTerm, @regexp_char_class {
  /** Holds if this is an inverted character class, that is, a term of the form `[^...]`. */
  predicate isInverted() { is_inverted(this) }

  override predicate isNullable() { none() }

  override string getAMatchedString() {
    not this.isInverted() and result = this.getAChild().getAMatchedString()
  }

  /**
   * Holds if this character class matches any character.
   */
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
class RegExpCharacterRange extends RegExpTerm, @regexp_char_range {
  override predicate isNullable() { none() }

  /** Holds if `lo` is the lower bound of this character range and `hi` the upper bound. */
  predicate isRange(string lo, string hi) {
    lo = this.getChild(0).(RegExpConstant).getValue() and
    hi = this.getChild(1).(RegExpConstant).getValue()
  }

  override string getAPrimaryQlClass() { result = "RegExpCharacterRange" }
}

/** A parse error encountered while processing a regular expression literal. */
class RegExpParseError extends Error, @regexp_parse_error {
  /** Gets the regular expression term that triggered the parse error. */
  RegExpTerm getTerm() { regexp_parse_errors(this, result, _) }

  /** Gets the regular expression literal in which the parse error occurred. */
  RegExpLiteral getLiteral() { result = this.getTerm().getLiteral() }

  override string getMessage() { regexp_parse_errors(this, _, result) }

  override string toString() { result = this.getMessage() }

  override predicate isFatal() { none() }
}

/**
 * Holds if `func` is a method defined on `String.prototype` with name `name`.
 */
private predicate isNativeStringMethod(Function func, string name) {
  exists(ExternalInstanceMemberDecl decl |
    decl.hasQualifiedName("String", name) and
    func = decl.getInit()
  )
}

/**
 * Holds if `name` is the name of a property on a Match object returned by `String.prototype.match`,
 * not including array indices.
 */
private predicate isMatchObjectProperty(string name) {
  any(ExternalInstanceMemberDecl decl).hasQualifiedName("Array", name)
  or
  name in ["length", "index", "input", "groups"]
}

/** Holds if `call` is a call to `match` whose result is used in a way that is incompatible with Match objects. */
private predicate isUsedAsNonMatchObject(DataFlow::MethodCallNode call) {
  call.getMethodName() = ["match", "matchAll"] and
  call.getNumArgument() = 1 and
  (
    // Accessing a property that is absent on Match objects
    exists(string propName |
      exists(call.getAPropertyRead(propName)) and
      not isMatchObjectProperty(propName) and
      not exists(propName.toInt())
    )
    or
    // Awaiting the result
    call.flowsToExpr(any(AwaitExpr await).getOperand())
    or
    // Result is obviously unused
    call.asExpr() = any(ExprStmt stmt).getExpr()
  )
}

/**
 * Holds if `value` is used in a way that suggests it returns a number.
 */
pragma[inline]
private predicate isUsedAsNumber(DataFlow::LocalSourceNode value) {
  any(Comparison compare)
      .hasOperands(value.getALocalUse().asExpr(), any(Expr e | e.analyze().getAType() = TTNumber()))
  or
  value.flowsToExpr(any(ArithmeticExpr e).getAnOperand())
  or
  value.flowsToExpr(any(UnaryExpr e | e.getOperator() = "-").getOperand())
  or
  value.flowsToExpr(any(IndexExpr expr).getPropertyNameExpr())
  or
  exists(DataFlow::CallNode call |
    call.getCalleeName() =
      ["substring", "substr", "slice", "splice", "charAt", "charCodeAt", "codePointAt", "toSpliced"] and
    value.flowsTo(call.getAnArgument())
  )
}

/**
 * Holds if `source` may be interpreted as a regular expression.
 */
cached
predicate isInterpretedAsRegExp(DataFlow::Node source) {
  Stages::Taint::ref() and
  source.analyze().getAType() = TTString() and
  (
    // The first argument to an invocation of `RegExp` (with or without `new`).
    source = DataFlow::globalVarRef("RegExp").getAnInvocation().getArgument(0)
    or
    // The argument of a call that coerces the argument to a regular expression.
    exists(DataFlow::MethodCallNode mce, string methodName |
      mce.getReceiver().analyze().getAType() = TTString() and
      mce.getMethodName() = methodName and
      not exists(Function func | func = mce.getACallee() |
        not isNativeStringMethod(func, methodName)
      )
    |
      methodName = ["match", "matchAll"] and
      source = mce.getArgument(0) and
      mce.getNumArgument() = 1 and
      not isUsedAsNonMatchObject(mce)
      or
      methodName = "search" and
      source = mce.getArgument(0) and
      mce.getNumArgument() = 1 and
      // "search" is a common method name, and the built-in "search" method is rarely used,
      // so to reduce FPs we also require that the return value appears to be used as a number.
      isUsedAsNumber(mce)
    )
    or
    exists(DataFlow::SourceNode schema | schema = JsonSchema::getAPartOfJsonSchema() |
      source = schema.getAPropertyWrite("pattern").getRhs()
      or
      source =
        schema
            .getAPropertySource("patternProperties")
            .getAPropertyWrite()
            .getPropertyNameExpr()
            .flow()
    )
  )
}

/**
 * Gets a node whose value may flow (inter-procedurally) to `re`, where it is interpreted
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
    TaintTracking::sharedTaintStep(result, succ) and
    t = t2
  )
}

/**
 * Gets a node whose value may flow (inter-procedurally) to `re`, where it is interpreted
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
   * Gets a node where the pattern of this node is parsed as a part of
   * a regular expression.
   */
  abstract DataFlow::Node getAParse();

  /**
   * Gets the pattern of this node that is interpreted as a part of a
   * regular expression.
   */
  abstract string getPattern();

  /**
   * Gets a regular expression object that is constructed from the pattern
   * of this node.
   */
  abstract DataFlow::SourceNode getARegExpObject();

  /**
   * Gets the root term of the regular expression parsed from this pattern.
   */
  abstract RegExpTerm getRegExpTerm();
}

/**
 * A regular expression literal, viewed as the pattern source for itself.
 */
private class RegExpLiteralPatternSource extends RegExpPatternSource, DataFlow::ValueNode {
  override RegExpLiteral astNode;

  override DataFlow::Node getAParse() { result = this }

  override string getPattern() {
    // hide the fact that `/` is escaped in the literal
    result = astNode.getRoot().getRawValue().regexpReplaceAll("\\\\/", "/")
  }

  override DataFlow::SourceNode getARegExpObject() { result = this }

  override RegExpTerm getRegExpTerm() { result = astNode.getRoot() }
}

/**
 * A node whose string value may flow to a position where it is interpreted
 * as a part of a regular expression.
 */
private class StringRegExpPatternSource extends RegExpPatternSource {
  DataFlow::Node parse;

  StringRegExpPatternSource() { this = regExpSource(parse) }

  override DataFlow::Node getAParse() { result = parse }

  override DataFlow::SourceNode getARegExpObject() {
    exists(DataFlow::InvokeNode constructor |
      constructor = DataFlow::globalVarRef("RegExp").getAnInvocation() and
      parse = constructor.getArgument(0) and
      result = constructor
    )
  }

  override string getPattern() { result = this.getStringValue() }

  override RegExpTerm getRegExpTerm() { result = this.asExpr().(StringLiteral).asRegExp() }
}

/**
 * A node whose string value may flow to a position where it is interpreted
 * as a part of a regular expression.
 */
private class StringConcatRegExpPatternSource extends RegExpPatternSource {
  DataFlow::Node parse;

  StringConcatRegExpPatternSource() { this = regExpSource(parse) }

  override DataFlow::Node getAParse() { result = parse }

  override DataFlow::SourceNode getARegExpObject() {
    exists(DataFlow::InvokeNode constructor |
      constructor = DataFlow::globalVarRef("RegExp").getAnInvocation() and
      parse = constructor.getArgument(0) and
      result = constructor
    )
  }

  override string getPattern() { result = this.getStringValue() }

  override RegExpTerm getRegExpTerm() { result = this.asExpr().(AddExpr).asRegExp() }
}

module RegExp {
  /** Gets the string `"?"` used to represent a regular expression whose flags are unknown. */
  string unknownFlag() { result = "?" }

  /** Holds if `flags` includes the `m` flag. */
  bindingset[flags]
  predicate isMultiline(string flags) { flags.matches("%m%") }

  /** Holds if `flags` includes the `g` flag. */
  bindingset[flags]
  predicate isGlobal(string flags) { flags.matches("%g%") }

  /** Holds if `flags` includes the `i` flag. */
  bindingset[flags]
  predicate isIgnoreCase(string flags) { flags.matches("%i%") }

  /** Holds if `flags` includes the `s` flag. */
  bindingset[flags]
  predicate isDotAll(string flags) { flags.matches("%s%") }

  /** Holds if `flags` includes the `m` flag or is the unknown flag `?`. */
  bindingset[flags]
  predicate maybeMultiline(string flags) { flags = unknownFlag() or isMultiline(flags) }

  /** Holds if `flags` includes the `g` flag or is the unknown flag `?`. */
  bindingset[flags]
  predicate maybeGlobal(string flags) { flags = unknownFlag() or isGlobal(flags) }

  /** Holds if `flags` includes the `i` flag or is the unknown flag `?`. */
  bindingset[flags]
  predicate maybeIgnoreCase(string flags) { flags = unknownFlag() or isIgnoreCase(flags) }

  /** Holds if `flags` includes the `s` flag or is the unknown flag `?`. */
  bindingset[flags]
  predicate maybeDotAll(string flags) { flags = unknownFlag() or isDotAll(flags) }

  /** Holds if `term` and all of its disjuncts are anchored on both ends. */
  predicate isFullyAnchoredTerm(RegExpTerm term) {
    exists(RegExpSequence seq | term = seq |
      seq.getChild(0) instanceof RegExpCaret and
      seq.getLastChild() instanceof RegExpDollar
    )
    or
    isFullyAnchoredTerm(term.(RegExpGroup).getAChild())
    or
    isFullyAnchoredAlt(term, term.getNumChild())
  }

  /** Holds if the first `i` disjuncts of `term` are fully anchored. */
  private predicate isFullyAnchoredAlt(RegExpAlt term, int i) {
    isFullyAnchoredTerm(term.getChild(0)) and i = 1
    or
    isFullyAnchoredAlt(term, i - 1) and
    isFullyAnchoredTerm(term.getChild(i - 1))
  }

  /**
   * Holds if `term` matches any character except for explicitly listed exceptions.
   *
   * For example, holds for `.`, `[^<>]`, or `\W`, but not for `[a-z]`, `\w`, or `[^\W\S]`.
   */
  predicate isWildcardLike(RegExpTerm term) {
    term instanceof RegExpDot
    or
    term.(RegExpCharacterClassEscape).getValue().isUppercase()
    or
    // [^a-z]
    exists(RegExpCharacterClass cls | term = cls |
      cls.isInverted() and
      not cls.getAChild().(RegExpCharacterClassEscape).getValue().isUppercase()
    )
    or
    // [\W]
    exists(RegExpCharacterClass cls | term = cls |
      not cls.isInverted() and
      cls.getAChild().(RegExpCharacterClassEscape).getValue().isUppercase()
    )
    or
    // an unlimited number of wildcards, is also a wildcard.
    exists(InfiniteRepetitionQuantifier q |
      term = q and
      isWildcardLike(q.getAChild())
    )
  }

  /**
   * Holds if `term` is a generic sanitizer for strings that match (if `outcome` is true)
   * or strings that don't match (if `outcome` is false).
   *
   * Specifically, whitelisting regexps such as `^(foo|bar)$` sanitize matches in the true case.
   * Inverted character classes such as `[^a-z]` or `\W` sanitize matches in the false case.
   */
  predicate isGenericRegExpSanitizer(RegExpTerm term, boolean outcome) {
    term.isRootTerm() and
    (
      outcome = true and
      isFullyAnchoredTerm(term) and
      not isWildcardLike(term.getAChild*())
      or
      // Character set restrictions like `/[^a-z]/.test(x)` sanitize in the false case
      outcome = false and
      exists(RegExpTerm root |
        root = term
        or
        root = term.(RegExpGroup).getAChild()
      |
        isWildcardLike(root)
        or
        isWildcardLike(root.(RegExpAlt).getAChild())
      )
    )
  }

  /**
   * Gets the AST of a regular expression object that can flow to `node`.
   */
  RegExpTerm getRegExpObjectFromNode(DataFlow::Node node) {
    exists(DataFlow::RegExpCreationNode regexp |
      regexp.getAReference().flowsTo(node) and
      result = regexp.getRoot()
    )
  }

  /**
   * Gets the AST of a regular expression that can flow to `node`,
   * including `RegExp` objects as well as strings interpreted as regular expressions.
   */
  RegExpTerm getRegExpFromNode(DataFlow::Node node) {
    result = getRegExpObjectFromNode(node)
    or
    result = node.asExpr().(StringLiteral).asRegExp()
  }

  /**
   * A character that will be analyzed by `RegExp::alwaysMatchesMetaCharacter`.
   *
   * Currently only `<`, `'`, and `"` are considered to be meta-characters, but new meta-characters
   * can be added by subclassing this class.
   */
  abstract class MetaCharacter extends string {
    bindingset[this]
    MetaCharacter() { any() }

    /**
     * Holds if the given atomic term matches this meta-character.
     *
     * Does not hold for derived terms like alternatives and groups.
     *
     * By default, `.`, `\W`, `\S`, and `\D` are considered to match any meta-character,
     * but the predicate can be overridden for meta-characters where this is not the case.
     */
    predicate matchedByAtom(RegExpTerm term) {
      term.(RegExpConstant).getConstantValue() = this
      or
      term instanceof RegExpDot
      or
      term.(RegExpCharacterClassEscape).getValue() = ["\\W", "\\S", "\\D"]
      or
      exists(string lo, string hi |
        term.(RegExpCharacterRange).isRange(lo, hi) and
        lo <= this and
        this <= hi
      )
    }
  }

  /**
   * A meta character used by HTML.
   */
  private class HtmlMetaCharacter extends MetaCharacter {
    HtmlMetaCharacter() { this = ["<", "'", "\""] }
  }

  /**
   * A meta character used by regular expressions.
   */
  private class RegexpMetaChars extends RegExp::MetaCharacter {
    RegexpMetaChars() { this = ["{", "[", "+"] }
  }

  /**
   * Holds if `term` can match any occurrence of `char` within a string (not taking into account
   * the context in which `term` appears).
   *
   * This predicate is under-approximate and never considers sequences to guarantee a match.
   */
  predicate alwaysMatchesMetaCharacter(RegExpTerm term, MetaCharacter char) {
    not term.getParent() instanceof RegExpSequence and // restrict size of predicate
    char.matchedByAtom(term)
    or
    alwaysMatchesMetaCharacter(term.(RegExpGroup).getAChild(), char)
    or
    alwaysMatchesMetaCharacter(term.(RegExpAlt).getAlternative(), char)
    or
    exists(RegExpCharacterClass class_ | term = class_ |
      not class_.isInverted() and
      char.matchedByAtom(class_.getAChild())
      or
      class_.isInverted() and
      not char.matchedByAtom(class_.getAChild())
    )
  }
}

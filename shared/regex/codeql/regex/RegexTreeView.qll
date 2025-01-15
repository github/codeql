/**
 * This file contains a `RegexTreeViewSig` module describing the syntax tree of regular expressions.
 */
overlay[local?]
module;

/**
 * A signature describing the syntax tree of regular expressions.
 */
signature module RegexTreeViewSig {
  /**
   * An element used in some way as or in a regular expression.
   * This class exists to have a common supertype that all languages can agree on.
   */
  class Top;

  /**
   * An element containing a regular expression term, that is, either
   * a string literal (parsed as a regular expression; the root of the parse tree)
   * or another regular expression term (a descendant of the root).
   */
  class RegExpParent extends Top;

  /**
   * A regular expression literal.
   *
   * Note that this class does not cover regular expressions constructed by calling the built-in
   * `RegExp` function.
   *
   * Example:
   *
   * ```
   * /(?i)ab*c(d|e)$/
   * ```
   */
  class RegExpLiteral extends RegExpParent;

  /**
   * A regular expression term, that is, a syntactic part of a regular expression.
   * These are the tree nodes that form the parse tree of a regular expression literal.
   */
  class RegExpTerm extends Top {
    /** Gets a child term of this term. */
    RegExpTerm getAChild();

    /**
     * Holds if this is the root term of a regular expression.
     */
    predicate isRootTerm();

    /**
     * Gets the parent term of this regular expression term, or the
     * regular expression literal if this is the root term.
     */
    RegExpParent getParent();

    /**
     * Holds if this term is part of a regular expression literal, or a string literal
     * that is interpreted as a regular expression.
     */
    predicate isUsedAsRegExp();

    /** Gets the outermost term of this regular expression. */
    RegExpTerm getRootTerm();

    /** Gets the raw source text of this term. */
    string getRawValue();

    /** Gets the `i`th child term of this term. */
    RegExpTerm getChild(int i);

    /** Gets the number of child terms of this term. */
    int getNumChild();

    /** Gets the regular expression term that is matched (textually) after this one, if any. */
    RegExpTerm getSuccessor();

    /** Gets the last child term of this element. */
    RegExpTerm getLastChild();

    string toString();

    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    );
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
  class RegExpQuantifier extends RegExpTerm;

  /**
   * A star-quantified term.
   *
   * Example:
   *
   * ```
   * \w*
   * ```
   */
  class RegExpStar extends RegExpQuantifier;

  /**
   * An optional term.
   *
   * Example:
   *
   * ```
   * ;?
   * ```
   */
  class RegExpOpt extends RegExpQuantifier;

  /**
   * A plus-quantified term.
   *
   * Example:
   *
   * ```
   * \w+
   * ```
   */
  class RegExpPlus extends RegExpQuantifier;

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
    /** Gets the lower bound of the range. */
    int getLowerBound();

    /**
     * Gets the upper bound of the range, if any.
     *
     * If there is no upper bound, any number of repetitions is allowed.
     * For a term of the form `r{lo}`, both the lower and the upper bound
     * are `lo`.
     */
    int getUpperBound();
  }

  /**
   * A non-word boundary, that is, a regular expression term of the form `\B`.
   */
  class RegExpNonWordBoundary extends RegExpTerm;

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
  class RegExpEscape extends RegExpTerm;

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
  class RegExpCharacterClassEscape extends RegExpEscape {
    /** Gets the name of the character class; for example, `w` for `\w`. */
    string getValue();
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
  class RegExpAlt extends RegExpTerm;

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
  class RegExpGroup extends RegExpTerm {
    /**
     * Gets the index of this capture group within the enclosing regular
     * expression literal.
     *
     * For example, in the regular expression `/((a?).)(?:b)/`, the
     * group `((a?).)` has index 1, the group `(a?)` nested inside it
     * has index 2, and the group `(?:b)` has no index, since it is
     * not a capture group.
     */
    int getNumber();

    /** Holds if this is a capture group. */
    predicate isCapture();
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
  class RegExpBackRef extends RegExpTerm {
    /** Gets the capture group this back reference refers to. */
    RegExpGroup getGroup();
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
  class RegExpSequence extends RegExpTerm;

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
  class RegExpSubPattern extends RegExpTerm {
    /** Gets the lookahead term. */
    RegExpTerm getOperand();
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
  class RegExpLookahead extends RegExpSubPattern;

  /**
   * A positive-lookahead assertion.
   *
   * Examples:
   *
   * ```
   * (?=\w)
   * ```
   */
  class RegExpPositiveLookahead extends RegExpLookahead;

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
  class RegExpLookbehind extends RegExpSubPattern;

  /**
   * A positive-lookbehind assertion.
   *
   * Examples:
   *
   * ```
   * (?<=\.)
   * ```
   */
  class RegExpPositiveLookbehind extends RegExpLookbehind;

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
  class RegExpConstant extends RegExpTerm {
    /** Gets the string matched by this constant term. */
    string getValue();

    /**
     * Holds if this constant represents a valid Unicode character (as opposed
     * to a surrogate code point that does not correspond to a character by itself.)
     */
    predicate isCharacter();
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
  class RegExpCharEscape extends RegExpEscape {
    /** Gets the string matched by this term. */
    string getValue();
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
  class RegExpCharacterClass extends RegExpTerm {
    /**
     * Holds if this character class matches any character.
     */
    predicate isUniversalClass();

    /** Holds if this is an inverted character class, that is, a term of the form `[^...]`. */
    predicate isInverted();
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
  class RegExpCharacterRange extends RegExpTerm {
    /** Holds if `lo` is the lower bound of this character range and `hi` the upper bound. */
    predicate isRange(string lo, string hi);
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
  class RegExpDot extends RegExpTerm;

  /**
   * A term that matches a specific position between characters in the string.
   *
   * Example:
   *
   * ```
   * \A
   * ```
   */
  class RegExpAnchor extends RegExpTerm {
    /** Gets the char for this term. */
    string getChar();
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
  class RegExpDollar extends RegExpAnchor;

  /**
   * A caret assertion `^` matching the beginning of a line.
   *
   * Example:
   *
   * ```
   * ^
   * ```
   */
  class RegExpCaret extends RegExpAnchor;

  /**
   * A word boundary assertion.
   *
   * Example:
   *
   * ```
   * \b
   * ```
   */
  class RegExpWordBoundary extends RegExpTerm;

  /**
   * A regular expression term that permits unlimited repetitions.
   */
  class InfiniteRepetitionQuantifier extends RegExpQuantifier;

  /**
   * Holds if the regular expression should not be considered.
   *
   * For javascript we make the pragmatic performance optimization to ignore minified files.
   */
  predicate isExcluded(RegExpParent parent);

  /**
   * Holds if `term` is a possessive quantifier.
   * As javascript's regexes do not support possessive quantifiers, this never holds, but is used by the shared library.
   */
  predicate isPossessive(RegExpQuantifier term);

  /**
   * Holds if the regex that `term` is part of is used in a way that ignores any leading prefix of the input it's matched against.
   * Not yet implemented for JavaScript.
   */
  predicate matchesAnyPrefix(RegExpTerm term);

  /**
   * Holds if the regex that `term` is part of is used in a way that ignores any trailing suffix of the input it's matched against.
   * Not yet implemented for JavaScript.
   */
  predicate matchesAnySuffix(RegExpTerm term);

  /**
   * Holds if `term` is an escape class representing e.g. `\d`.
   * `clazz` is which character class it represents, e.g. "d" for `\d`.
   */
  predicate isEscapeClass(RegExpTerm term, string clazz);

  /**
   * Holds if `root` has the `i` flag for case-insensitive matching.
   */
  predicate isIgnoreCase(RegExpTerm root);

  /**
   * Holds if `root` has the `s` flag for multi-line matching.
   */
  predicate isDotAll(RegExpTerm root);
}

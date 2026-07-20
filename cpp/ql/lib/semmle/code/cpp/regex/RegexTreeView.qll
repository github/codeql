/**
 * Provides a class hierarchy corresponding to a parse tree of C++ regular
 * expressions, and an implementation of `RegexTreeViewSig` for use with the
 * shared ReDoS analysis libraries.
 *
 * The target dialect is **ECMAScript** (the default for `std::regex`).
 *
 * Usage:
 * ```ql
 * import semmle.code.cpp.regex.RegexTreeView
 * // RegExpTerm, RegExpGroup, etc. are available directly.
 * ```
 */

import cpp
private import semmle.code.cpp.regex.internal.ParseRegExp
private import semmle.code.cpp.regex.RegexFlowConfigs as RFC
private import codeql.regex.RegexTreeView
// Export the implementation both as `RegexTreeView` (for use as a functor
// argument) and in the top-level scope (for direct import).
import Impl as RegexTreeView
import Impl

/** Gets the root parse-tree term for `re`, if it has been parsed. */
RegExpTerm getParsedRegExp(StringLiteral re) { result.getRegex() = re and result.isRootTerm() }

// ---------------------------------------------------------------------------
// newtype  TRegExpParent
// ---------------------------------------------------------------------------
/**
 * An element that is either a regex literal (the root of a parse tree) or a
 * regex term (a node in the parse tree).
 *
 * For sequences and alternations we require at least one child; otherwise the
 * node is represented as its sole element instead.
 */
private newtype TRegExpParent =
  /** A string literal used as a regular expression. */
  TRegExpLiteral(RegExp re) or
  /** A quantified term. */
  TRegExpQuantifier(RegExp re, int start, int end) { re.qualifiedItem(start, end, _, _) } or
  /** A sequence of two or more items. */
  TRegExpSequence(RegExp re, int start, int end) {
    re.sequence(start, end) and
    exists(seqChild(re, start, end, 1)) // require at least two children
  } or
  /** An alternation (`a|b`). */
  TRegExpAlt(RegExp re, int start, int end) {
    re.alternation(start, end) and
    exists(int part_end | re.alternationOption(start, end, start, part_end) and part_end < end) // require at least two alternatives
  } or
  /** A character class (`[...]`). */
  TRegExpCharacterClass(RegExp re, int start, int end) { re.charSet(start, end) } or
  /** A character range inside a character class (`a-z`). */
  TRegExpCharacterRange(RegExp re, int start, int end) { re.charRange(_, start, _, _, end) } or
  /**
   * A POSIX bracket sub-expression inside a character class, such as
   * `[:alpha:]`, `[.a.]`, or `[=a=]`. These are only recognized inside a
   * `[...]` character class.
   */
  TRegExpPosixBracket(RegExp re, int start, int end, string kind) {
    re.posixBracketExpression(start, end, kind)
  } or
  /** A group (`(...)`, `(?:...)`, `(?<name>...)`, etc.). */
  TRegExpGroup(RegExp re, int start, int end) { re.group(start, end) } or
  /** A special (meta) character (`.`, `^`, `$`, `\b`, `\B`). */
  TRegExpSpecialChar(RegExp re, int start, int end) { re.specialCharacter(start, end, _) } or
  /** A normal character or escape sequence (not a special character). */
  TRegExpNormalChar(RegExp re, int start, int end) {
    re.normalCharacterSequence(start, end)
    or
    re.escapedCharacter(start, end) and
    not re.specialCharacter(start, end, _)
  } or
  /** A back-reference (`\1`, `\k<name>`). */
  TRegExpBackRef(RegExp re, int start, int end) { re.backreference(start, end) }

// ---------------------------------------------------------------------------
// Helper: sequence children
// ---------------------------------------------------------------------------
pragma[nomagic]
private int seqChildEnd(RegExp re, int start, int end, int i) {
  result = seqChild(re, start, end, i).getEnd()
}

private RegExpTerm seqChild(RegExp re, int start, int end, int i) {
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
    exists(int itemStart | itemStart = seqChildEnd(re, start, end, i - 1) |
      result.getStart() = itemStart and
      re.item(itemStart, result.getEnd())
    )
  )
}

// ---------------------------------------------------------------------------
// Module Impl  (implements RegexTreeViewSig)
// ---------------------------------------------------------------------------
/**
 * Gets the length of the C++ encoding prefix (`L`, `u`, `U`, `u8`) at the
 * start of a string-literal spelling, or 0 if none is present.
 *
 * `u8` is checked before `u` so that a `u8"..."` literal is not mistakenly
 * seen as a `u"..."` literal.
 */
bindingset[spelling]
private int getEncodingPrefixLength(string spelling) {
  if spelling.substring(0, 2) = "u8"
  then result = 2
  else
    if spelling.substring(0, 1) = ["L", "u", "U"]
    then result = 1
    else result = 0
}

/**
 * Gets the number of characters at the start of the raw spelling of the
 * string literal `re` that precede its first content character. This is
 * the width of the encoding prefix (if any) plus the opening delimiter:
 * `"` for a non-raw literal, or `R"delim(` (with a possibly-empty
 * user-chosen `delim`) for a raw literal.
 *
 * For a plain narrow `"..."` literal this returns 1, matching the earlier
 * hard-coded gap.
 *
 * If the spelling cannot be recognized (for example after macro
 * expansion), falls back to 1 so that no location becomes empty.
 */
private int getContentOffset(RegExp re) {
  result = tryGetContentOffset(re)
  or
  not exists(tryGetContentOffset(re)) and result = 1
}

/**
 * Gets the content offset of `re` when its raw spelling matches a
 * recognized C++ string-literal form.
 */
private int tryGetContentOffset(RegExp re) {
  exists(string spelling, int encLen |
    spelling = re.getValueText() and
    encLen = getEncodingPrefixLength(spelling)
  |
    // Raw string: `R"delim(...)delim"`. The content starts one past the
    // `(` that terminates the raw prefix; the delimiter is the (possibly
    // empty) text between the opening `"` and that `(`.
    spelling.charAt(encLen) = "R" and
    spelling.charAt(encLen + 1) = "\"" and
    result = spelling.indexOf("(", 0, encLen + 2) + 1
    or
    // Non-raw string: `"..."`. Content starts one past the opening `"`.
    spelling.charAt(encLen) = "\"" and
    result = encLen + 1
  )
}

/** An implementation that satisfies the `RegexTreeViewSig` signature. */
module Impl implements RegexTreeViewSig {
  // -------------------------------------------------------------------------
  // RegExpParent
  // -------------------------------------------------------------------------
  /**
   * An element containing a regular expression term: either the literal itself
   * or a term node.
   */
  class RegExpParent extends TRegExpParent {
    /** Gets a textual representation of this element. */
    string toString() { result = "RegExpParent" }

    /** Gets the `i`th child term. */
    abstract RegExpTerm getChild(int i);

    /** Gets any child term. */
    RegExpTerm getAChild() { result = this.getChild(_) }

    /** Gets the number of child terms. */
    int getNumChild() { result = count(this.getAChild()) }

    /** Gets the last child term. */
    RegExpTerm getLastChild() { result = this.getChild(this.getNumChild() - 1) }

    /** Gets the underlying regex. */
    abstract RegExp getRegex();

    /** Gets a primary QL class for this element. */
    string getAPrimaryQlClass() { result = "RegExpParent" }

    /** Gets a comma-separated list of primary QL classes for this element. */
    final string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }
  }

  // -------------------------------------------------------------------------
  // RegExpLiteral
  // -------------------------------------------------------------------------
  /** A string literal used as a regular expression. */
  class RegExpLiteral extends TRegExpLiteral, RegExpParent {
    RegExp re;

    RegExpLiteral() { this = TRegExpLiteral(re) }

    override RegExpTerm getChild(int i) { i = 0 and result.getRegex() = re and result.isRootTerm() }

    /**
     * Holds if dot `.` matches all characters including newlines.
     *
     * ECMAScript `std::regex` has no dot-all flag: neither `icase` nor
     * `multiline` change the behavior of `.`. This predicate therefore does
     * not hold for any C++ `std::regex` literal.
     */
    predicate isDotAll() { none() }

    /**
     * Holds if matching is case-insensitive. Reflects whether the underlying
     * `std::basic_regex` was constructed with
     * `std::regex_constants::icase` (directly or in a bitwise-OR combination).
     */
    predicate isIgnoreCase() { RFC::hasIgnoreCaseFlag(re) }

    /**
     * Holds if `^` and `$` match at line boundaries (`std::regex_constants::multiline`,
     * C++17+).
     */
    predicate isMultiline() { RFC::hasMultilineFlag(re) }

    /** Gets a string representing all flags for this regex. */
    string getFlags() {
      result =
        strictconcat(string f |
          this.isIgnoreCase() and f = "i"
          or
          this.isMultiline() and f = "m"
        |
          f order by f
        )
    }

    override RegExp getRegex() { result = re }

    /** Gets the primary QL class for this element. */
    override string getAPrimaryQlClass() { result = "RegExpLiteral" }
  }

  // -------------------------------------------------------------------------
  // RegExpTerm (base class for all parse-tree nodes)
  // -------------------------------------------------------------------------
  /**
   * A regular expression term - a node in the parse tree of a regex literal.
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
      this = TRegExpPosixBracket(re, start, end, _)
      or
      this = TRegExpNormalChar(re, start, end)
      or
      this = TRegExpGroup(re, start, end)
      or
      this = TRegExpQuantifier(re, start, end)
      or
      this = TRegExpSequence(re, start, end)
      or
      this = TRegExpSpecialChar(re, start, end)
    }

    /** Gets the outermost (root) term of this regular expression. */
    RegExpTerm getRootTerm() {
      this.isRootTerm() and result = this
      or
      result = this.getParent().(RegExpTerm).getRootTerm()
    }

    /**
     * Holds if this term is part of a string literal that is (potentially)
     * used as a regular expression.
     */
    predicate isUsedAsRegExp() { any() }

    /**
     * Holds if this is the root term of a regular expression (i.e., it covers
     * the full string value).
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
      result = this.(RegExpPosixBracket).getChild(i)
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

    /**
     * Gets the parent term (or the literal if this is the root term).
     */
    RegExpParent getParent() { result.getAChild() = this }

    override RegExp getRegex() { result = re }

    /** Gets the start offset of this term in the string value. */
    int getStart() { result = start }

    /** Gets the end offset (exclusive) of this term in the string value. */
    int getEnd() { result = end }

    override string toString() { result = re.getText().substring(start, end) }

    /**
     * Gets the source location of the enclosing string literal.
     * Use `hasLocationInfo` to get offsets within the string.
     */
    Location getLocation() { result = re.getLocation() }

    /**
     * Holds if this term is found at the given source location.
     *
     * The location maps back to character offsets within the C++ string
     * literal. The gap between the literal's start column and its first
     * content character depends on the literal's raw spelling: it accounts
     * for any encoding prefix (`L`, `u`, `U`, `u8`) and for the opening
     * delimiter, which is a single `"` for a plain literal and `R"delim(`
     * (with a possibly-empty user-chosen `delim`) for a raw literal.
     * `getContentOffset` computes this gap from the raw spelling so that
     * every literal form maps to the correct source columns.
     *
     * This is an approximation that handles single-line literals: for a
     * literal whose content spans multiple source lines (for example a raw
     * string containing newlines) the reported column is a column within
     * the literal's start line, mirroring the documented approximations in
     * the Java and Python regex tree views.
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      exists(Location loc, int contentOffset |
        loc = re.getLocation() and
        contentOffset = getContentOffset(re)
      |
        loc.hasLocationInfo(filepath, startline, _, _, _) and
        startcolumn = loc.getStartColumn() + contentOffset + start and
        endline = startline and
        // `end` is exclusive, so subtract 1 to point at the last character.
        endcolumn = loc.getStartColumn() + contentOffset + end - 1
      )
    }

    /** Gets the file this term is in. */
    File getFile() { result = re.getFile() }

    /** Gets the raw source text of this term. */
    string getRawValue() { result = this.toString() }

    /** Gets the string literal enclosing this term. */
    RegExpLiteral getLiteral() { result = TRegExpLiteral(re) }

    /** Gets the term matched (textually) immediately before this one, if any. */
    RegExpTerm getPredecessor() {
      exists(RegExpTerm parent | parent = this.getParent() |
        result = parent.(RegExpSequence).previousElement(this)
        or
        not exists(parent.(RegExpSequence).previousElement(this)) and
        not parent instanceof RegExpSubPattern and
        result = parent.getPredecessor()
      )
    }

    /** Gets the term matched (textually) immediately after this one, if any. */
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
    override string getAPrimaryQlClass() { result = "RegExpTerm" }
  }

  // -------------------------------------------------------------------------
  // Quantifiers
  // -------------------------------------------------------------------------
  /**
   * A quantified regular expression term (`a*`, `a+`, `a?`, `a{n,m}`, etc.).
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
      result.getRegex() = re and
      result.getStart() = start and
      result.getEnd() = part_end
    }

    /** Holds if this quantifier may match an unbounded number of times. */
    predicate mayRepeatForever() { may_repeat_forever = true }

    /** Gets the textual qualifier (e.g., `*`, `+`, `{2,5}`). */
    string getQualifier() { result = re.getText().substring(part_end, end) }

    override string getAPrimaryQlClass() { result = "RegExpQuantifier" }
  }

  /**
   * A quantifier that permits unlimited repetitions (`*`, `+`, or `{n,}`).
   */
  class InfiniteRepetitionQuantifier extends RegExpQuantifier {
    InfiniteRepetitionQuantifier() { this.mayRepeatForever() }
  }

  /** A star-quantified term (`a*`). */
  class RegExpStar extends InfiniteRepetitionQuantifier {
    RegExpStar() { this.getQualifier().charAt(0) = "*" }

    override string getAPrimaryQlClass() { result = "RegExpStar" }
  }

  /** A plus-quantified term (`a+`). */
  class RegExpPlus extends InfiniteRepetitionQuantifier {
    RegExpPlus() { this.getQualifier().charAt(0) = "+" }

    override string getAPrimaryQlClass() { result = "RegExpPlus" }
  }

  /** An optional term (`a?`). */
  class RegExpOpt extends RegExpQuantifier {
    RegExpOpt() { this.getQualifier().charAt(0) = "?" }

    override string getAPrimaryQlClass() { result = "RegExpOpt" }
  }

  /**
   * A range-quantified term (`a{2}`, `a{2,5}`, `a{2,}`).
   */
  class RegExpRange extends RegExpQuantifier {
    string upper;
    string lower;

    RegExpRange() { re.multiples(part_end, end, lower, upper) }

    /** Gets the lower bound of this range. */
    int getLowerBound() { result = lower.toInt() }

    /**
     * Gets the upper bound of this range, if any.
     *
     * For `{n}`, both lower and upper are `n`.
     * For `{n,}`, there is no upper bound (this predicate has no result).
     */
    int getUpperBound() { result = upper.toInt() }

    override string getAPrimaryQlClass() { result = "RegExpRange" }
  }

  // -------------------------------------------------------------------------
  // Sequences and alternations
  // -------------------------------------------------------------------------
  /**
   * A sequence term - two or more items in a row.
   *
   * Example: `ab` is a sequence of `a` and `b`.
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

    override string getAPrimaryQlClass() { result = "RegExpSequence" }
  }

  /**
   * An alternation term (`a|b`).
   */
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
        part_start = this.getChild(i - 1).getEnd() + 1 // skip the `|`
      |
        result.getStart() = part_start and
        re.alternationOption(start, end, part_start, result.getEnd())
      )
    }

    override string getAPrimaryQlClass() { result = "RegExpAlt" }
  }

  // -------------------------------------------------------------------------
  // Character escapes and normal characters
  // -------------------------------------------------------------------------
  /**
   * A normal character in a regular expression (including escape sequences).
   */
  additional class RegExpNormalChar extends RegExpTerm, TRegExpNormalChar {
    RegExpNormalChar() { this = TRegExpNormalChar(re, start, end) }

    /** Holds if this is a valid Unicode character (always true here). */
    predicate isCharacter() { any() }

    /** Gets the string representation of this character. */
    string getValue() { result = re.getText().substring(start, end) }

    override RegExpTerm getChild(int i) { none() }

    override string getAPrimaryQlClass() { result = "RegExpNormalChar" }
  }

  /**
   * A character escape in a regular expression (`\.`, `\n`, etc.).
   * This is a type alias; `RegExpCharEscape` == `RegExpEscape`.
   */
  class RegExpCharEscape = RegExpEscape;

  /**
   * An escaped regular expression term - starts with `\` and is not a
   * back-reference.
   */
  class RegExpEscape extends RegExpNormalChar {
    RegExpEscape() { re.escapedCharacter(start, end) }

    /**
     * Gets the name of the escaped character; for example, `w` for `\w` and
     * `n` for `\n`.
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
    }

    /** Holds if this escape's name is the character following the backslash. */
    predicate isIdentityEscape() { not this.getUnescaped() in ["n", "r", "t", "f", "v"] }

    override string getAPrimaryQlClass() { result = "RegExpEscape" }

    /** Gets the part of the term following the backslash (e.g., `w` for `\w`). */
    string getUnescaped() { result = re.getText().substring(start + 1, end) }
  }

  /**
   * A character-class escape - an escape that denotes a set of characters.
   *
   * Examples: `\d`, `\D`, `\w`, `\W`, `\s`, `\S`.
   */
  class RegExpCharacterClassEscape extends RegExpEscape {
    RegExpCharacterClassEscape() { this.getValue() in ["d", "D", "s", "S", "w", "W"] }

    override RegExpTerm getChild(int i) { none() }

    override string getAPrimaryQlClass() { result = "RegExpCharacterClassEscape" }
  }

  // -------------------------------------------------------------------------
  // Character classes  [...]
  // -------------------------------------------------------------------------
  /**
   * A character class in a regular expression (`[a-z]`, `[^0-9]`, etc.).
   */
  class RegExpCharacterClass extends RegExpTerm, TRegExpCharacterClass {
    RegExpCharacterClass() { this = TRegExpCharacterClass(re, start, end) }

    /** Holds if this character class is inverted (`[^...]`). */
    predicate isInverted() { re.getChar(start + 1) = "^" }

    /**
     * Holds if this character class matches any character.
     *
     * That is, `[^]` (empty inverted class) or `[\w\W]`/`[\d\D]`/`[\s\S]`
     * (complementary class escapes).
     */
    predicate isUniversalClass() {
      // [^] - empty inverted class
      this.isInverted() and not exists(this.getAChild())
      or
      // [\w\W] and similar - two complementary class escapes
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

    override string getAPrimaryQlClass() { result = "RegExpCharacterClass" }
  }

  /**
   * A character range inside a character class (`a-z`).
   */
  class RegExpCharacterRange extends RegExpTerm, TRegExpCharacterRange {
    int lower_end;
    int upper_start;

    RegExpCharacterRange() {
      this = TRegExpCharacterRange(re, start, end) and
      re.charRange(_, start, lower_end, upper_start, end)
    }

    /** Holds if this range spans from `lo` to `hi`. */
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

    override string getAPrimaryQlClass() { result = "RegExpCharacterRange" }
  }

  /**
   * A POSIX bracket sub-expression inside a character class.
   *
   * C++'s ECMAScript-mode `std::regex` grammar (per `[re.grammar]`)
   * additionally supports three POSIX bracket forms inside a `[...]`
   * character class, none of which are part of ECMA-262 JavaScript:
   *
   *   - POSIX character class: `[:alpha:]`, `[:digit:]`, `[:space:]`, ...
   *   - Collating symbol:      `[.a.]`, `[.tilde.]`, ...
   *   - Equivalence class:     `[=a=]`, `[=A=]`, ...
   *
   * Each is treated as a single character-matching atom (a class member).
   *
   * For POSIX character classes with a clean Perl-escape equivalent
   * (`digit`, `space`, `word`) - or a *subset* of one (`alpha`, `alnum`,
   * `upper`, `lower`, `xdigit`, `blank`) - we map them onto `\d`, `\s`, `\w`
   * via `isEscapeClass`, so the shared ReDoS engine can reason about their
   * match sets.
   *
   * Other POSIX classes (`punct`, `cntrl`, `print`, `graph`) as well as
   * collating and equivalence classes do NOT fit any of `\d`/`\s`/`\w`:
   *   - `[:punct:]` matches punctuation, disjoint from `\w`.
   *   - `[:cntrl:]` matches control characters, disjoint from `\w`.
   *   - `[:print:]` / `[:graph:]` include punctuation (and, for `print`,
   *     space), overlapping but not contained in `\w`.
   * Mapping them onto `\w` would tell the shared engine that two such atoms
   * "overlap" via `\w`, which is unsound (produces both false positives and
   * false negatives in ambiguity reasoning). We therefore leave them opaque:
   * they are single character-consuming class members, but `isEscapeClass`
   * does not hold for them and the shared engine treats them as an unknown
   * character set (the same treatment as collating/equivalence classes).
   *
   * Collating and equivalence classes semantically may match multi-character
   * sequences (e.g. `[[.ll.]]`); we model them as single atoms, which is a
   * documented approximation.
   */
  additional class RegExpPosixBracket extends RegExpTerm, TRegExpPosixBracket {
    string kind;

    RegExpPosixBracket() { this = TRegExpPosixBracket(re, start, end, kind) }

    /**
     * Gets the kind of this POSIX bracket sub-expression: one of `"class"`,
     * `"collating"`, or `"equivalence"`.
     */
    string getKind() { result = kind }

    /**
     * Gets the inner name of this bracket, without the delimiters. For
     * `[:alpha:]` this is `"alpha"`; for `[.tilde.]` this is `"tilde"`; for
     * `[=a=]` this is `"a"`.
     */
    string getName() { result = re.getText().substring(start + 2, end - 2) }

    override RegExpTerm getChild(int i) { none() }

    override string getAPrimaryQlClass() { result = "RegExpPosixBracket" }
  }

  // -------------------------------------------------------------------------
  // Special characters  (`.`, `^`, `$`, `\b`, `\B`)
  // -------------------------------------------------------------------------
  /**
   * A special (meta) character in a regular expression.
   *
   * In ECMAScript: `.`, `^`, `$`, `\b`, `\B`.
   */
  additional class RegExpSpecialChar extends RegExpTerm, TRegExpSpecialChar {
    string char;

    RegExpSpecialChar() {
      this = TRegExpSpecialChar(re, start, end) and
      re.specialCharacter(start, end, char)
    }

    /** Holds if this constant is a valid Unicode character (always true). */
    predicate isCharacter() { any() }

    /** Gets the character (e.g., `"."`, `"^"`, `"\\b"`). */
    string getChar() { result = char }

    override RegExpTerm getChild(int i) { none() }

    override string getAPrimaryQlClass() { result = "RegExpSpecialChar" }
  }

  /** A dot (`.`) that matches any character (except possibly newlines). */
  class RegExpDot extends RegExpSpecialChar {
    RegExpDot() { this.getChar() = "." }

    override string getAPrimaryQlClass() { result = "RegExpDot" }
  }

  /** An anchor term (`^`, `$`). */
  class RegExpAnchor extends RegExpSpecialChar {
    RegExpAnchor() { char = ["^", "$"] }
  }

  /**
   * A dollar assertion `$`, matching the end of the input (or end of a line in
   * multiline mode).
   *
   * NOTE: `std::regex_constants::multiline` is detected by
   * `RegexFlowConfigs.qll` (`hasMultilineFlag`) and exposed by
   * `RegExpLiteral.isMultiline()`, but the shared `RegexTreeViewSig`
   * signature has no hook to parameterize anchor semantics on multiline
   * mode. We therefore always model `$` as the end-of-string anchor -
   * mirroring the conservative choice made by the JavaScript and Ruby
   * ReDoS analyses. Under `multiline`, `$` can additionally match at `\n`,
   * which affects rejecting-suffix reasoning for `^`/`$`-anchored
   * patterns; this may cause minor false positives/negatives for
   * multiline-flagged regexes. Precise modeling would require extending
   * `RegexTreeViewSig`, which is out of scope for the C++ port.
   */
  class RegExpDollar extends RegExpAnchor {
    RegExpDollar() { char = "$" }

    override string getAPrimaryQlClass() { result = "RegExpDollar" }
  }

  /**
   * A caret assertion `^`, matching the start of the input (or start of a line
   * in multiline mode).
   *
   * See the note on `RegExpDollar` regarding the (currently unmodeled)
   * `std::regex_constants::multiline` flag.
   */
  class RegExpCaret extends RegExpAnchor {
    RegExpCaret() { char = "^" }

    override string getAPrimaryQlClass() { result = "RegExpCaret" }
  }

  /** A word-boundary assertion `\b`. */
  class RegExpWordBoundary extends RegExpSpecialChar {
    RegExpWordBoundary() { this.getChar() = "\\b" }

    override string getAPrimaryQlClass() { result = "RegExpWordBoundary" }
  }

  /** A non-word-boundary assertion `\B`. */
  class RegExpNonWordBoundary extends RegExpSpecialChar {
    RegExpNonWordBoundary() { this.getChar() = "\\B" }

    override string getAPrimaryQlClass() { result = "RegExpNonWordBoundary" }
  }

  // -------------------------------------------------------------------------
  // Groups (capturing, non-capturing, named, lookahead/lookbehind)
  // -------------------------------------------------------------------------
  /**
   * A grouped regular expression: `(...)`, `(?:...)`, `(?<name>...)`, or an
   * assertion group `(?=...)`, etc.
   */
  class RegExpGroup extends RegExpTerm, TRegExpGroup {
    RegExpGroup() { this = TRegExpGroup(re, start, end) }

    /**
     * Gets the index of this capture group within the enclosing regex literal.
     *
     * For example, in `((a?).)(?:b)`:
     * - `((a?).)` has index 1
     * - `(a?)` has index 2
     * - `(?:b)` has no index (non-capturing)
     */
    int getNumber() { result = re.getGroupNumber(start, end) }

    /** Holds if this is a capture group (has an index). */
    predicate isCapture() { exists(this.getNumber()) }

    /** Holds if this is a named capture group. */
    predicate isNamed() { exists(this.getName()) }

    /** Gets the name of this named capture group, if any. */
    string getName() { result = re.getGroupName(start, end) }

    override RegExpTerm getChild(int i) {
      result.getRegex() = re and
      i = 0 and
      re.groupContents(start, end, result.getStart(), result.getEnd())
    }

    override string getAPrimaryQlClass() { result = "RegExpGroup" }
  }

  // -------------------------------------------------------------------------
  // Zero-width matches and sub-patterns (lookahead/lookbehind)
  // -------------------------------------------------------------------------
  /**
   * A zero-width match: an empty group or an assertion.
   */
  additional class RegExpZeroWidthMatch extends RegExpGroup {
    RegExpZeroWidthMatch() { re.zeroWidthMatch(start, end) }

    override RegExpTerm getChild(int i) { none() }

    override string getAPrimaryQlClass() { result = "RegExpZeroWidthMatch" }
  }

  /**
   * A non-empty zero-width assertion (lookahead or lookbehind).
   */
  class RegExpSubPattern extends RegExpZeroWidthMatch {
    RegExpSubPattern() { not re.emptyGroup(start, end) }

    /** Gets the operand of this assertion. */
    RegExpTerm getOperand() {
      exists(int in_start, int in_end | re.groupContents(start, end, in_start, in_end) |
        result.getRegex() = re and
        result.getStart() = in_start and
        result.getEnd() = in_end
      )
    }
  }

  /** A lookahead assertion (`(?=...)` or `(?!...)`). */
  abstract class RegExpLookahead extends RegExpSubPattern { }

  /** A positive lookahead assertion (`(?=...)`). */
  class RegExpPositiveLookahead extends RegExpLookahead {
    RegExpPositiveLookahead() { re.positiveLookaheadAssertionGroup(start, end, _, _) }

    override string getAPrimaryQlClass() { result = "RegExpPositiveLookahead" }
  }

  /** A negative lookahead assertion (`(?!...)`). */
  additional class RegExpNegativeLookahead extends RegExpLookahead {
    RegExpNegativeLookahead() { re.negativeLookaheadAssertionGroup(start, end, _, _) }

    override string getAPrimaryQlClass() { result = "RegExpNegativeLookahead" }
  }

  /** A lookbehind assertion (`(?<=...)` or `(?<!...)`). */
  abstract class RegExpLookbehind extends RegExpSubPattern { }

  /** A positive lookbehind assertion (`(?<=...)`). */
  class RegExpPositiveLookbehind extends RegExpLookbehind {
    RegExpPositiveLookbehind() { re.positiveLookbehindAssertionGroup(start, end, _, _) }

    override string getAPrimaryQlClass() { result = "RegExpPositiveLookbehind" }
  }

  /** A negative lookbehind assertion (`(?<!...)`). */
  additional class RegExpNegativeLookbehind extends RegExpLookbehind {
    RegExpNegativeLookbehind() { re.negativeLookbehindAssertionGroup(start, end, _, _) }

    override string getAPrimaryQlClass() { result = "RegExpNegativeLookbehind" }
  }

  // -------------------------------------------------------------------------
  // Back-references
  // -------------------------------------------------------------------------
  /**
   * A back-reference: `\1`, `\k<name>`.
   */
  class RegExpBackRef extends RegExpTerm, TRegExpBackRef {
    RegExpBackRef() { this = TRegExpBackRef(re, start, end) }

    /** Gets the group number this back-reference refers to, if any. */
    int getNumber() { result = re.getBackrefNumber(start, end) }

    /** Gets the group name this back-reference refers to, if any. */
    string getName() { result = re.getBackrefName(start, end) }

    /** Gets the group that this back-reference refers to. */
    RegExpGroup getGroup() {
      this.hasLiteralAndNumber(result.getLiteral(), result.getNumber()) or
      this.hasLiteralAndName(result.getLiteral(), result.getName())
    }

    pragma[nomagic]
    private predicate hasLiteralAndNumber(RegExpLiteral literal, int number) {
      literal = this.getLiteral() and
      number = this.getNumber()
    }

    pragma[nomagic]
    private predicate hasLiteralAndName(RegExpLiteral literal, string name) {
      literal = this.getLiteral() and
      name = this.getName()
    }

    override RegExpTerm getChild(int i) { none() }

    override string getAPrimaryQlClass() { result = "RegExpBackRef" }
  }

  // -------------------------------------------------------------------------
  // RegExpConstant
  // -------------------------------------------------------------------------
  /**
   * A constant regular expression term - a sequence of characters that matches
   * a fixed string. Currently this is always a single character (or escape
   * sequence).
   */
  class RegExpConstant extends RegExpTerm {
    string value;

    RegExpConstant() {
      this = TRegExpNormalChar(re, start, end) and
      not this instanceof RegExpCharacterClassEscape and
      not exists(int qstart, int qend | re.qualifiedPart(_, qstart, qend, _, _) |
        qstart <= start and end <= qend
      ) and
      value = this.(RegExpNormalChar).getValue()
    }

    /** Holds if this constant is a valid Unicode character (always true). */
    predicate isCharacter() { any() }

    /** Gets the string matched by this constant term. */
    string getValue() { result = value }

    override RegExpTerm getChild(int i) { none() }

    override string getAPrimaryQlClass() { result = "RegExpConstant" }
  }

  // -------------------------------------------------------------------------
  // Top
  // -------------------------------------------------------------------------
  /** The common supertype of all regex-related elements. */
  class Top = RegExpParent;

  // -------------------------------------------------------------------------
  // Signature predicates
  // -------------------------------------------------------------------------
  /**
   * Holds if `term` is an escape class (e.g., `\d`), and `clazz` is the
   * character identifying the class (e.g., `"d"`).
   */
  predicate isEscapeClass(RegExpTerm term, string clazz) {
    exists(RegExpCharacterClassEscape escape | term = escape | escape.getValue() = clazz)
    or
    // Map POSIX bracket sub-expressions to the shared engine's escape-class
    // signature. Only POSIX character classes (`[:name:]`) whose match set
    // is `\d`, `\s`, or `\w` - or a subset of one - are mapped; other
    // POSIX classes (`punct`, `cntrl`, `print`, `graph`) and the
    // collating/equivalence forms have no meaningful escape-class equivalent
    // and are left opaque (they still parse as single character-class atoms,
    // but the shared engine treats their character set as unknown).
    exists(RegExpPosixBracket posix, string name |
      term = posix and
      posix.getKind() = "class" and
      name = posix.getName()
    |
      // `[:digit:]` = `\d`; `[:xdigit:]` is a superset, treated as `\d`
      // (under-approximation - sound for the shared engine's overlap
      // reasoning, since it will only ever detect fewer intersections, not
      // invent them).
      name = ["digit", "xdigit"] and clazz = "d"
      or
      // `[:space:]` = `\s`; `[:blank:]` is a subset (space + tab).
      name = ["space", "blank"] and clazz = "s"
      or
      // `[:word:]` = `\w`; `[:alpha:]`, `[:alnum:]`, `[:upper:]`, `[:lower:]`
      // are all subsets of `\w`.
      name = ["word", "alpha", "alnum", "upper", "lower"] and clazz = "w"
    )
  }

  /**
   * ECMAScript (`std::regex`) does not support possessive quantifiers,
   * so this never holds.
   */
  predicate isPossessive(RegExpQuantifier term) { none() }

  /**
   * Holds if the regex that `term` is part of is used in a way that ignores
   * any leading prefix of the input it is matched against.
   *
   * Conservative over-approximation: always holds, matching the JavaScript
   * implementation's placeholder. TODO (Phase 2): refine using dataflow.
   */
  predicate matchesAnyPrefix(RegExpTerm term) { any() }

  /**
   * Holds if the regex that `term` is part of is used in a way that ignores
   * any trailing suffix of the input it is matched against.
   *
   * Conservative over-approximation: always holds. TODO (Phase 2): refine.
   */
  predicate matchesAnySuffix(RegExpTerm term) { any() }

  /**
   * Holds if the regular expression should not be considered by the shared
   * analysis.
   *
   * We exclude:
   * - Regexes in files without a relative path (i.e., external/library code).
   * - Regexes with an excessive number of `.*` sub-expressions (performance).
   */
  predicate isExcluded(RegExpParent parent) {
    not exists(parent.getRegex().getFile().getRelativePath())
    or
    count(int i | exists(parent.getRegex().getText().regexpFind("\\.\\*", i, _)) | i) > 10
  }

  /**
   * Holds if `root` has the `i` flag for case-insensitive matching, i.e. the
   * underlying `std::basic_regex` was constructed with
   * `std::regex_constants::icase`.
   */
  predicate isIgnoreCase(RegExpTerm root) {
    root.isRootTerm() and
    root.getLiteral().isIgnoreCase()
  }

  /**
   * Holds if `root` has the `s` (dot-all) flag, making `.` match newlines.
   *
   * ECMAScript `std::regex` has no dot-all flag, so this predicate never
   * holds for C++ regexes. It is retained to satisfy the shared
   * `RegexTreeViewSig` signature.
   */
  predicate isDotAll(RegExpTerm root) {
    root.isRootTerm() and
    root.getLiteral().isDotAll()
  }
}

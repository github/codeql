/**
 * Library for parsing for Ruby regular expressions.
 *
 * N.B. does not yet handle stripping whitespace and comments in regexes with
 * the `x` (free-spacing) flag.
 */

private import codeql.ruby.AST as Ast
private import codeql.Locations

/**
 * A `StringlikeLiteral` containing a regular expression term, that is, either
 * a regular expression literal, or a string literal used in a context where
 * it is parsed as regular expression.
 */
abstract class RegExp extends Ast::StringlikeLiteral {
  /**
   * Holds if this `RegExp` has the `s` flag for multi-line matching.
   */
  predicate isDotAll() { none() }

  /**
   * Holds if this `RegExp` has the `i` flag for case-insensitive matching.
   */
  predicate isIgnoreCase() { none() }

  /**
   * Gets the flags for this `RegExp`, or the empty string if it has no flags.
   */
  string getFlags() { result = "" }

  /**
   * Helper predicate for `charSetStart(int start, int end)`.
   *
   * In order to identify left brackets ('[') which actually start a character class,
   * we perform a left to right scan of the string.
   *
   * To avoid negative recursion we return a boolean. See `escaping`,
   * the helper for `escapingChar`, for a clean use of this pattern.
   *
   * result is true for those start chars that actually mark a start of a char set.
   */
  boolean charSetStart(int pos) {
    exists(int index |
      // is opening bracket
      this.charSetDelimiter(index, pos) = true and
      (
        // if this is the first bracket, `pos` starts a char set
        index = 1 and result = true
        or
        // if the previous char set delimiter was not a closing bracket, `pos` does
        // not start a char set. This is needed to handle cases such as `[[]` (a
        // char set that matches the `[` char)
        index > 1 and
        not this.charSetDelimiter(index - 1, _) = false and
        result = false
        or
        // special handling of cases such as `[][]` (the character-set of the characters `]` and `[`).
        exists(int prevClosingBracketPos |
          // previous bracket is a closing bracket
          this.charSetDelimiter(index - 1, prevClosingBracketPos) = false and
          if
            // check if the character that comes before the previous closing bracket
            // is an opening bracket (taking `^` into account)
            // check if the character that comes before the previous closing bracket
            // is an opening bracket (taking `^` into account)
            exists(int posBeforePrevClosingBracket |
              if this.getChar(prevClosingBracketPos - 1) = "^"
              then posBeforePrevClosingBracket = prevClosingBracketPos - 2
              else posBeforePrevClosingBracket = prevClosingBracketPos - 1
            |
              this.charSetDelimiter(index - 2, posBeforePrevClosingBracket) = true
            )
          then
            // brackets without anything in between is not valid character ranges, so
            // the first closing bracket in `[]]` and `[^]]` does not count,
            //
            // and we should _not_ mark the second opening bracket in `[][]` and `[^][]`
            // as starting a new char set.                               ^           ^
            exists(int posBeforePrevClosingBracket |
              this.charSetDelimiter(index - 2, posBeforePrevClosingBracket) = true
            |
              result = this.charSetStart(posBeforePrevClosingBracket).booleanNot()
            )
          else
            // if not, `pos` does in fact mark a real start of a character range
            result = true
        )
      )
    )
  }

  /**
   * Helper predicate for chars that could be character-set delimiters.
   * Holds if the (non-escaped) char at `pos` in the string, is the (one-based) `index` occurrence of a bracket (`[` or `]`) in the string.
   * Result if `true` is the char is `[`, and `false` if the char is `]`.
   */
  boolean charSetDelimiter(int index, int pos) {
    pos =
      rank[index](int p |
        (this.nonEscapedCharAt(p) = "[" or this.nonEscapedCharAt(p) = "]") and
        // Brackets that art part of POSIX expressions should not count as
        // char-set delimiters.
        not exists(int x, int y |
          this.posixStyleNamedCharacterProperty(x, y, _) and pos >= x and pos < y
        )
      ) and
    (
      this.nonEscapedCharAt(pos) = "[" and result = true
      or
      this.nonEscapedCharAt(pos) = "]" and result = false
    )
  }

  /** Holds if a character set starts between `start` and `end`. */
  predicate charSetStart(int start, int end) {
    this.charSetStart(start) = true and
    (
      this.getChar(start + 1) = "^" and end = start + 2
      or
      not this.getChar(start + 1) = "^" and end = start + 1
    )
  }

  /** Whether there is a character class, between start (inclusive) and end (exclusive) */
  predicate charSet(int start, int end) {
    exists(int innerStart, int innerEnd |
      this.charSetStart(start, innerStart) and
      not this.charSetStart(_, start)
    |
      end = innerEnd + 1 and
      innerEnd =
        min(int e |
          e > innerStart and
          this.nonEscapedCharAt(e) = "]" and
          not exists(int x, int y |
            this.posixStyleNamedCharacterProperty(x, y, _) and e >= x and e < y
          )
        |
          e
        )
    )
  }

  /**
   * Holds if the character set starting at `charsetStart` contains either
   * a character or a `-` found between `start` and `end`.
   */
  private predicate charSetToken(int charsetStart, int index, int tokenStart, int tokenEnd) {
    tokenStart =
      rank[index](int start, int end | this.charSetToken(charsetStart, start, end) | start) and
    this.charSetToken(charsetStart, tokenStart, tokenEnd)
  }

  /**
   * Holds if the character set starting at `charsetStart` contains either
   * a character or a `-` found between `start` and `end`.
   */
  private predicate charSetToken(int charsetStart, int start, int end) {
    this.charSetStart(charsetStart, start) and
    (
      this.escapedCharacter(start, end)
      or
      this.namedCharacterProperty(start, end, _)
      or
      exists(this.nonEscapedCharAt(start)) and end = start + 1
    )
    or
    this.charSetToken(charsetStart, _, start) and
    (
      this.escapedCharacter(start, end)
      or
      this.namedCharacterProperty(start, end, _)
      or
      exists(this.nonEscapedCharAt(start)) and
      end = start + 1 and
      not this.getChar(start) = "]"
    )
  }

  /**
   * Holds if the character set starting at `charsetStart` contains either
   * a character or a range found between `start` and `end`.
   */
  predicate charSetChild(int charsetStart, int start, int end) {
    this.charSetToken(charsetStart, start, end) and
    not exists(int rangeStart, int rangeEnd |
      this.charRange(charsetStart, rangeStart, _, _, rangeEnd) and
      rangeStart <= start and
      rangeEnd >= end
    )
    or
    this.charRange(charsetStart, start, _, _, end)
  }

  /**
   * Holds if the character set starting at `charset_start` contains a character range
   * with lower bound found between `start` and `lowerEnd`
   * and upper bound found between `upperStart` and `end`.
   */
  predicate charRange(int charsetStart, int start, int lowerEnd, int upperStart, int end) {
    exists(int index |
      this.charRangeEnd(charsetStart, index) = true and
      this.charSetToken(charsetStart, index - 2, start, lowerEnd) and
      this.charSetToken(charsetStart, index, upperStart, end)
    )
  }

  /**
   * Helper predicate for `charRange`.
   * We can determine where character ranges end by a left to right sweep.
   *
   * To avoid negative recursion we return a boolean. See `escaping`,
   * the helper for `escapingChar`, for a clean use of this pattern.
   */
  private boolean charRangeEnd(int charsetStart, int index) {
    this.charSetToken(charsetStart, index, _, _) and
    (
      index in [1, 2] and result = false
      or
      index > 2 and
      exists(int connectorStart |
        this.charSetToken(charsetStart, index - 1, connectorStart, _) and
        this.nonEscapedCharAt(connectorStart) = "-" and
        result =
          this.charRangeEnd(charsetStart, index - 2)
              .booleanNot()
              .booleanAnd(this.charRangeEnd(charsetStart, index - 1).booleanNot())
      )
      or
      not exists(int connectorStart |
        this.charSetToken(charsetStart, index - 1, connectorStart, _) and
        this.nonEscapedCharAt(connectorStart) = "-"
      ) and
      result = false
    )
  }

  /** Holds if the character at `pos` is a "\" that is actually escaping what comes after. */
  predicate escapingChar(int pos) { this.escaping(pos) = true }

  /**
   * Helper predicate for `escapingChar`.
   * In order to avoid negative recursion, we return a boolean.
   * This way, we can refer to `escaping(pos - 1).booleanNot()`
   * rather than to a negated version of `escaping(pos)`.
   */
  private boolean escaping(int pos) {
    pos = -1 and result = false
    or
    this.getChar(pos) = "\\" and result = this.escaping(pos - 1).booleanNot()
    or
    this.getChar(pos) != "\\" and result = false
  }

  /** Gets the text of this regex */
  string getText() {
    exists(Ast::ConstantValue c | c = this.getConstantValue() |
      result = [this.getConstantValue().getString(), this.getConstantValue().getRegExp()]
    )
  }

  /** Gets the `i`th character of this regex */
  string getChar(int i) { result = this.getText().charAt(i) }

  /** Gets the `i`th character of this regex, unless it is part of a character escape sequence. */
  string nonEscapedCharAt(int i) {
    result = this.getText().charAt(i) and
    not exists(int x, int y | this.escapedCharacter(x, y) and i in [x .. y - 1])
  }

  private predicate isOptionDivider(int i) { this.nonEscapedCharAt(i) = "|" }

  private predicate isGroupEnd(int i) { this.nonEscapedCharAt(i) = ")" and not this.inCharSet(i) }

  private predicate isGroupStart(int i) { this.nonEscapedCharAt(i) = "(" and not this.inCharSet(i) }

  /**
   * Holds if the `i`th character could not be parsed.
   */
  predicate failedToParse(int i) {
    exists(this.getChar(i)) and
    not exists(int start, int end |
      this.topLevel(start, end) and
      start <= i and
      end > i
    )
  }

  /** Matches named character properties such as `\p{Word}` and `[[:digit:]]` */
  predicate namedCharacterProperty(int start, int end, string name) {
    this.pStyleNamedCharacterProperty(start, end, name) or
    this.posixStyleNamedCharacterProperty(start, end, name)
  }

  /** Gets the name of the character property in start,end */
  string getCharacterPropertyName(int start, int end) {
    this.namedCharacterProperty(start, end, result)
  }

  /** Matches a POSIX bracket expression such as `[:alnum:]` within a character class. */
  private predicate posixStyleNamedCharacterProperty(int start, int end, string name) {
    this.getChar(start) = "[" and
    this.getChar(start + 1) = ":" and
    end =
      min(int e |
        e > start and
        this.getChar(e - 2) = ":" and
        this.getChar(e - 1) = "]"
      |
        e
      ) and
    exists(int nameStart |
      this.getChar(start + 2) = "^" and nameStart = start + 3
      or
      not this.getChar(start + 2) = "^" and nameStart = start + 2
    |
      name = this.getText().substring(nameStart, end - 2)
    )
  }

  /**
   * Matches named character properties. For example:
   * - `\p{Space}`
   * - `\P{Digit}` upper-case P means inverted
   * - `\p{^Word}` caret also means inverted
   *
   * These can occur both inside and outside of character classes.
   */
  private predicate pStyleNamedCharacterProperty(int start, int end, string name) {
    this.escapingChar(start) and
    this.getChar(start + 1) in ["p", "P"] and
    this.getChar(start + 2) = "{" and
    this.getChar(end - 1) = "}" and
    end > start and
    not exists(int i | start + 2 < i and i < end - 1 | this.getChar(i) = "}") and
    exists(int nameStart |
      this.getChar(start + 3) = "^" and nameStart = start + 4
      or
      not this.getChar(start + 3) = "^" and nameStart = start + 3
    |
      name = this.getText().substring(nameStart, end - 1)
    )
  }

  /**
   * Holds if the named character property is inverted. Examples for which it holds:
   * - `\P{Digit}` upper-case P means inverted
   * - `\p{^Word}` caret also means inverted
   * - `[[:^digit:]]`
   *
   * Examples for which it doesn't hold:
   * - `\p{Word}`
   * - `\P{^Space}` - upper-case P and caret cancel each other out
   * - `[[:alnum:]]`
   */
  predicate namedCharacterPropertyIsInverted(int start, int end) {
    this.pStyleNamedCharacterProperty(start, end, _) and
    exists(boolean upperP, boolean caret |
      (if this.getChar(start + 1) = "P" then upperP = true else upperP = false) and
      (if this.getChar(start + 3) = "^" then caret = true else caret = false)
    |
      upperP.booleanXor(caret) = true
    )
    or
    this.posixStyleNamedCharacterProperty(start, end, _) and
    this.getChar(start + 3) = "^"
  }

  /**
   * Holds if an escaped character is found between `start` and `end`.
   * Escaped characters include hex values, octal values and named escapes,
   * but excludes backreferences.
   */
  predicate escapedCharacter(int start, int end) {
    this.escapingChar(start) and
    not this.numberedBackreference(start, _, _) and
    not this.namedBackreference(start, _, _) and
    not this.pStyleNamedCharacterProperty(start, _, _) and
    (
      // hex char \xhh
      this.getChar(start + 1) = "x" and end = start + 4
      or
      // wide hex char \uhhhh
      this.getChar(start + 1) = "u" and end = start + 6
      or
      // escape not handled above; update when adding a new case
      not this.getChar(start + 1) in ["x", "u"] and
      not exists(this.getChar(start + 1).toInt()) and
      end = start + 2
    )
  }

  /**
   * Holds if the character at `index` is inside a character set.
   */
  predicate inCharSet(int index) {
    exists(int x, int y | this.charSet(x, y) and index in [x + 1 .. y - 2])
  }

  /**
   * Holds if the character at `index` is inside a posix bracket.
   */
  predicate inPosixBracket(int index) {
    exists(int x, int y |
      this.posixStyleNamedCharacterProperty(x, y, _) and index in [x + 1 .. y - 2]
    )
  }

  /**
   * 'simple' characters are any that don't alter the parsing of the regex.
   */
  private predicate simpleCharacter(int start, int end) {
    end = start + 1 and
    not this.charSet(start, _) and
    not this.charSet(_, start + 1) and
    not exists(int x, int y |
      this.posixStyleNamedCharacterProperty(x, y, _) and
      start >= x and
      end <= y
    ) and
    exists(string c | c = this.getChar(start) |
      exists(int x, int y, int z |
        this.charSet(x, z) and
        this.charSetStart(x, y)
      |
        start = y
        or
        start = z - 2
        or
        start > y and start < z - 2 and not this.charRange(_, _, start, end, _)
      )
      or
      not this.inCharSet(start) and
      not c = "(" and
      not c = "[" and
      not c = ")" and
      not c = "|" and
      not this.qualifier(start, _, _, _)
    )
  }

  /**
   * Holds if a simple or escaped character is found between `start` and `end`.
   */
  predicate character(int start, int end) {
    (
      this.simpleCharacter(start, end) and
      not exists(int x, int y | this.escapedCharacter(x, y) and x <= start and y >= end)
      or
      this.escapedCharacter(start, end)
    ) and
    not exists(int x, int y | this.groupStart(x, y) and x <= start and y >= end) and
    not exists(int x, int y | this.backreference(x, y) and x <= start and y >= end) and
    not exists(int x, int y |
      this.pStyleNamedCharacterProperty(x, y, _) and x <= start and y >= end
    ) and
    not exists(int x, int y | this.multiples(x, y, _, _) and x <= start and y >= end)
  }

  /**
   * Holds if a normal character is found between `start` and `end`.
   */
  predicate normalCharacter(int start, int end) {
    end = start + 1 and
    this.character(start, end) and
    not this.specialCharacter(start, end, _)
  }

  /**
   * Holds if a special character is found between `start` and `end`.
   */
  predicate specialCharacter(int start, int end, string char) {
    this.character(start, end) and
    not this.inCharSet(start) and
    (
      end = start + 1 and
      char = this.getChar(start) and
      (char = "$" or char = "^" or char = ".")
      or
      end = start + 2 and
      this.escapingChar(start) and
      char = this.getText().substring(start, end) and
      char = ["\\A", "\\Z", "\\z", "\\G", "\\b", "\\B"]
    )
  }

  /**
   * Holds if the range [start:end) consists of only 'normal' characters.
   */
  predicate normalCharacterSequence(int start, int end) {
    // a normal character inside a character set is interpreted on its own
    this.normalCharacter(start, end) and
    this.inCharSet(start)
    or
    // a maximal run of normal characters is considered as one constant
    exists(int s, int e |
      e = max(int i | this.normalCharacterRun(s, i)) and
      not this.inCharSet(s)
    |
      // 'abc' can be considered one constant, but
      // 'abc+' has to be broken up into 'ab' and 'c+',
      // as the qualifier only applies to 'c'.
      if this.qualifier(e, _, _, _)
      then
        end = e and start = e - 1
        or
        end = e - 1 and start = s and start < end
      else (
        end = e and
        start = s
      )
    )
  }

  private predicate normalCharacterRun(int start, int end) {
    (
      this.normalCharacterRun(start, end - 1)
      or
      start = end - 1 and not this.normalCharacter(start - 1, start)
    ) and
    this.normalCharacter(end - 1, end)
  }

  private predicate characterItem(int start, int end) {
    this.normalCharacterSequence(start, end) or
    this.escapedCharacter(start, end) or
    this.specialCharacter(start, end, _)
  }

  /** Whether the text in the range `start,end` is a group */
  predicate group(int start, int end) {
    this.groupContents(start, end, _, _)
    or
    this.emptyGroup(start, end)
  }

  /** Gets the number of the group in start,end */
  int getGroupNumber(int start, int end) {
    this.group(start, end) and
    not this.nonCapturingGroupStart(start, _) and
    result =
      count(int i | this.group(i, _) and i < start and not this.nonCapturingGroupStart(i, _)) + 1
  }

  /** Gets the name, if it has one, of the group in start,end */
  string getGroupName(int start, int end) {
    this.group(start, end) and
    exists(int nameEnd |
      this.namedGroupStart(start, nameEnd) and
      result = this.getText().substring(start + 3, nameEnd - 1)
    )
  }

  /** Whether the text in the range start, end is a group and can match the empty string. */
  predicate zeroWidthMatch(int start, int end) {
    this.emptyGroup(start, end)
    or
    this.negativeAssertionGroup(start, end)
    or
    this.positiveLookaheadAssertionGroup(start, end)
    or
    this.positiveLookbehindAssertionGroup(start, end)
  }

  /** Holds if an empty group is found between `start` and `end`. */
  predicate emptyGroup(int start, int end) {
    exists(int endm1 | end = endm1 + 1 |
      this.groupStart(start, endm1) and
      this.isGroupEnd(endm1)
    )
  }

  private predicate emptyMatchAtStartGroup(int start, int end) {
    this.emptyGroup(start, end)
    or
    this.negativeAssertionGroup(start, end)
    or
    this.positiveLookaheadAssertionGroup(start, end)
  }

  private predicate emptyMatchAtEndGroup(int start, int end) {
    this.emptyGroup(start, end)
    or
    this.negativeAssertionGroup(start, end)
    or
    this.positiveLookbehindAssertionGroup(start, end)
  }

  private predicate negativeAssertionGroup(int start, int end) {
    exists(int inStart |
      this.negativeLookaheadAssertionStart(start, inStart)
      or
      this.negativeLookbehindAssertionStart(start, inStart)
    |
      this.groupContents(start, end, inStart, _)
    )
  }

  /** Holds if a negative lookahead is found between `start` and `end` */
  predicate negativeLookaheadAssertionGroup(int start, int end) {
    exists(int inStart | this.negativeLookaheadAssertionStart(start, inStart) |
      this.groupContents(start, end, inStart, _)
    )
  }

  /** Holds if a negative lookbehind is found between `start` and `end` */
  predicate negativeLookbehindAssertionGroup(int start, int end) {
    exists(int inStart | this.negativeLookbehindAssertionStart(start, inStart) |
      this.groupContents(start, end, inStart, _)
    )
  }

  /** Holds if a positive lookahead is found between `start` and `end` */
  predicate positiveLookaheadAssertionGroup(int start, int end) {
    exists(int inStart | this.lookaheadAssertionStart(start, inStart) |
      this.groupContents(start, end, inStart, _)
    )
  }

  /** Holds if a positive lookbehind is found between `start` and `end` */
  predicate positiveLookbehindAssertionGroup(int start, int end) {
    exists(int inStart | this.lookbehindAssertionStart(start, inStart) |
      this.groupContents(start, end, inStart, _)
    )
  }

  private predicate groupStart(int start, int end) {
    this.nonCapturingGroupStart(start, end)
    or
    this.namedGroupStart(start, end)
    or
    this.lookaheadAssertionStart(start, end)
    or
    this.negativeLookaheadAssertionStart(start, end)
    or
    this.lookbehindAssertionStart(start, end)
    or
    this.negativeLookbehindAssertionStart(start, end)
    or
    this.commentGroupStart(start, end)
    or
    this.simpleGroupStart(start, end)
  }

  /** Matches the start of a non-capturing group, e.g. `(?:` */
  private predicate nonCapturingGroupStart(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = [":", "=", "<", "!", "#"] and
    end = start + 3
  }

  /** Matches the start of a simple group, e.g. `(a+)`. */
  private predicate simpleGroupStart(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) != "?" and
    end = start + 1
  }

  /**
   * Matches the start of a named group, such as:
   * - `(?<name>\w+)`
   * - `(?'name'\w+)`
   */
  private predicate namedGroupStart(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    (
      this.getChar(start + 2) = "<" and
      not this.getChar(start + 3) = "=" and // (?<=foo) is a positive lookbehind assertion
      not this.getChar(start + 3) = "!" and // (?<!foo) is a negative lookbehind assertion
      exists(int nameEnd |
        nameEnd = min(int i | i > start + 3 and this.getChar(i) = ">") and
        end = nameEnd + 1
      )
      or
      this.getChar(start + 2) = "'" and
      exists(int nameEnd |
        nameEnd = min(int i | i > start + 2 and this.getChar(i) = "'") and end = nameEnd + 1
      )
    )
  }

  /** Matches the start of a positive lookahead assertion, i.e. `(?=`. */
  private predicate lookaheadAssertionStart(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "=" and
    end = start + 3
  }

  /** Matches the start of a negative lookahead assertion, i.e. `(?!`. */
  private predicate negativeLookaheadAssertionStart(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "!" and
    end = start + 3
  }

  /** Matches the start of a positive lookbehind assertion, i.e. `(?<=`. */
  private predicate lookbehindAssertionStart(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "<" and
    this.getChar(start + 3) = "=" and
    end = start + 4
  }

  /** Matches the start of a negative lookbehind assertion, i.e. `(?<!`. */
  private predicate negativeLookbehindAssertionStart(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "<" and
    this.getChar(start + 3) = "!" and
    end = start + 4
  }

  /** Matches the start of a comment group, i.e. `(?#`. */
  private predicate commentGroupStart(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "#" and
    end = start + 3
  }

  /** Matches the contents of a group. */
  predicate groupContents(int start, int end, int inStart, int inEnd) {
    this.groupStart(start, inStart) and
    end = inEnd + 1 and
    this.topLevel(inStart, inEnd) and
    this.isGroupEnd(inEnd)
  }

  /** Matches a named backreference, e.g. `\k<foo>`. */
  predicate namedBackreference(int start, int end, string name) {
    this.escapingChar(start) and
    this.getChar(start + 1) = "k" and
    this.getChar(start + 2) = "<" and
    exists(int nameEnd | nameEnd = min(int i | i > start + 3 and this.getChar(i) = ">") |
      end = nameEnd + 1 and
      name = this.getText().substring(start + 3, nameEnd)
    )
  }

  /** Matches a numbered backreference, e.g. `\1`. */
  predicate numberedBackreference(int start, int end, int value) {
    this.escapingChar(start) and
    not this.getChar(start + 1) = "0" and
    exists(string text, string svalue, int len |
      end = start + len and
      text = this.getText() and
      len in [2 .. 3]
    |
      svalue = text.substring(start + 1, start + len) and
      value = svalue.toInt() and
      not exists(text.substring(start + 1, start + len + 1).toInt()) and
      value > 0
    )
  }

  /** Whether the text in the range `start,end` is a back reference */
  predicate backreference(int start, int end) {
    this.numberedBackreference(start, end, _)
    or
    this.namedBackreference(start, end, _)
  }

  /** Gets the number of the back reference in start,end */
  int getBackRefNumber(int start, int end) { this.numberedBackreference(start, end, result) }

  /** Gets the name, if it has one, of the back reference in start,end */
  string getBackRefName(int start, int end) { this.namedBackreference(start, end, result) }

  private predicate baseItem(int start, int end) {
    this.characterItem(start, end) and
    not exists(int x, int y | this.charSet(x, y) and x <= start and y >= end)
    or
    this.group(start, end)
    or
    this.charSet(start, end)
    or
    this.backreference(start, end)
    or
    this.pStyleNamedCharacterProperty(start, end, _)
  }

  private predicate qualifier(int start, int end, boolean maybeEmpty, boolean mayRepeatForever) {
    this.shortQualifier(start, end, maybeEmpty, mayRepeatForever) and
    not this.getChar(end) = "?"
    or
    exists(int shortEnd | this.shortQualifier(start, shortEnd, maybeEmpty, mayRepeatForever) |
      if this.getChar(shortEnd) = "?" then end = shortEnd + 1 else end = shortEnd
    )
  }

  private predicate shortQualifier(int start, int end, boolean maybeEmpty, boolean mayRepeatForever) {
    (
      this.getChar(start) = "+" and maybeEmpty = false and mayRepeatForever = true
      or
      this.getChar(start) = "*" and maybeEmpty = true and mayRepeatForever = true
      or
      this.getChar(start) = "?" and maybeEmpty = true and mayRepeatForever = false
    ) and
    end = start + 1
    or
    exists(string lower, string upper |
      this.multiples(start, end, lower, upper) and
      (if lower = "" or lower.toInt() = 0 then maybeEmpty = true else maybeEmpty = false) and
      if upper = "" then mayRepeatForever = true else mayRepeatForever = false
    )
  }

  /**
   * Holds if a repetition quantifier is found between `start` and `end`,
   * with the given lower and upper bounds. If a bound is omitted, the corresponding
   * string is empty.
   */
  predicate multiples(int start, int end, string lower, string upper) {
    exists(string text, string match, string inner |
      text = this.getText() and
      end = start + match.length() and
      inner = match.substring(1, match.length() - 1)
    |
      match = text.regexpFind("\\{[0-9]+\\}", _, start) and
      lower = inner and
      upper = lower
      or
      match = text.regexpFind("\\{[0-9]*,[0-9]*\\}", _, start) and
      exists(int commaIndex |
        commaIndex = inner.indexOf(",") and
        lower = inner.prefix(commaIndex) and
        upper = inner.suffix(commaIndex + 1)
      )
    )
  }

  /**
   * Whether the text in the range start,end is a qualified item, where item is a character,
   * a character set or a group.
   */
  predicate qualifiedItem(int start, int end, boolean maybeEmpty, boolean mayRepeatForever) {
    this.qualifiedPart(start, _, end, maybeEmpty, mayRepeatForever)
  }

  /**
   * Holds if a qualified part is found between `start` and `partEnd` and the qualifier is
   * found between `partEnd` and `end`.
   *
   * `maybeEmpty` is true if the part is optional.
   * `mayRepeatForever` is true if the part may be repeated unboundedly.
   */
  predicate qualifiedPart(
    int start, int partEnd, int end, boolean maybeEmpty, boolean mayRepeatForever
  ) {
    this.baseItem(start, partEnd) and
    this.qualifier(partEnd, end, maybeEmpty, mayRepeatForever)
  }

  /** Holds if the range `start`, `end` contains a character, a quantifier, a character set or a group. */
  predicate item(int start, int end) {
    this.qualifiedItem(start, end, _, _)
    or
    this.baseItem(start, end) and not this.qualifier(end, _, _, _)
  }

  private predicate subsequence(int start, int end) {
    (
      start = 0 or
      this.groupStart(_, start) or
      this.isOptionDivider(start - 1)
    ) and
    this.item(start, end)
    or
    exists(int mid |
      this.subsequence(start, mid) and
      this.item(mid, end)
    )
  }

  /**
   * Whether the text in the range start,end is a sequence of 1 or more items, where an item is a character,
   * a character set or a group.
   */
  predicate sequence(int start, int end) {
    this.sequenceOrQualified(start, end) and
    not this.qualifiedItem(start, end, _, _)
  }

  private predicate sequenceOrQualified(int start, int end) {
    this.subsequence(start, end) and
    not this.itemStart(end)
  }

  private predicate itemStart(int start) {
    this.characterItem(start, _) or
    this.isGroupStart(start) or
    this.charSet(start, _) or
    this.backreference(start, _) or
    this.namedCharacterProperty(start, _, _)
  }

  private predicate itemEnd(int end) {
    this.characterItem(_, end)
    or
    exists(int endm1 | this.isGroupEnd(endm1) and end = endm1 + 1)
    or
    this.charSet(_, end)
    or
    this.qualifier(_, end, _, _)
  }

  private predicate topLevel(int start, int end) {
    this.subalternation(start, end, _) and
    not this.isOptionDivider(end)
  }

  private predicate subalternation(int start, int end, int itemStart) {
    this.sequenceOrQualified(start, end) and
    not this.isOptionDivider(start - 1) and
    itemStart = start
    or
    start = end and
    not this.itemEnd(start) and
    this.isOptionDivider(end) and
    itemStart = start
    or
    exists(int mid |
      this.subalternation(start, mid, _) and
      this.isOptionDivider(mid) and
      itemStart = mid + 1
    |
      this.sequenceOrQualified(itemStart, end)
      or
      not this.itemStart(end) and end = itemStart
    )
  }

  /**
   * Whether the text in the range start,end is an alternation
   */
  predicate alternation(int start, int end) {
    not this.inCharSet(start) and
    this.topLevel(start, end) and
    exists(int less | this.subalternation(start, less, _) and less < end)
  }

  /**
   * Whether the text in the range start,end is an alternation and the text in partStart, partEnd is one of the
   * options in that alternation.
   */
  predicate alternationOption(int start, int end, int partStart, int partEnd) {
    this.alternation(start, end) and
    this.subalternation(start, partEnd, partStart)
  }

  /** A part of the regex that may match the start of the string. */
  private predicate firstPart(int start, int end) {
    start = 0 and end = this.getText().length()
    or
    exists(int x | this.firstPart(x, end) |
      this.emptyMatchAtStartGroup(x, start)
      or
      this.qualifiedItem(x, start, true, _)
      or
      // ^ and \A match the start of the string
      this.specialCharacter(x, start, ["^", "\\A"])
    )
    or
    exists(int y | this.firstPart(start, y) |
      this.item(start, end)
      or
      this.qualifiedPart(start, end, y, _, _)
    )
    or
    exists(int x, int y | this.firstPart(x, y) |
      this.groupContents(x, y, start, end)
      or
      this.alternationOption(x, y, start, end)
    )
  }

  /** A part of the regex that may match the end of the string. */
  private predicate lastPart(int start, int end) {
    start = 0 and end = this.getText().length()
    or
    exists(int y | this.lastPart(start, y) |
      this.emptyMatchAtEndGroup(end, y)
      or
      this.qualifiedItem(end, y, true, _)
      or
      // $, \Z, and \z match the end of the string.
      this.specialCharacter(end, y, ["$", "\\Z", "\\z"])
    )
    or
    this.lastPart(_, end) and
    this.item(start, end)
    or
    exists(int y | this.lastPart(start, y) | this.qualifiedPart(start, end, y, _, _))
    or
    exists(int x, int y | this.lastPart(x, y) |
      this.groupContents(x, y, start, end)
      or
      this.alternationOption(x, y, start, end)
    )
  }

  /**
   * Whether the item at [start, end) is one of the first items
   * to be matched.
   */
  predicate firstItem(int start, int end) {
    (
      this.characterItem(start, end)
      or
      this.qualifiedItem(start, end, _, _)
      or
      this.charSet(start, end)
    ) and
    this.firstPart(start, end)
  }

  /**
   * Whether the item at [start, end) is one of the last items
   * to be matched.
   */
  predicate lastItem(int start, int end) {
    (
      this.characterItem(start, end)
      or
      this.qualifiedItem(start, end, _, _)
      or
      this.charSet(start, end)
    ) and
    this.lastPart(start, end)
  }
}

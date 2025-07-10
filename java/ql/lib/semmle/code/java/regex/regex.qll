/**
 * Definitions for parsing regular expressions.
 */

import java
private import RegexFlowConfigs

// In all ranges handled by this library, `start` is inclusive and `end` is exclusive.
/**
 * A string literal that is used as a regular expression.
 */
abstract class RegexString extends StringLiteral {
  /** Gets the text of this regex */
  string getText() { result = this.(StringLiteral).getValue() }

  /** Gets the `i`th character of this regex. */
  string getChar(int i) { result = this.getText().charAt(i) }

  /** Holds if the regex failed to parse. */
  predicate failedToParse(int i) {
    exists(this.getChar(i)) and
    not exists(int start, int end |
      this.topLevel(start, end) and
      start <= i and
      end > i
    )
  }

  /**
   * Helper predicate for `escapingChar`.
   * In order to avoid negative recursion, we return a boolean.
   * This way, we can refer to `escaping(pos - 1).booleanNot()`
   * rather than to a negated version of `escaping(pos)`.
   */
  private boolean escaping(int pos) {
    pos = -1 and result = false
    or
    this.getChar(pos) = "\\" and
    (
      if this.getChar(pos - 1) = "c" //  in `\c\`, the latter `\` isn't escaping
      then result = this.escaping(pos - 2).booleanNot()
      else result = this.escaping(pos - 1).booleanNot()
    )
    or
    this.getChar(pos) != "\\" and result = false
  }

  /**
   * Helper predicate for `quote`.
   * Holds if the char at `pos` could be the beginning of a quote delimiter, i.e. `\Q` (non-escaped) or `\E` (escaping not checked, as quote sequences turn off escapes).
   * Result is `true` for `\Q` and `false` for `\E`.
   */
  private boolean quoteDelimiter(int pos) {
    result = true and
    this.escaping(pos) = true and
    this.getChar(pos + 1) = "Q"
    or
    result = false and
    this.getChar(pos) = "\\" and
    this.getChar(pos + 1) = "E"
  }

  /**
   * Helper predicate for `quote`.
   * Holds if the char at `pos` is the one-based `index`th occurrence of a quote delimiter (`\Q` or `\E`)
   * Result is `true` for `\Q` and `false` for `\E`.
   */
  private boolean quoteDelimiter(int index, int pos) {
    result = this.quoteDelimiter(pos) and
    pos = rank[index](int p | exists(this.quoteDelimiter(p)))
  }

  /** Holds if a quoted sequence is found between `start` and `end` */
  predicate quote(int start, int end) { this.quote(start, end, _, _) }

  /** Holds if a quoted sequence is found between `start` and `end`, with content found between `inner_start` and `inner_end`. */
  predicate quote(int start, int end, int inner_start, int inner_end) {
    exists(int index |
      this.quoteDelimiter(index, start) = true and
      (
        index = 1
        or
        this.quoteDelimiter(index - 1, _) = false
      ) and
      inner_start = start + 2 and
      inner_end = end - 2 and
      inner_end =
        min(int end_delimiter |
          this.quoteDelimiter(end_delimiter) = false and end_delimiter > inner_start
        )
    )
  }

  /** Holds if the character at `pos` is a "\" that is actually escaping what comes after. */
  predicate escapingChar(int pos) {
    this.escaping(pos) = true and
    not exists(int x, int y | this.quote(x, y) and pos in [x .. y - 1])
  }

  /**
   * Holds if there is a control sequence, `\cx`, between `start` and `end`.
   * `x` may be any ascii character including special characters.
   */
  predicate controlEscape(int start, int end) {
    this.escapingChar(start) and
    this.getChar(start + 1) = "c" and
    end = start + 3
  }

  private predicate namedBackreference(int start, int end, string name) {
    this.escapingChar(start) and
    this.getChar(start + 1) = "k" and
    this.getChar(start + 2) = "<" and
    end = min(int i | i > start + 2 and this.getChar(i) = ">") + 1 and
    name = this.getText().substring(start + 3, end - 1)
  }

  private predicate numberedBackreference(int start, int end, int value) {
    this.escapingChar(start) and
    // starting with 0 makes it an octal escape
    not this.getChar(start + 1) = "0" and
    exists(string text, string svalue, int len |
      end = start + len and
      text = this.getText() and
      len in [2 .. 3]
    |
      svalue = text.substring(start + 1, start + len) and
      value = svalue.toInt() and
      // value is composed of digits
      forall(int i | i in [start + 1 .. start + len - 1] | this.getChar(i) = [0 .. 9].toString()) and
      // a longer reference is not possible
      not (
        len = 2 and
        exists(text.substring(start + 1, start + len + 1).toInt())
      ) and
      // 3 octal digits makes it an octal escape
      not forall(int i | i in [start + 1 .. start + 4] | this.isOctal(i))
      // TODO: Inside a character set, all numeric escapes are treated as characters.
    )
  }

  /** Holds if the text in the range start,end is a back reference */
  predicate backreference(int start, int end) {
    this.numberedBackreference(start, end, _)
    or
    this.namedBackreference(start, end, _)
  }

  /** Gets the number of the back reference in start,end */
  int getBackrefNumber(int start, int end) { this.numberedBackreference(start, end, result) }

  /** Gets the name, if it has one, of the back reference in start,end */
  string getBackrefName(int start, int end) { this.namedBackreference(start, end, result) }

  pragma[inline]
  private predicate isOctal(int index) { this.getChar(index) = [0 .. 7].toString() }

  /** An escape sequence that includes braces, such as named characters (\N{degree sign}), named classes (\p{Lower}), or hex values (\x{h..h}) */
  private predicate escapedBraces(int start, int end) {
    this.escapingChar(start) and
    this.getChar(start + 1) = ["N", "p", "P", "x"] and
    this.getChar(start + 2) = "{" and
    end = min(int i | start + 2 < i and this.getChar(i - 1) = "}")
  }

  /**
   * Holds if an escaped character is found between `start` and `end`.
   * Escaped characters include hex values, octal values and named escapes,
   * but excludes backreferences.
   */
  predicate escapedCharacter(int start, int end) {
    this.escapingChar(start) and
    not this.backreference(start, _) and
    (
      // hex value \xhh
      this.getChar(start + 1) = "x" and
      this.getChar(start + 2) != "{" and
      end = start + 4
      or
      // octal value \0o, \0oo, or \0ooo. Max of 0377.
      this.getChar(start + 1) = "0" and
      this.isOctal(start + 2) and
      (
        if this.isOctal(start + 3)
        then
          if this.isOctal(start + 4) and this.getChar(start + 2) in ["0", "1", "2", "3"]
          then end = start + 5
          else end = start + 4
        else end = start + 3
      )
      or
      // 16-bit hex value \uhhhh
      this.getChar(start + 1) = "u" and end = start + 6
      or
      this.escapedBraces(start, end)
      or
      // Boundary matchers \b, \b{g}
      this.getChar(start + 1) = "b" and
      (
        if this.getText().substring(start + 2, start + 5) = "{g}"
        then end = start + 5
        else end = start + 2
      )
      or
      this.controlEscape(start, end)
      or
      // escape not handled above, update when adding a new case
      not this.getChar(start + 1) in ["x", "0", "u", "p", "P", "N", "b", "c"] and
      not exists(this.getChar(start + 1).toInt()) and
      end = start + 2
    )
  }

  private string nonEscapedCharAt(int i) {
    result = this.getChar(i) and
    not exists(int x, int y | this.escapedCharacter(x, y) and i in [x .. y - 1]) and
    not exists(int x, int y | this.quote(x, y) and i in [x .. y - 1])
  }

  /** Holds if a character set starts between `start` and `end`, including any negation character (`^`). */
  private predicate charSetStart0(int start, int end) {
    this.nonEscapedCharAt(start) = "[" and
    (if this.getChar(start + 1) = "^" then end = start + 2 else end = start + 1)
  }

  /** Holds if the character at `pos` marks the end of a character class. */
  private predicate charSetEnd0(int pos) {
    this.nonEscapedCharAt(pos) = "]" and
    /* special case: `[]]` and `[^]]` are valid char classes.  */
    not this.charSetStart0(_, pos)
  }

  /**
   * Holds if the character at `pos` starts a character set delimiter.
   * Result is 1 for `[` and -1 for `]`.
   */
  private int charSetDelimiter(int pos) {
    result = 1 and this.charSetStart0(pos, _)
    or
    result = -1 and this.charSetEnd0(pos)
  }

  /**
   * Holds if the char at `pos` is the one-based `index`th occourence of a character set delimiter (`[` or `]`).
   * Result is 1 for `[` and -1 for `]`.
   */
  private int charSetDelimiter(int index, int pos) {
    result = this.charSetDelimiter(pos) and
    pos = rank[index](int p | exists(this.charSetDelimiter(p)))
  }

  /**
   * Gets the nesting depth of character classes after position `pos`,
   * where `pos` is the position of a character set delimiter.
   */
  private int charSetDepth(int index, int pos) {
    index = 1 and result = 0.maximum(this.charSetDelimiter(index, pos))
    or
    result = 0.maximum(this.charSetDelimiter(index, pos) + this.charSetDepth(index - 1, _))
  }

  /** Hold if a top-level character set starts between `start` and `end`. */
  predicate charSetStart(int start, int end) {
    this.charSetStart0(start, end) and
    this.charSetDepth(_, start) = 1
  }

  /** Holds if a top-level character set ends at `pos`. */
  predicate charSetEnd(int pos) {
    this.charSetEnd0(pos) and
    this.charSetDepth(_, pos) = 0
  }

  /**
   * Holds if there is a top-level character class beginning at `start` (inclusive) and ending at `end` (exclusive)
   *
   * For now, nested character classes are approximated by only considering the top-level class for parsing.
   * This leads to very similar results for ReDoS queries.
   */
  predicate charSet(int start, int end) {
    exists(int inner_start, int inner_end | this.charSetStart(start, inner_start) |
      end = inner_end + 1 and
      inner_end =
        min(int end_delimiter | this.charSetEnd(end_delimiter) and end_delimiter > inner_start)
    )
  }

  /** Either a char or a - */
  private predicate charSetToken(int charset_start, int start, int end) {
    this.charSetStart(charset_start, start) and
    (
      this.escapedCharacter(start, end)
      or
      exists(this.nonEscapedCharAt(start)) and end = start + 1
      or
      this.quote(start, end)
    )
    or
    this.charSetToken(charset_start, _, start) and
    (
      this.escapedCharacter(start, end)
      or
      exists(this.nonEscapedCharAt(start)) and
      end = start + 1 and
      not this.charSetEnd(start)
      or
      this.quote(start, end)
    )
  }

  /** An indexed version of `charSetToken/3` */
  private predicate charSetToken(int charset_start, int index, int token_start, int token_end) {
    token_start = rank[index](int start | this.charSetToken(charset_start, start, _) | start) and
    this.charSetToken(charset_start, token_start, token_end)
  }

  /**
   * Helper predicate for `charRange`.
   * We can determine where character ranges end by a left to right sweep.
   *
   * To avoid negative recursion we return a boolean. See `escaping`,
   * the helper for `escapingChar`, for a clean use of this pattern.
   */
  private boolean charRangeEnd(int charset_start, int index) {
    this.charSetToken(charset_start, index, _, _) and
    (
      index in [1, 2] and result = false
      or
      index > 2 and
      exists(int connector_start |
        this.charSetToken(charset_start, index - 1, connector_start, _) and
        this.nonEscapedCharAt(connector_start) = "-" and
        result =
          this.charRangeEnd(charset_start, index - 2)
              .booleanNot()
              .booleanAnd(this.charRangeEnd(charset_start, index - 1).booleanNot())
      )
      or
      not exists(int connector_start |
        this.charSetToken(charset_start, index - 1, connector_start, _) and
        this.nonEscapedCharAt(connector_start) = "-"
      ) and
      result = false
    )
  }

  /**
   * Holds if the character set starting at `charset_start` contains a character range
   * with lower bound found between `start` and `lower_end`
   * and upper bound found between `upper_start` and `end`.
   */
  predicate charRange(int charset_start, int start, int lower_end, int upper_start, int end) {
    exists(int index |
      this.charRangeEnd(charset_start, index) = true and
      this.charSetToken(charset_start, index - 2, start, lower_end) and
      this.charSetToken(charset_start, index, upper_start, end)
    )
  }

  /**
   * Holds if the character set starting at `charset_start` contains either
   * a character or a range found between `start` and `end`.
   */
  predicate charSetChild(int charset_start, int start, int end) {
    this.charSetToken(charset_start, start, end) and
    not exists(int range_start, int range_end |
      this.charRange(charset_start, range_start, _, _, range_end) and
      range_start <= start and
      range_end >= end
    )
    or
    this.charRange(charset_start, start, _, _, end)
  }

  /** Holds if `index` is inside a character set. */
  predicate inCharSet(int index) {
    exists(int x, int y | this.charSet(x, y) and index in [x + 1 .. y - 2])
  }

  /**
   * 'simple' characters are any that don't alter the parsing of the regex.
   */
  private predicate simpleCharacter(int start, int end) {
    end = start + 1 and
    not this.charSet(start, _) and
    not this.charSet(_, start + 1) and
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
      not c = "{" and
      not exists(int qstart, int qend | this.quantifier(qstart, qend, _, _) |
        qstart <= start and start < qend
      )
    )
  }

  private predicate character(int start, int end) {
    (
      this.simpleCharacter(start, end) and
      not exists(int x, int y | this.escapedCharacter(x, y) and x <= start and y >= end) and
      not exists(int x, int y | this.quote(x, y) and x <= start and y >= end)
      or
      this.escapedCharacter(start, end)
    ) and
    not exists(int x, int y | this.groupStart(x, y) and x <= start and y >= end) and
    not exists(int x, int y | this.backreference(x, y) and x <= start and y >= end)
  }

  /** Holds if a normal character or escape sequence is between `start` and `end`. */
  predicate normalCharacter(int start, int end) {
    this.character(start, end) and
    not this.specialCharacter(start, end, _)
  }

  /** Holds if a special character `char` is between `start` and `end`. */
  predicate specialCharacter(int start, int end, string char) {
    this.character(start, end) and
    end = start + 1 and
    char = this.getChar(start) and
    (char = "$" or char = "^" or char = ".") and
    not this.inCharSet(start)
  }

  private predicate isGroupEnd(int i) { this.nonEscapedCharAt(i) = ")" and not this.inCharSet(i) }

  private predicate isGroupStart(int i) { this.nonEscapedCharAt(i) = "(" and not this.inCharSet(i) }

  /** Holds if an empty group is found between `start` and `end`. */
  predicate emptyGroup(int start, int end) {
    exists(int endm1 | end = endm1 + 1 |
      this.groupStart(start, endm1) and
      this.isGroupEnd(endm1)
    )
  }

  private predicate nonCapturingGroupStart(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = ":" and
    end = start + 3
  }

  private predicate simpleGroupStart(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) != "?" and
    end = start + 1
  }

  private predicate namedGroupStart(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "<" and
    not this.getChar(start + 3) = "=" and
    not this.getChar(start + 3) = "!" and
    exists(int name_end |
      name_end = min(int i | i > start + 3 and this.getChar(i) = ">") and
      end = name_end + 1
    )
  }

  /**
   * Holds if the initial part of a parse mode, not containing any
   * mode characters is between `start` and `end`.
   */
  private predicate flagGroupStartNoModes(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) in ["-", "i", "d", "m", "s", "u", "x", "U"] and
    end = start + 2
  }

  /**
   * Holds if `pos` contains a mode character from the
   * flag group starting at `start`.
   */
  private predicate modeCharacter(int start, int pos) {
    this.flagGroupStartNoModes(start, pos)
    or
    this.modeCharacter(start, pos - 1) and
    this.getChar(pos) in ["-", "i", "d", "m", "s", "u", "x", "U"]
  }

  /**
   * Holds if a parse mode group is between `start` and `end`.
   */
  private predicate flagGroupStart(int start, int end) {
    this.flagGroupStartNoModes(start, _) and
    // Check if this is a capturing group with flags, and therefore the `:` should be excluded
    exists(int maybeEnd | maybeEnd = max(int i | this.modeCharacter(start, i) | i + 1) |
      if this.getChar(maybeEnd) = ":" then end = maybeEnd + 1 else end = maybeEnd
    )
  }

  /**
   * Holds if a parse mode group of this regex includes the mode flag `c`.
   * For example the following parse mode group, with mode flag `i`:
   * ```
   * (?i)
   * ```
   */
  private predicate flag(string c) {
    exists(int start, int pos |
      this.modeCharacter(start, pos) and
      this.getChar(pos) = c and
      // Ignore if flag is disabled; use `<=` to also exclude `-` itself
      // This does not properly handle the (contrived) case where a flag is both enabled and
      // disabled, e.g. `(?i-i)a+`, in which case the flag seems to acts as if it was disabled
      not exists(int minusPos |
        this.modeCharacter(start, minusPos) and this.getChar(minusPos) = "-" and minusPos <= pos
      )
    )
  }

  /**
   * Gets the mode of this regular expression string if
   * it is defined by a prefix.
   */
  string getModeFromPrefix() {
    exists(string c | this.flag(c) |
      c = "i" and result = "IGNORECASE"
      or
      c = "d" and result = "UNIXLINES"
      or
      c = "m" and result = "MULTILINE"
      or
      c = "s" and result = "DOTALL"
      or
      c = "u" and result = "UNICODE"
      or
      c = "x" and result = "VERBOSE"
      or
      c = "U" and result = "UNICODECLASS"
    )
  }

  private predicate lookaheadAssertionStart(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "=" and
    end = start + 3
  }

  private predicate negativeLookaheadAssertionStart(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "!" and
    end = start + 3
  }

  private predicate lookbehindAssertionStart(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "<" and
    this.getChar(start + 3) = "=" and
    end = start + 4
  }

  private predicate negativeLookbehindAssertionStart(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "<" and
    this.getChar(start + 3) = "!" and
    end = start + 4
  }

  private predicate atomicGroupStart(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = ">" and
    end = start + 3
  }

  private predicate groupStart(int start, int end) {
    this.nonCapturingGroupStart(start, end)
    or
    this.flagGroupStart(start, end)
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
    this.atomicGroupStart(start, end)
    or
    this.simpleGroupStart(start, end)
  }

  /** Holds if the text in the range start,end is a group with contents in the range in_start,in_end */
  predicate groupContents(int start, int end, int in_start, int in_end) {
    this.groupStart(start, in_start) and
    end = in_end + 1 and
    this.topLevel(in_start, in_end) and
    this.isGroupEnd(in_end)
  }

  /** Holds if the text in the range start,end is a group */
  predicate group(int start, int end) {
    this.groupContents(start, end, _, _)
    or
    this.emptyGroup(start, end)
  }

  /** Gets the number of the group in start,end */
  int getGroupNumber(int start, int end) {
    this.group(start, end) and
    result =
      count(int i | this.group(i, _) and i < start and not this.nonCapturingGroupStart(i, _)) + 1
  }

  /** Gets the name, if it has one, of the group in start,end */
  string getGroupName(int start, int end) {
    this.group(start, end) and
    exists(int name_end |
      this.namedGroupStart(start, name_end) and
      result = this.getText().substring(start + 3, name_end - 1)
    )
  }

  /** Holds if a negative lookahead is found between `start` and `end` */
  predicate negativeLookaheadAssertionGroup(int start, int end) {
    exists(int in_start | this.negativeLookaheadAssertionStart(start, in_start) |
      this.groupContents(start, end, in_start, _)
    )
  }

  /** Holds if a negative lookbehind is found between `start` and `end` */
  predicate negativeLookbehindAssertionGroup(int start, int end) {
    exists(int in_start | this.negativeLookbehindAssertionStart(start, in_start) |
      this.groupContents(start, end, in_start, _)
    )
  }

  private predicate negativeAssertionGroup(int start, int end) {
    exists(int in_start |
      this.negativeLookaheadAssertionStart(start, in_start)
      or
      this.negativeLookbehindAssertionStart(start, in_start)
    |
      this.groupContents(start, end, in_start, _)
    )
  }

  /** Holds if a positive lookahead is found between `start` and `end` */
  predicate positiveLookaheadAssertionGroup(int start, int end) {
    exists(int in_start | this.lookaheadAssertionStart(start, in_start) |
      this.groupContents(start, end, in_start, _)
    )
  }

  /** Holds if a positive lookbehind is found between `start` and `end` */
  predicate positiveLookbehindAssertionGroup(int start, int end) {
    exists(int in_start | this.lookbehindAssertionStart(start, in_start) |
      this.groupContents(start, end, in_start, _)
    )
  }

  /** Holds if the text in the range start, end is a group and can match the empty string. */
  predicate zeroWidthMatch(int start, int end) {
    this.emptyGroup(start, end)
    or
    this.negativeAssertionGroup(start, end)
    or
    this.positiveLookaheadAssertionGroup(start, end)
    or
    this.positiveLookbehindAssertionGroup(start, end)
  }

  private predicate baseItem(int start, int end) {
    this.character(start, end) and
    not exists(int x, int y | this.charSet(x, y) and x <= start and y >= end)
    or
    this.group(start, end)
    or
    this.charSet(start, end)
    or
    this.backreference(start, end)
    or
    this.quote(start, end)
  }

  private predicate shortQuantifier(
    int start, int end, boolean maybe_empty, boolean may_repeat_forever
  ) {
    (
      this.getChar(start) = "+" and maybe_empty = false and may_repeat_forever = true
      or
      this.getChar(start) = "*" and maybe_empty = true and may_repeat_forever = true
      or
      this.getChar(start) = "?" and maybe_empty = true and may_repeat_forever = false
    ) and
    end = start + 1
    or
    exists(string lower, string upper |
      this.multiples(start, end, lower, upper) and
      (if lower = "" or lower.toInt() = 0 then maybe_empty = true else maybe_empty = false) and
      if upper = "" then may_repeat_forever = true else may_repeat_forever = false
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

  private predicate quantifier(int start, int end, boolean maybe_empty, boolean may_repeat_forever) {
    this.shortQuantifier(start, end, maybe_empty, may_repeat_forever) and
    not this.getChar(end) = ["?", "+"]
    or
    exists(int short_end | this.shortQuantifier(start, short_end, maybe_empty, may_repeat_forever) |
      if this.getChar(short_end) = ["?", "+"] then end = short_end + 1 else end = short_end
    )
  }

  /**
   * Holds if a quantified part is found between `start` and `part_end` and the quantifier is
   * found between `part_end` and `end`.
   *
   * `maybe_empty` is true if the part is optional.
   * `may_repeat_forever` is true if the part may be repeated unboundedly.
   */
  predicate quantifiedPart(
    int start, int part_end, int end, boolean maybe_empty, boolean may_repeat_forever
  ) {
    this.baseItem(start, part_end) and
    this.quantifier(part_end, end, maybe_empty, may_repeat_forever)
  }

  /**
   * Holds if the text in the range start,end is a quantified item, where item is a character,
   * a character set or a group.
   */
  predicate quantifiedItem(int start, int end, boolean maybe_empty, boolean may_repeat_forever) {
    this.quantifiedPart(start, _, end, maybe_empty, may_repeat_forever)
  }

  /** Holds if the range `start`, `end` contains a character, a quantifier, a character set or a group. */
  predicate item(int start, int end) {
    this.quantifiedItem(start, end, _, _)
    or
    this.baseItem(start, end) and not this.quantifier(end, _, _, _)
  }

  private predicate itemStart(int start) {
    this.character(start, _) or
    this.isGroupStart(start) or
    this.charSet(start, _) or
    this.backreference(start, _) or
    this.quote(start, _)
  }

  private predicate itemEnd(int end) {
    this.character(_, end)
    or
    exists(int endm1 | this.isGroupEnd(endm1) and end = endm1 + 1)
    or
    this.charSet(_, end)
    or
    this.quantifier(_, end, _, _)
    or
    this.quote(_, end)
  }

  private predicate isOptionDivider(int i) { this.nonEscapedCharAt(i) = "|" }

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

  private predicate sequenceOrQuantified(int start, int end) {
    this.subsequence(start, end) and
    not this.itemStart(end)
  }

  /**
   * Holds if the text in the range start,end is a sequence of 1 or more items, where an item is a character,
   * a character set or a group.
   */
  predicate sequence(int start, int end) {
    this.sequenceOrQuantified(start, end) and
    not this.quantifiedItem(start, end, _, _)
  }

  private predicate subalternation(int start, int end, int itemStart) {
    this.sequenceOrQuantified(start, end) and
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
      this.sequenceOrQuantified(itemStart, end)
      or
      not this.itemStart(end) and end = itemStart
    )
  }

  private predicate topLevel(int start, int end) {
    not this.inCharSet(start) and
    this.subalternation(start, end, _) and
    not this.isOptionDivider(end)
  }

  /**
   * Holds if the text in the range start,end is an alternation
   */
  predicate alternation(int start, int end) {
    this.topLevel(start, end) and
    exists(int less | this.subalternation(start, less, _) and less < end)
  }

  /**
   * Holds if the text in the range start,end is an alternation and the text in part_start, part_end is one of the
   * options in that alternation.
   */
  predicate alternationOption(int start, int end, int part_start, int part_end) {
    this.alternation(start, end) and
    this.subalternation(start, part_end, part_start)
  }

  /**
   * Gets the `i`th character of this literal as it was written in the source code.
   */
  string getSourceChar(int i) { result = this.(StringLiteral).getLiteral().charAt(i) }

  /**
   * Helper predicate for `sourceEscapingChar` that
   * results in a boolean in order to avoid negative recursion.
   */
  private boolean sourceEscaping(int pos) {
    pos = -1 and result = false
    or
    this.getSourceChar(pos) = "\\" and
    result = this.sourceEscaping(pos - 1).booleanNot()
    or
    this.getSourceChar(pos) != "\\" and result = false
  }

  /**
   * Equivalent of `escapingChar` for the literal source rather than the string value.
   * Holds if the character at position `pos` in the source literal is a '\' that is
   * actually escaping what comes after it.
   */
  private predicate sourceEcapingChar(int pos) { this.sourceEscaping(pos) = true }

  /**
   * Holds if an escaped character exists between `start` and `end` in the source iteral.
   */
  private predicate sourceEscapedCharacter(int start, int end) {
    this.sourceEcapingChar(start) and
    (if this.getSourceChar(start + 1) = "u" then end = start + 6 else end = start + 2)
  }

  private predicate sourceNonEscapedCharacter(int i) {
    exists(this.getSourceChar(i)) and
    not exists(int x, int y | this.sourceEscapedCharacter(x, y) and i in [x .. y - 1])
  }

  /**
   * Holds if a character is represented between `start` and `end` in the source literal.
   */
  private predicate sourceCharacter(int start, int end) {
    this.sourceEscapedCharacter(start, end)
    or
    this.sourceNonEscapedCharacter(start) and
    end = start + 1
  }

  /**
   * Holds if the `i`th character of the string is represented between offsets
   * `start` (inclusive) and `end` (exclusive) in the source code of this literal.
   * This only gives correct results if the literal is written as a normal single-line string literal;
   * without compile-time concatenation involved.
   */
  predicate sourceCharacter(int pos, int start, int end) {
    exists(this.getChar(pos)) and
    this.sourceCharacter(start, end) and
    start = rank[pos + 2](int s | this.sourceCharacter(s, _))
  }
}

/** A string literal used as a regular expression */
class Regex extends RegexString {
  boolean matches_full_string;

  Regex() { usedAsRegex(this, _, matches_full_string) }

  /**
   * Gets a mode (if any) of this regular expression. Can be any of:
   * - IGNORECASE
   * - UNIXLINES
   * - MULTILINE
   * - DOTALL
   * - UNICODE
   * - VERBOSE
   * - UNICODECLASS
   */
  string getAMode() {
    result != "None" and
    usedAsRegex(this, result, _)
    or
    result = this.getModeFromPrefix()
  }

  /**
   * Holds if this regex is used to match against a full string,
   * as though it was implicitly surrounded by ^ and $.
   */
  predicate matchesFullString() { matches_full_string = true }
}

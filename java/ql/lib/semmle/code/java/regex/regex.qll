import java
private import RegexFlowConfigs

/**
 * A string literal that is used as a regular exprssion.
 */
abstract class RegexString extends Expr {
  RegexString() { this instanceof StringLiteral }

  /** Holds if a character set starts between `start` and `end`. */
  private predicate char_set_start0(int start, int end) {
    this.nonEscapedCharAt(start) = "[" and
    (
      this.getChar(start + 1) = "^" and end = start + 2
      or
      not this.getChar(start + 1) = "^" and end = start + 1
    )
  }

  /** Holds if the character at `pos` marks the end of a character class. */
  private predicate char_set_end0(int pos) {
    this.nonEscapedCharAt(pos) = "]" and
    /* special case: `[]]` and `[^]]` are valid char classes.  */
    not char_set_start0(_, pos - 1)
  }

  /**
   * Gets the nesting depth of charcter classes at position `pos`
   */
  private int char_set_depth(int pos) {
    exists(this.getChar(pos)) and
    result =
      max(int j |
        j = 0 or
        j =
          count(int i | i < pos and this.char_set_start0(i, _)) -
            count(int i | i < pos and this.char_set_end0(i))
      )
  }

  /** Hold if a top-level character set starts between `start` and `end`. */
  predicate char_set_start(int start, int end) {
    this.char_set_start0(start, end) and
    this.char_set_depth(start) = 0
  }

  /** Holds if a top-level character set ends at `pos`. */
  predicate char_set_end(int pos) {
    this.char_set_end0(pos) and
    this.char_set_depth(pos) = 1
  }

  /**
   * Whether there is a top-level character class, between start (inclusive) and end (exclusive)
   *
   * For now, nested character classes are approximated by only considering the top-level class for parsing.
   * This leads to very similar results for ReDoS queries.
   */
  predicate charSet(int start, int end) {
    exists(int inner_start, int inner_end |
      this.char_set_start(start, inner_start) and
      not this.char_set_start(_, start)
    |
      end = inner_end + 1 and
      inner_end > inner_start and
      this.char_set_end(inner_end) and
      not exists(int mid | char_set_end(mid) | mid > inner_start and mid < inner_end)
    )
  }

  /** An indexed version of `char_set_token/3` */
  private predicate char_set_token(int charset_start, int index, int token_start, int token_end) {
    token_start =
      rank[index](int start, int end | this.char_set_token(charset_start, start, end) | start) and
    this.char_set_token(charset_start, token_start, token_end)
  }

  /** Either a char or a - */
  private predicate char_set_token(int charset_start, int start, int end) {
    this.char_set_start(charset_start, start) and
    (
      this.escapedCharacter(start, end)
      or
      exists(this.nonEscapedCharAt(start)) and end = start + 1
      or
      this.quote(start, end)
    )
    or
    this.char_set_token(charset_start, _, start) and
    (
      this.escapedCharacter(start, end)
      or
      exists(this.nonEscapedCharAt(start)) and
      end = start + 1 and
      not this.char_set_end(start)
      or
      this.quote(start, end)
    )
  }

  /**
   * Holds if the character set starting at `charset_start` contains either
   * a character or a range found between `start` and `end`.
   */
  predicate char_set_child(int charset_start, int start, int end) {
    this.char_set_token(charset_start, start, end) and
    not exists(int range_start, int range_end |
      this.charRange(charset_start, range_start, _, _, range_end) and
      range_start <= start and
      range_end >= end
    )
    or
    this.charRange(charset_start, start, _, _, end)
  }

  /**
   * Holds if the character set starting at `charset_start` contains a character range
   * with lower bound found between `start` and `lower_end`
   * and upper bound found between `upper_start` and `end`.
   */
  predicate charRange(int charset_start, int start, int lower_end, int upper_start, int end) {
    exists(int index |
      this.charRangeEnd(charset_start, index) = true and
      this.char_set_token(charset_start, index - 2, start, lower_end) and
      this.char_set_token(charset_start, index, upper_start, end)
    )
  }

  /**
   * Helper predicate for `charRange`.
   * We can determine where character ranges end by a left to right sweep.
   *
   * To avoid negative recursion we return a boolean. See `escaping`,
   * the helper for `escapingChar`, for a clean use of this pattern.
   */
  private boolean charRangeEnd(int charset_start, int index) {
    this.char_set_token(charset_start, index, _, _) and
    (
      index in [1, 2] and result = false
      or
      index > 2 and
      exists(int connector_start |
        this.char_set_token(charset_start, index - 1, connector_start, _) and
        this.nonEscapedCharAt(connector_start) = "-" and
        result =
          this.charRangeEnd(charset_start, index - 2)
              .booleanNot()
              .booleanAnd(this.charRangeEnd(charset_start, index - 1).booleanNot())
      )
      or
      not exists(int connector_start |
        this.char_set_token(charset_start, index - 1, connector_start, _) and
        this.nonEscapedCharAt(connector_start) = "-"
      ) and
      result = false
    )
  }

  /** Holds if the character at `pos` is a "\" that is actually escaping what comes after. */
  predicate escapingChar(int pos) {
    this.escaping(pos) = true and
    not exists(int x, int y | this.quote(x, y) and pos in [x .. y - 1])
  }

  /**
   * Helper predicate for `escapingChar`.
   * In order to avoid negative recusrion, we return a boolean.
   * This way, we can refer to `escaping(pos - 1).booleanNot()`
   * rather than to a negated version of `escaping(pos)`.
   * Does not take into account escape characters inside quote sequences.
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
   * Helper predicate for `quoteSequence`.
   * Holds if the char at `pos` could be the beginning of a quote delimiter, i.e. `\Q` (non-escaped) or `\E` (escaping not checked, as quote sequences turn off escapes).
   * Result is `true` for `\Q` and `false` for `\E`.
   */
  private boolean quote_delimiter(int pos) {
    result = true and
    this.escaping(pos) = true and
    this.getChar(pos + 1) = "Q"
    or
    result = false and
    this.getChar(pos) = "\\" and
    this.getChar(pos + 1) = "E"
  }

  /**
   * Helper predicate for `quoteSequence`.
   * Holds if the char at `pos` is the one-based `index`th occourence of a quote delimiter (`\Q` or `\E`)
   * Result is `true` for `\Q` and `false` for `\E`.
   */
  private boolean quote_delimiter(int index, int pos) {
    result = this.quote_delimiter(pos) and
    pos = rank[index](int p | this.quote_delimiter(p) = [true, false])
  }

  /** Holds if a quoted sequence is found between `start` and `end` */
  predicate quote(int start, int end) { this.quote(start, end, _, _) }

  /** Holds if a quoted sequence is fund between `start` and `end`, with ontent found between `inner_start` and `inner_end`. */
  predicate quote(int start, int end, int inner_start, int inner_end) {
    exists(int index |
      this.quote_delimiter(index, start) = true and
      (
        index = 1
        or
        this.quote_delimiter(index - 1, _) = false
      ) and
      inner_start = start + 2 and
      inner_end = end - 2 and
      inner_end > inner_start and
      this.quote_delimiter(inner_end) = false and
      not exists(int mid |
        this.quote_delimiter(mid) = false and mid in [inner_start .. inner_end - 1]
      )
    )
  }

  /**
   * A control sequence, `\cx`
   * `x` may be any ascii character including special characters.
   */
  predicate controlEscape(int start, int end) {
    this.escapingChar(start) and
    this.getChar(start + 1) = "c" and
    end = start + 3
  }

  /** Gets the text of this regex */
  string getText() { result = this.(StringLiteral).getValue() }

  string getChar(int i) { result = this.getText().charAt(i) }

  string nonEscapedCharAt(int i) {
    result = this.getText().charAt(i) and
    not exists(int x, int y | this.escapedCharacter(x, y) and i in [x .. y - 1]) and
    not exists(int x, int y | this.quote(x, y) and i in [x .. y - 1]) and
    not exists(int x, int y | this.controlEscape(x, y) and i in [x .. y - 1])
  }

  private predicate isOptionDivider(int i) { this.nonEscapedCharAt(i) = "|" }

  private predicate isGroupEnd(int i) { this.nonEscapedCharAt(i) = ")" and not this.inCharSet(i) }

  private predicate isGroupStart(int i) { this.nonEscapedCharAt(i) = "(" and not this.inCharSet(i) }

  predicate failedToParse(int i) {
    exists(this.getChar(i)) and
    not exists(int start, int end |
      this.top_level(start, end) and
      start <= i and
      end > i
    )
  }

  /** An escape sequence that includes braces, such as named characters (\N{degree sign}), named classes (\p{Lower}), or hex values (\x{h..h}) */
  private predicate escapedBraces(int start, int end) {
    this.escapingChar(start) and
    this.getChar(start + 1) = ["N", "p", "P", "x"] and
    this.getChar(start + 2) = "{" and
    this.getChar(end - 1) = "}" and
    end > start and
    not exists(int i | start + 2 < i and i < end - 1 | this.getChar(i) = "}")
  }

  /**
   * Holds if an escaped character is found between `start` and `end`.
   * Escaped characters include hex values, octal values and named escapes,
   * but excludes backreferences.
   */
  predicate escapedCharacter(int start, int end) {
    this.escapingChar(start) and
    not this.numbered_backreference(start, _, _) and
    (
      // hex value \xhh
      this.getChar(start + 1) = "x" and
      this.getChar(start + 2) != "{" and
      end = start + 4
      or
      // octal value \0o, \0oo, or \0ooo. Max of 0377.
      this.getChar(start + 1) = "0" and
      end in [start + 3 .. start + 5] and
      forall(int i | i in [start + 1 .. end - 1] | this.isOctal(i)) and
      (end = start + 5 implies this.getChar(start + 2) <= "3") and
      not (
        end < start + 5 and
        this.isOctal(end) and
        (end = start + 4 implies this.getChar(start + 2) <= "3")
      )
      or
      // 16-bit hex value \uhhhh
      this.getChar(start + 1) = "u" and end = start + 6
      or
      escapedBraces(start, end)
      or
      // Boundry matchers \b, \b{g}
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

  pragma[inline]
  private predicate isOctal(int index) { this.getChar(index) = [0 .. 7].toString() }

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
        this.char_set_start(x, y)
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

  predicate character(int start, int end) {
    (
      this.simpleCharacter(start, end) and
      not exists(int x, int y | this.escapedCharacter(x, y) and x <= start and y >= end)
      or
      this.escapedCharacter(start, end)
    ) and
    not exists(int x, int y | this.group_start(x, y) and x <= start and y >= end) and
    not exists(int x, int y | this.backreference(x, y) and x <= start and y >= end)
  }

  predicate normalCharacter(int start, int end) {
    this.character(start, end) and
    not this.specialCharacter(start, end, _)
  }

  predicate specialCharacter(int start, int end, string char) {
    this.character(start, end) and
    end = start + 1 and
    char = this.getChar(start) and
    (char = "$" or char = "^" or char = ".") and
    not this.inCharSet(start)
  }

  /** Whether the text in the range start,end is a group */
  predicate group(int start, int end) {
    this.groupContents(start, end, _, _)
    or
    this.emptyGroup(start, end)
  }

  /** Gets the number of the group in start,end */
  int getGroupNumber(int start, int end) {
    this.group(start, end) and
    result =
      count(int i | this.group(i, _) and i < start and not this.non_capturing_group_start(i, _)) + 1
  }

  /** Gets the name, if it has one, of the group in start,end */
  string getGroupName(int start, int end) {
    this.group(start, end) and
    exists(int name_end |
      this.named_group_start(start, name_end) and
      result = this.getText().substring(start + 3, name_end - 1)
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
      this.group_start(start, endm1) and
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
    exists(int in_start |
      this.negative_lookahead_assertion_start(start, in_start)
      or
      this.negative_lookbehind_assertion_start(start, in_start)
    |
      this.groupContents(start, end, in_start, _)
    )
  }

  /** Holds if a negative lookahead is found between `start` and `end` */
  predicate negativeLookaheadAssertionGroup(int start, int end) {
    exists(int in_start | this.negative_lookahead_assertion_start(start, in_start) |
      this.groupContents(start, end, in_start, _)
    )
  }

  /** Holds if a negative lookbehind is found between `start` and `end` */
  predicate negativeLookbehindAssertionGroup(int start, int end) {
    exists(int in_start | this.negative_lookbehind_assertion_start(start, in_start) |
      this.groupContents(start, end, in_start, _)
    )
  }

  /** Holds if a positive lookahead is found between `start` and `end` */
  predicate positiveLookaheadAssertionGroup(int start, int end) {
    exists(int in_start | this.lookahead_assertion_start(start, in_start) |
      this.groupContents(start, end, in_start, _)
    )
  }

  /** Holds if a positive lookbehind is found between `start` and `end` */
  predicate positiveLookbehindAssertionGroup(int start, int end) {
    exists(int in_start | this.lookbehind_assertion_start(start, in_start) |
      this.groupContents(start, end, in_start, _)
    )
  }

  private predicate group_start(int start, int end) {
    this.non_capturing_group_start(start, end)
    or
    this.flag_group_start(start, end, _)
    or
    this.named_group_start(start, end)
    or
    this.named_backreference_start(start, end)
    or
    this.lookahead_assertion_start(start, end)
    or
    this.negative_lookahead_assertion_start(start, end)
    or
    this.lookbehind_assertion_start(start, end)
    or
    this.negative_lookbehind_assertion_start(start, end)
    or
    this.atomic_group_start(start, end)
    or
    this.simple_group_start(start, end)
  }

  private predicate non_capturing_group_start(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = ":" and
    end = start + 3
  }

  private predicate simple_group_start(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) != "?" and
    end = start + 1
  }

  private predicate named_group_start(int start, int end) {
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

  private predicate named_backreference_start(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "k" and
    this.getChar(start + 3) = "=" and
    // Should this be looking for unescaped ")"?
    // TODO: test this
    end = min(int i | i > start + 4 and this.getChar(i) = "?")
  }

  private predicate flag_group_start(int start, int end, string c) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    end = start + 3 and
    c = this.getChar(start + 2) and
    c in ["i", "m", "s", "u", "x", "U"]
  }

  /**
   * Gets the mode of this regular expression string if
   * it is defined by a prefix.
   */
  string getModeFromPrefix() {
    exists(string c | this.flag_group_start(_, _, c) |
      c = "i" and result = "IGNORECASE"
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

  private predicate lookahead_assertion_start(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "=" and
    end = start + 3
  }

  private predicate negative_lookahead_assertion_start(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "!" and
    end = start + 3
  }

  private predicate lookbehind_assertion_start(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "<" and
    this.getChar(start + 3) = "=" and
    end = start + 4
  }

  private predicate negative_lookbehind_assertion_start(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "<" and
    this.getChar(start + 3) = "!" and
    end = start + 4
  }

  private predicate atomic_group_start(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = ">" and
    end = start + 3
  }

  predicate groupContents(int start, int end, int in_start, int in_end) {
    this.group_start(start, in_start) and
    end = in_end + 1 and
    this.top_level(in_start, in_end) and
    this.isGroupEnd(in_end)
  }

  private predicate named_backreference(int start, int end, string name) {
    this.named_backreference_start(start, start + 4) and
    end = min(int i | i > start + 4 and this.getChar(i) = ")") + 1 and
    name = this.getText().substring(start + 4, end - 2)
  }

  private predicate numbered_backreference(int start, int end, int value) {
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

  /** Whether the text in the range start,end is a back reference */
  predicate backreference(int start, int end) {
    this.numbered_backreference(start, end, _)
    or
    this.named_backreference(start, end, _)
  }

  /** Gets the number of the back reference in start,end */
  int getBackrefNumber(int start, int end) { this.numbered_backreference(start, end, result) }

  /** Gets the name, if it has one, of the back reference in start,end */
  string getBackrefName(int start, int end) { this.named_backreference(start, end, result) }

  private predicate baseItem(int start, int end) {
    this.character(start, end) and
    not exists(int x, int y | this.charSet(x, y) and x <= start and y >= end)
    or
    this.group(start, end)
    or
    this.charSet(start, end)
    or
    this.backreference(start, end)
  }

  private predicate qualifier(int start, int end, boolean maybe_empty, boolean may_repeat_forever) {
    this.short_qualifier(start, end, maybe_empty, may_repeat_forever) and
    not this.getChar(end) = ["?", "+"]
    or
    exists(int short_end | this.short_qualifier(start, short_end, maybe_empty, may_repeat_forever) |
      if this.getChar(short_end) = ["?", "+"] then end = short_end + 1 else end = short_end
    )
  }

  private predicate short_qualifier(
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

  /**
   * Whether the text in the range start,end is a qualified item, where item is a character,
   * a character set or a group.
   */
  predicate qualifiedItem(int start, int end, boolean maybe_empty, boolean may_repeat_forever) {
    this.qualifiedPart(start, _, end, maybe_empty, may_repeat_forever)
  }

  /**
   * Holds if a qualified part is found between `start` and `part_end` and the qualifier is
   * found between `part_end` and `end`.
   *
   * `maybe_empty` is true if the part is optional.
   * `may_repeat_forever` is true if the part may be repeated unboundedly.
   */
  predicate qualifiedPart(
    int start, int part_end, int end, boolean maybe_empty, boolean may_repeat_forever
  ) {
    this.baseItem(start, part_end) and
    this.qualifier(part_end, end, maybe_empty, may_repeat_forever)
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
      this.group_start(_, start) or
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
    not this.item_start(end)
  }

  private predicate item_start(int start) {
    this.character(start, _) or
    this.isGroupStart(start) or
    this.charSet(start, _) or
    this.backreference(start, _) or
    this.quote(start, _)
  }

  private predicate item_end(int end) {
    this.character(_, end)
    or
    exists(int endm1 | this.isGroupEnd(endm1) and end = endm1 + 1)
    or
    this.charSet(_, end)
    or
    this.qualifier(_, end, _, _)
    or
    this.quote(_, end)
  }

  private predicate top_level(int start, int end) {
    this.subalternation(start, end, _) and
    not this.isOptionDivider(end)
  }

  private predicate subalternation(int start, int end, int item_start) {
    this.sequenceOrQualified(start, end) and
    not this.isOptionDivider(start - 1) and
    item_start = start
    or
    start = end and
    not this.item_end(start) and
    this.isOptionDivider(end) and
    item_start = start
    or
    exists(int mid |
      this.subalternation(start, mid, _) and
      this.isOptionDivider(mid) and
      item_start = mid + 1
    |
      this.sequenceOrQualified(item_start, end)
      or
      not this.item_start(end) and end = item_start
    )
  }

  /**
   * Whether the text in the range start,end is an alternation
   */
  predicate alternation(int start, int end) {
    this.top_level(start, end) and
    exists(int less | this.subalternation(start, less, _) and less < end)
  }

  /**
   * Whether the text in the range start,end is an alternation and the text in part_start, part_end is one of the
   * options in that alternation.
   */
  predicate alternationOption(int start, int end, int part_start, int part_end) {
    this.alternation(start, end) and
    this.subalternation(start, part_end, part_start)
  }

  /** A part of the regex that may match the start of the string. */
  private predicate firstPart(int start, int end) {
    start = 0 and end = this.getText().length()
    or
    exists(int x | this.firstPart(x, end) |
      this.emptyMatchAtStartGroup(x, start) or
      this.qualifiedItem(x, start, true, _) or
      this.specialCharacter(x, start, "^")
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
      this.specialCharacter(end, y, "$")
      or
      y = end + 2 and this.escapingChar(end) and this.getChar(end + 1) = "Z"
    )
    or
    exists(int x |
      this.lastPart(x, end) and
      this.item(start, end)
    )
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
      this.character(start, end)
      or
      this.qualifiedItem(start, end, _, _)
      or
      this.charSet(start, end)
      or
      this.quote(start, end)
    ) and
    this.firstPart(start, end)
  }

  /**
   * Whether the item at [start, end) is one of the last items
   * to be matched.
   */
  predicate lastItem(int start, int end) {
    (
      this.character(start, end)
      or
      this.qualifiedItem(start, end, _, _)
      or
      this.charSet(start, end)
      or
      this.quote(start, end)
    ) and
    this.lastPart(start, end)
  }
}

/** A string literal used as a regular expression */
class Regex extends RegexString {
  Regex() { used_as_regex(this, _) }

  /**
   * Gets a mode (if any) of this regular expression. Can be any of:
   * DEBUG
   * IGNORECASE
   * MULTILINE
   * DOTALL
   * UNICODE
   * VERBOSE
   * UNICODECLASS
   */
  string getAMode() {
    result != "None" and
    used_as_regex(this, result)
    or
    result = this.getModeFromPrefix()
  }
}

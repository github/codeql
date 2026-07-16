/**
 * Library for parsing C++ regular expressions.
 *
 * This parser targets ECMAScript syntax, which is the default mode used by
 * `std::regex` (i.e., `std::regex_constants::ECMAScript`). Other syntaxes
 * supported by `std::regex` (`basic`, `extended`, `awk`, `grep`, `egrep`)
 * as well as third-party libraries (Boost.Regex, PCRE, RE2) differ and are
 * not modeled here.
 */

import cpp
private import semmle.code.cpp.regex.RegexFlowConfigs as RFC

/**
 * A string literal used as a regular expression.
 *
 * A `StringLiteral` is treated as a regex only when dataflow indicates it
 * flows to a `std::basic_regex` construction/assignment or to a
 * `regex_match`/`regex_search`/`regex_replace`/iterator call. Regexes
 * constructed with an explicit non-ECMAScript grammar flag are excluded,
 * since the parser only models the ECMAScript dialect.
 */
class RegExp extends StringLiteral {
  RegExp() {
    RFC::usedAsRegex(this) and
    not RFC::hasNonEcmaScriptGrammarFlag(this)
  }

  /** Gets the `i`th character of this regex string. */
  string getChar(int i) { result = this.getValue().charAt(i) }

  /** Gets the text of this regex (the string value of the literal). */
  string getText() { result = this.getValue() }

  // ---------------------------------------------------------------------------
  // Escaping
  // ---------------------------------------------------------------------------

  /**
   * Helper predicate for `escapingChar`.
   * Returns `true` if the character at position `pos` is an active backslash
   * (i.e., it escapes the next character). Uses a boolean to avoid negation in
   * recursive calls.
   */
  private boolean escaping(int pos) {
    pos = -1 and result = false
    or
    this.getChar(pos) = "\\" and result = this.escaping(pos - 1).booleanNot()
    or
    this.getChar(pos) != "\\" and result = false
  }

  /** Holds if the character at position `pos` is a backslash that escapes the next character. */
  predicate escapingChar(int pos) { this.escaping(pos) = true }

  // ---------------------------------------------------------------------------
  // Character sets  (character classes  [ ... ] )
  // ---------------------------------------------------------------------------

  /**
   * Holds if the (non-escaped) character at position `pos` is the `index`-th
   * bracket (`[` or `]`) in the string.
   * Result is `true` for `[` and `false` for `]`.
   */
  private boolean char_set_delimiter(int index, int pos) {
    pos = rank[index](int p | this.nonEscapedCharAt(p) = "[" or this.nonEscapedCharAt(p) = "]") and
    (
      this.nonEscapedCharAt(pos) = "[" and result = true
      or
      this.nonEscapedCharAt(pos) = "]" and result = false
    )
  }

  /**
   * Helper for `char_set_start/1`.
   * Returns `true` if position `pos` is the start of a character class.
   */
  boolean char_set_start(int pos) {
    exists(int index |
      this.char_set_delimiter(index, pos) = true and
      (
        index = 1 and result = true
        or
        index > 1 and
        not this.char_set_delimiter(index - 1, _) = false and
        result = false
        or
        exists(int prev_closing_bracket_pos |
          this.char_set_delimiter(index - 1, prev_closing_bracket_pos) = false and
          if
            exists(int pos_before_prev |
              if this.getChar(prev_closing_bracket_pos - 1) = "^"
              then pos_before_prev = prev_closing_bracket_pos - 2
              else pos_before_prev = prev_closing_bracket_pos - 1
            |
              this.char_set_delimiter(index - 2, pos_before_prev) = true
            )
          then
            exists(int pos_before_prev |
              this.char_set_delimiter(index - 2, pos_before_prev) = true
            |
              result = this.char_set_start(pos_before_prev).booleanNot()
            )
          else result = true
        )
      )
    )
  }

  /**
   * Holds if a character class starts at position `start` with content
   * starting at `end` (accounting for optional `^`).
   */
  predicate char_set_start(int start, int end) {
    this.char_set_start(start) = true and
    (
      this.getChar(start + 1) = "^" and end = start + 2
      or
      not this.getChar(start + 1) = "^" and end = start + 1
    )
  }

  /** Holds if a character class spans `[start, end)`. */
  predicate charSet(int start, int end) {
    exists(int inner_start |
      this.char_set_start(start, inner_start) and
      not this.char_set_start(_, start)
    |
      end - 1 = min(int i | this.nonEscapedCharAt(i) = "]" and inner_start < i)
    )
  }

  /** An indexed version of `char_set_token`. */
  private predicate char_set_token(int charset_start, int index, int token_start, int token_end) {
    token_start =
      rank[index](int start, int end | this.char_set_token(charset_start, start, end) | start) and
    this.char_set_token(charset_start, token_start, token_end)
  }

  /** A single token (character or escape) inside a character class. */
  private predicate char_set_token(int charset_start, int start, int end) {
    this.char_set_start(charset_start, start) and
    (
      this.escapedCharacter(start, end)
      or
      exists(this.nonEscapedCharAt(start)) and end = start + 1
    )
    or
    this.char_set_token(charset_start, _, start) and
    (
      this.escapedCharacter(start, end)
      or
      exists(this.nonEscapedCharAt(start)) and
      end = start + 1 and
      not this.getChar(start) = "]"
    )
  }

  /**
   * Holds if the character class starting at `charset_start` contains a child
   * (either a single character or a range) spanning `[start, end)`.
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
   * Holds if the character class at `charset_start` contains a character range
   * from `[start, lower_end)` to `[upper_start, end)`.
   */
  predicate charRange(int charset_start, int start, int lower_end, int upper_start, int end) {
    exists(int index |
      this.charRangeEnd(charset_start, index) = true and
      this.char_set_token(charset_start, index - 2, start, lower_end) and
      this.char_set_token(charset_start, index, upper_start, end)
    )
  }

  /**
   * Helper for `charRange`. Returns `true` if the `index`-th token in the
   * character class is the upper bound of a range.
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

  // ---------------------------------------------------------------------------
  // Characters and escapes
  // ---------------------------------------------------------------------------

  /** Gets the non-escaped character at position `i`, if any. */
  string nonEscapedCharAt(int i) {
    result = this.getText().charAt(i) and
    not exists(int x, int y | this.escapedCharacter(x, y) and i in [x .. y - 1])
  }

  /** Holds if `index` is inside a character class. */
  predicate inCharSet(int index) {
    exists(int x, int y | this.charSet(x, y) and index in [x + 1 .. y - 2])
  }

  /**
   * Holds if an escaped character sequence spans `[start, end)`.
   * This includes hex values, unicode escapes, and simple single-character
   * escapes, but excludes back-references.
   */
  predicate escapedCharacter(int start, int end) {
    this.escapingChar(start) and
    not this.numbered_backreference(start, _, _) and
    (
      // Hex escape: \xhh
      this.getChar(start + 1) = "x" and end = start + 4
      or
      // Unicode escape: \uhhhh (ECMAScript)
      this.getChar(start + 1) = "u" and
      not this.getChar(start + 2) = "{" and
      end = start + 6
      or
      // Unicode escape with braces: \u{...} (ECMAScript 2015+)
      this.getChar(start + 1) = "u" and
      this.getChar(start + 2) = "{" and
      end - 1 = min(int i | start + 3 <= i and this.getChar(i) = "}")
      or
      // Octal (legacy): \0 (NUL), \ooo
      this.getChar(start + 1) = "0" and
      not this.isDecimalDigit(start + 2) and
      end = start + 2
      or
      // Simple escape: \n, \r, \t, \f, \v, \b (inside char class), \\, \., etc.
      not this.getChar(start + 1) in ["x", "u", "0"] and
      not this.isDecimalDigit(start + 1) and
      not this.getChar(start + 1) = "k" and
      // \k<name> is a named backreference, handled separately
      end = start + 2
    )
  }

  pragma[inline]
  private predicate isDecimalDigit(int index) {
    this.getChar(index) = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
  }

  /**
   * A 'simple' character is one that does not affect parsing of the regex
   * (i.e., it is not a metacharacter).
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

  /** Holds if a simple or escaped character spans `[start, end)`. */
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

  /** Holds if a normal (non-special) character spans `[start, end)`. */
  predicate normalCharacter(int start, int end) {
    end = start + 1 and
    this.character(start, end) and
    not this.specialCharacter(start, end, _)
  }

  /**
   * Holds if the character at `[start, end)` is a special (metacharacter) in
   * ECMAScript regex syntax. `char` is the canonical representation.
   *
   * Special characters are: `.`, `^`, `$`, `\b`, `\B`.
   * (Note: `\A`, `\Z`, `\G` are Ruby/Python-specific and not part of ECMAScript.)
   */
  predicate specialCharacter(int start, int end, string char) {
    not this.inCharSet(start) and
    this.character(start, end) and
    (
      end = start + 1 and
      char = this.getChar(start) and
      (char = "$" or char = "^" or char = ".")
      or
      end = start + 2 and
      this.escapingChar(start) and
      char = this.getText().substring(start, end) and
      (char = "\\b" or char = "\\B")
    )
  }

  /** Holds if `[start, end)` is a maximal run of normal characters (a "constant"). */
  predicate normalCharacterSequence(int start, int end) {
    // A single normal character inside a character class stands alone
    this.normalCharacter(start, end) and
    this.inCharSet(start)
    or
    // A maximal run of normal characters outside a character class
    exists(int s, int e |
      e = max(int i | this.normalCharacterRun(s, i)) and
      not this.inCharSet(s)
    |
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

  // ---------------------------------------------------------------------------
  // Quantifiers
  // ---------------------------------------------------------------------------

  /**
   * Holds if a repetition quantifier spans `[start, end)`, with `maybe_empty`
   * indicating whether zero repetitions are possible, and `may_repeat_forever`
   * indicating whether the count is unbounded.
   *
   * In ECMAScript, lazy quantifiers (`*?`, `+?`, `??`, `{n,m}?`) are treated
   * as having the same `maybe_empty`/`may_repeat_forever` as their greedy
   * counterparts from the perspective of ReDoS analysis.
   */
  predicate qualifier(int start, int end, boolean maybe_empty, boolean may_repeat_forever) {
    this.short_qualifier(start, end, maybe_empty, may_repeat_forever) and
    not this.getChar(end) = "?"
    or
    exists(int short_end | this.short_qualifier(start, short_end, maybe_empty, may_repeat_forever) |
      if this.getChar(short_end) = "?" then end = short_end + 1 else end = short_end
    )
  }

  /**
   * Holds if `[start, end)` is a greedy (non-lazy) quantifier. The `maybe_empty`
   * and `may_repeat_forever` booleans characterize the quantifier type.
   */
  predicate short_qualifier(int start, int end, boolean maybe_empty, boolean may_repeat_forever) {
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
   * Holds if `[start, end)` is a `{n}`, `{n,m}`, or `{n,}` quantifier.
   * `lower` and `upper` are the textual lower and upper bounds; an empty
   * `upper` means "no upper bound".
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
   * Holds if `[start, end)` is a qualified item (base item + quantifier).
   */
  predicate qualifiedItem(int start, int end, boolean maybe_empty, boolean may_repeat_forever) {
    this.qualifiedPart(start, _, end, maybe_empty, may_repeat_forever)
  }

  /**
   * Holds if the base item spans `[start, part_end)` and the qualifier spans
   * `[part_end, end)`.
   */
  predicate qualifiedPart(
    int start, int part_end, int end, boolean maybe_empty, boolean may_repeat_forever
  ) {
    this.baseItem(start, part_end) and
    this.qualifier(part_end, end, maybe_empty, may_repeat_forever)
  }

  /** Holds if `[start, end)` is a single regex item (possibly qualified). */
  predicate item(int start, int end) {
    this.qualifiedItem(start, end, _, _)
    or
    this.baseItem(start, end) and not this.qualifier(end, _, _, _)
  }

  // ---------------------------------------------------------------------------
  // Groups
  // ---------------------------------------------------------------------------

  private predicate isOptionDivider(int i) { this.nonEscapedCharAt(i) = "|" }

  private predicate isGroupEnd(int i) { this.nonEscapedCharAt(i) = ")" and not this.inCharSet(i) }

  private predicate isGroupStart(int i) { this.nonEscapedCharAt(i) = "(" and not this.inCharSet(i) }

  /**
   * Matches the start of any group construct, yielding `[start, end)` where
   * `end` is the first position of the group content.
   */
  private predicate group_start(int start, int end) {
    this.non_capturing_group_start(start, end)
    or
    this.ecma_named_group_start(start, end)
    or
    this.lookahead_assertion_start(start, end)
    or
    this.negative_lookahead_assertion_start(start, end)
    or
    this.lookbehind_assertion_start(start, end)
    or
    this.negative_lookbehind_assertion_start(start, end)
    or
    this.simple_group_start(start, end)
  }

  /** `(?:...)` – non-capturing group. */
  private predicate non_capturing_group_start(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = ":" and
    end = start + 3
  }

  /** `(...)` – simple capturing group. */
  private predicate simple_group_start(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) != "?" and
    end = start + 1
  }

  /**
   * `(?<name>...)` – ECMAScript named capturing group.
   * The group name spans from `start+3` to the `>` character.
   */
  private predicate ecma_named_group_start(int start, int end) {
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

  /** `(?=...)` – positive lookahead. */
  predicate lookahead_assertion_start(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "=" and
    end = start + 3
  }

  /** `(?!...)` – negative lookahead. */
  predicate negative_lookahead_assertion_start(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "!" and
    end = start + 3
  }

  /** `(?<=...)` – positive lookbehind. */
  predicate lookbehind_assertion_start(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "<" and
    this.getChar(start + 3) = "=" and
    end = start + 4
  }

  /** `(?<!...)` – negative lookbehind. */
  predicate negative_lookbehind_assertion_start(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "<" and
    this.getChar(start + 3) = "!" and
    end = start + 4
  }

  /** Holds if a group spans `[start, end)`. */
  predicate group(int start, int end) {
    this.groupContents(start, end, _, _)
    or
    this.emptyGroup(start, end)
  }

  /** Holds if an empty group spans `[start, end)`. */
  predicate emptyGroup(int start, int end) {
    exists(int endm1 | end = endm1 + 1 |
      this.group_start(start, endm1) and
      this.isGroupEnd(endm1)
    )
  }

  /** Holds if the group at `[start, end)` has content at `[in_start, in_end)`. */
  predicate groupContents(int start, int end, int in_start, int in_end) {
    this.group_start(start, in_start) and
    end = in_end + 1 and
    this.top_level(in_start, in_end) and
    this.isGroupEnd(in_end)
  }

  /**
   * Gets the 1-based index of the capture group at `[start, end)`.
   * Non-capturing groups and named groups that use `(?<name>...)` still get a
   * number in ECMAScript, but `(?:...)` does not.
   */
  int getGroupNumber(int start, int end) {
    this.group(start, end) and
    not this.non_capturing_group_start(start, _) and
    not this.lookahead_assertion_start(start, _) and
    not this.negative_lookahead_assertion_start(start, _) and
    not this.lookbehind_assertion_start(start, _) and
    not this.negative_lookbehind_assertion_start(start, _) and
    result =
      count(int i |
        this.group(i, _) and
        i < start and
        not this.non_capturing_group_start(i, _) and
        not this.lookahead_assertion_start(i, _) and
        not this.negative_lookahead_assertion_start(i, _) and
        not this.lookbehind_assertion_start(i, _) and
        not this.negative_lookbehind_assertion_start(i, _)
      ) + 1
  }

  /**
   * Gets the name of the ECMAScript named group at `[start, end)`, if any.
   * Named groups have the form `(?<name>...)`.
   */
  string getGroupName(int start, int end) {
    this.group(start, end) and
    exists(int name_end |
      this.ecma_named_group_start(start, name_end) and
      result = this.getText().substring(start + 3, name_end - 1)
    )
  }

  /** Holds if a zero-width match group is at `[start, end)`. */
  predicate zeroWidthMatch(int start, int end) {
    this.emptyGroup(start, end)
    or
    this.negativeLookaheadAssertionGroup(start, end, _, _)
    or
    this.positiveLookaheadAssertionGroup(start, end, _, _)
    or
    this.positiveLookbehindAssertionGroup(start, end, _, _)
    or
    this.negativeLookbehindAssertionGroup(start, end, _, _)
  }

  /** Holds if a positive lookahead `(?=...)` is at `[start, end)`. */
  predicate positiveLookaheadAssertionGroup(int start, int end, int in_start, int in_end) {
    this.lookahead_assertion_start(start, in_start) and
    this.groupContents(start, end, in_start, in_end)
  }

  /** Holds if a negative lookahead `(?!...)` is at `[start, end)`. */
  predicate negativeLookaheadAssertionGroup(int start, int end, int in_start, int in_end) {
    this.negative_lookahead_assertion_start(start, in_start) and
    this.groupContents(start, end, in_start, in_end)
  }

  /** Holds if a positive lookbehind `(?<=...)` is at `[start, end)`. */
  predicate positiveLookbehindAssertionGroup(int start, int end, int in_start, int in_end) {
    this.lookbehind_assertion_start(start, in_start) and
    this.groupContents(start, end, in_start, in_end)
  }

  /** Holds if a negative lookbehind `(?<!...)` is at `[start, end)`. */
  predicate negativeLookbehindAssertionGroup(int start, int end, int in_start, int in_end) {
    this.negative_lookbehind_assertion_start(start, in_start) and
    this.groupContents(start, end, in_start, in_end)
  }

  // ---------------------------------------------------------------------------
  // Back-references
  // ---------------------------------------------------------------------------

  /**
   * Holds if a numbered back-reference `\1`..`\9` (or `\10` etc.) spans
   * `[start, end)` with value `value`.
   *
   * In ECMAScript, `\0` is the NUL character (not a back-reference).
   * `\1`..`\9` are always back-references. Higher numbers are back-references
   * only when there are enough groups; we accept all here for simplicity.
   */
  private predicate numbered_backreference(int start, int end, int value) {
    this.escapingChar(start) and
    // \0 is not a back-reference in ECMAScript
    not this.getChar(start + 1) = "0" and
    this.isDecimalDigit(start + 1) and
    exists(string text, string svalue, int len |
      end = start + len and
      text = this.getText() and
      len in [2 .. 3]
    |
      svalue = text.substring(start + 1, start + len) and
      value = svalue.toInt() and
      forall(int i | i in [start + 1 .. start + len - 1] | this.isDecimalDigit(i)) and
      not (
        len = 2 and
        exists(text.substring(start + 1, start + len + 1).toInt()) and
        this.isDecimalDigit(start + len)
      )
    )
  }

  /**
   * Holds if an ECMAScript named back-reference `\k<name>` spans `[start, end)`
   * with the given `name`.
   */
  private predicate named_backreference(int start, int end, string name) {
    this.escapingChar(start) and
    this.getChar(start + 1) = "k" and
    this.getChar(start + 2) = "<" and
    exists(int name_end |
      name_end = min(int i | i > start + 3 and this.getChar(i) = ">") and
      end = name_end + 1 and
      name = this.getText().substring(start + 3, name_end)
    )
  }

  /** Holds if a back-reference spans `[start, end)`. */
  predicate backreference(int start, int end) {
    this.numbered_backreference(start, end, _)
    or
    this.named_backreference(start, end, _)
  }

  /** Gets the number of the back-reference at `[start, end)`, if any. */
  int getBackrefNumber(int start, int end) { this.numbered_backreference(start, end, result) }

  /** Gets the name of the back-reference at `[start, end)`, if any. */
  string getBackrefName(int start, int end) { this.named_backreference(start, end, result) }

  // ---------------------------------------------------------------------------
  // Sequences and alternations
  // ---------------------------------------------------------------------------

  private predicate baseItem(int start, int end) {
    this.characterItem(start, end) and
    not exists(int x, int y | this.charSet(x, y) and x <= start and y >= end)
    or
    this.group(start, end)
    or
    this.charSet(start, end)
    or
    this.backreference(start, end)
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
   * Holds if `[start, end)` is a sequence of two or more items.
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
    this.characterItem(start, _) or
    this.isGroupStart(start) or
    this.charSet(start, _) or
    this.backreference(start, _)
  }

  private predicate item_end(int end) {
    this.characterItem(_, end)
    or
    exists(int endm1 | this.isGroupEnd(endm1) and end = endm1 + 1)
    or
    this.charSet(_, end)
    or
    this.qualifier(_, end, _, _)
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

  /** Holds if `[start, end)` is an alternation (two or more options separated by `|`). */
  predicate alternation(int start, int end) {
    this.top_level(start, end) and
    exists(int less | this.subalternation(start, less, _) and less < end)
  }

  /**
   * Holds if `[start, end)` is an alternation, and `[part_start, part_end)` is
   * one of its options.
   */
  predicate alternationOption(int start, int end, int part_start, int part_end) {
    this.alternation(start, end) and
    this.subalternation(start, part_end, part_start)
  }

  // ---------------------------------------------------------------------------
  // Failure to parse
  // ---------------------------------------------------------------------------

  /**
   * Holds if the character at position `i` could not be parsed as part of any
   * top-level regex construct.
   */
  predicate failedToParse(int i) {
    exists(this.getChar(i)) and
    not exists(int start, int end |
      this.top_level(start, end) and
      start <= i and
      end > i
    )
  }
}

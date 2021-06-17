import python
deprecated import semmle.python.objects.ObjectInternal as OI
private import semmle.python.ApiGraphs

/**
 * Gets the positional argument index containing the regular expression flags for the member of the
 * `re` module with the name `name`.
 */
private int re_member_flags_arg(string name) {
  name = "compile" and result = 1
  or
  name = "search" and result = 2
  or
  name = "match" and result = 2
  or
  name = "split" and result = 3
  or
  name = "findall" and result = 2
  or
  name = "finditer" and result = 2
  or
  name = "sub" and result = 4
  or
  name = "subn" and result = 4
}

/**
 * Gets the names and corresponding API nodes of members of the `re` module that are likely to be
 * methods taking regular expressions as arguments.
 *
 * This is a helper predicate that fixes a bad join order, and should not be inlined without checking
 * that this is safe.
 */
pragma[nomagic]
private API::Node relevant_re_member(string name) {
  result = API::moduleImport("re").getMember(name) and
  name != "escape"
}

/**
 * Holds if `s` is used as a regex with the `re` module, with the regex-mode `mode` (if known).
 * If regex mode is not known, `mode` will be `"None"`.
 */
predicate used_as_regex(Expr s, string mode) {
  (s instanceof Bytes or s instanceof Unicode) and
  /* Call to re.xxx(regex, ... [mode]) */
  exists(DataFlow::CallCfgNode call, string name |
    call.getArg(0).asExpr() = s and
    call = relevant_re_member(name).getACall()
  |
    mode = "None"
    or
    mode = mode_from_node([call.getArg(re_member_flags_arg(name)), call.getArgByName("flags")])
  )
}

/**
 * Gets the canonical name for the API graph node corresponding to the `re` flag `flag`. For flags
 * that have multiple names, we pick the long-form name as a canonical representative.
 */
private string canonical_name(API::Node flag) {
  result in ["ASCII", "IGNORECASE", "LOCALE", "UNICODE", "MULTILINE", "TEMPLATE"] and
  flag = API::moduleImport("re").getMember([result, result.prefix(1)])
  or
  flag = API::moduleImport("re").getMember(["DOTALL", "S"]) and result = "DOTALL"
  or
  flag = API::moduleImport("re").getMember(["VERBOSE", "X"]) and result = "VERBOSE"
}

/**
 * A type tracker for regular expression flag names. Holds if the result is a node that may refer
 * to the `re` flag with the canonical name `flag_name`
 */
private DataFlow::LocalSourceNode re_flag_tracker(string flag_name, DataFlow::TypeTracker t) {
  t.start() and
  exists(API::Node flag | flag_name = canonical_name(flag) and result = flag.getAUse())
  or
  exists(BinaryExprNode binop, DataFlow::Node operand |
    operand.getALocalSource() = re_flag_tracker(flag_name, t.continue()) and
    operand.asCfgNode() = binop.getAnOperand() and
    (binop.getOp() instanceof BitOr or binop.getOp() instanceof Add) and
    result.asCfgNode() = binop
  )
  or
  exists(DataFlow::TypeTracker t2 | result = re_flag_tracker(flag_name, t2).track(t2, t))
}

/**
 * A type tracker for regular expression flag names. Holds if the result is a node that may refer
 * to the `re` flag with the canonical name `flag_name`
 */
private DataFlow::Node re_flag_tracker(string flag_name) {
  re_flag_tracker(flag_name, DataFlow::TypeTracker::end()).flowsTo(result)
}

/** Gets a regular expression mode flag associated with the given data flow node. */
string mode_from_node(DataFlow::Node node) { node = re_flag_tracker(result) }

/**
 * DEPRECATED 2021-02-24 -- use `mode_from_node` instead.
 *
 * Gets a regular expression mode flag associated with the given value.
 */
deprecated string mode_from_mode_object(Value obj) {
  (
    result = "DEBUG" or
    result = "IGNORECASE" or
    result = "LOCALE" or
    result = "MULTILINE" or
    result = "DOTALL" or
    result = "UNICODE" or
    result = "VERBOSE"
  ) and
  exists(int flag |
    flag = Value::named("sre_constants.SRE_FLAG_" + result).(OI::ObjectInternal).intValue() and
    obj.(OI::ObjectInternal).intValue().bitAnd(flag) = flag
  )
}

/** A StrConst used as a regular expression */
abstract class RegexString extends Expr {
  RegexString() { (this instanceof Bytes or this instanceof Unicode) }

  override string toString() {
    result = this.(Bytes).getText()
    or
    result = this.(Unicode).getText()
  }

  /** result is true for those start chars that actually mark a start of a char set. */
  boolean char_set_start(int pos) {
    exists(int index |
      char_set_delimiter(index, pos) = true and
      (
        index = 1 and result = true // if a '[' is first in the string (among brackets), it starts a char set
        or
        exists(int p |
          char_set_delimiter(index - 1, p) = false and // if it is preceded by a closing bracket, it starts a char set
          if char_set_delimiter(index - 2, p) = true // but the closing bracket only closes...
          then result = char_set_start(p - 1).booleanNot() // ...if it is not the first in a char set
          else result = true
        )
      )
    )
  }

  /** result denotes if the index is a left bracket */
  boolean char_set_delimiter(int index, int pos) {
    pos = rank[index](int p | this.nonEscapedCharAt(p) = "[" or this.nonEscapedCharAt(p) = "]") and
    (
      this.nonEscapedCharAt(pos) = "[" and result = true
      or
      this.nonEscapedCharAt(pos) = "]" and result = false
    )
  }

  // This is imprecise, consider the example:
  //    r'[[]'
  // where we would report both `start`=0 and `start`=1.
  predicate char_set_start(int start, int end) {
    // this.nonEscapedCharAt(start) = "[" and
    this.char_set_start(start) = true and
    (
      this.getChar(start + 1) = "^" and end = start + 2
      or
      not this.getChar(start + 1) = "^" and end = start + 1
    )
  }

  /** Whether there is a character class, between start (inclusive) and end (exclusive) */
  predicate charSet(int start, int end) {
    exists(int inner_start, int inner_end |
      this.char_set_start(start, inner_start) and
      not this.char_set_start(_, start)
    |
      end = inner_end + 1 and
      inner_end > inner_start and
      this.nonEscapedCharAt(inner_end) = "]" and
      not exists(int mid | this.nonEscapedCharAt(mid) = "]" | mid > inner_start and mid < inner_end)
    )
  }

  predicate char_set_token(int charset_start, int index, int token_start, int token_end) {
    token_start =
      rank[index](int start, int end | this.char_set_token(charset_start, start, end) | start) and
    this.char_set_token(charset_start, token_start, token_end)
  }

  /** Either a char or a - */
  predicate char_set_token(int charset_start, int start, int end) {
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

  predicate charRange(int charset_start, int start, int lower_end, int upper_start, int end) {
    exists(int index |
      this.charRangeEnd(charset_start, index) = true and
      this.char_set_token(charset_start, index - 2, start, lower_end) and
      this.char_set_token(charset_start, index, upper_start, end)
    )
  }

  private boolean charRangeEnd(int charset_start, int index) {
    this.char_set_token(charset_start, index, _, _) and
    (
      index in [1, 2] and result = false
      or
      exists(int lower_start, int connector_start, int upper_start |
        this.char_set_token(charset_start, index - 2, lower_start, _) and
        not this.nonEscapedCharAt(lower_start) = "-" and
        this.char_set_token(charset_start, index - 1, connector_start, _) and
        this.nonEscapedCharAt(connector_start) = "-" and
        this.char_set_token(charset_start, index, upper_start, _) and
        not this.nonEscapedCharAt(upper_start) = "-" and
        result =
          this.charRangeEnd(charset_start, index - 2)
              .booleanNot()
              .booleanAnd(this.charRangeEnd(charset_start, index - 1).booleanNot())
      )
      or
      not exists(int lower_start, int connector_start, int upper_start |
        this.char_set_token(charset_start, index - 2, lower_start, _) and
        not this.nonEscapedCharAt(lower_start) = "-" and
        this.char_set_token(charset_start, index - 1, connector_start, _) and
        this.nonEscapedCharAt(connector_start) = "-" and
        this.char_set_token(charset_start, index, upper_start, _) and
        not this.nonEscapedCharAt(upper_start) = "-"
      ) and
      result = false
    )
  }

  predicate escapingChar(int pos) { this.escaping(pos) = true }

  private boolean escaping(int pos) {
    pos = -1 and result = false
    or
    this.getChar(pos) = "\\" and result = this.escaping(pos - 1).booleanNot()
    or
    this.getChar(pos) != "\\" and result = false
  }

  /** Gets the text of this regex */
  string getText() {
    result = this.(Unicode).getS()
    or
    result = this.(Bytes).getS()
  }

  string getChar(int i) { result = this.getText().charAt(i) }

  string nonEscapedCharAt(int i) {
    result = this.getText().charAt(i) and
    not exists(int x, int y | this.escapedCharacter(x, y) and i in [x .. y - 1])
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

  /** Named unicode characters, eg \N{degree sign} */
  private predicate escapedName(int start, int end) {
    this.escapingChar(start) and
    this.getChar(start + 1) = "N" and
    this.getChar(start + 2) = "{" and
    this.getChar(end - 1) = "}" and
    end > start and
    not exists(int i | start + 2 < i and i < end - 1 | this.getChar(i) = "}")
  }

  predicate escapedCharacter(int start, int end) {
    this.escapingChar(start) and
    not exists(this.getText().substring(start + 1, end + 1).toInt()) and
    (
      // hex value \xhh
      this.getChar(start + 1) = "x" and end = start + 4
      or
      // octal value \ooo
      end in [start + 2 .. start + 4] and
      exists(this.getText().substring(start + 1, end).toInt())
      or
      // 16-bit hex value \uhhhh
      this.getChar(start + 1) = "u" and end = start + 6
      or
      // 32-bit hex value \Uhhhhhhhh
      this.getChar(start + 1) = "U" and end = start + 10
      or
      escapedName(start, end)
      or
      // escape not handled above, update when adding a new case
      not this.getChar(start + 1) in ["x", "u", "U", "N"] and
      end = start + 2
    )
  }

  predicate inCharSet(int index) {
    exists(int x, int y | this.charSet(x, y) and index in [x + 1 .. y - 2])
  }

  /*
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
        start > y and start < z - 2 and not c = "-"
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
      result = this.getText().substring(start + 4, name_end - 1)
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

  predicate negativeLookaheadAssertionGroup(int start, int end) {
    exists(int in_start | this.negative_lookahead_assertion_start(start, in_start) |
      this.groupContents(start, end, in_start, _)
    )
  }

  predicate negativeLookbehindAssertionGroup(int start, int end) {
    exists(int in_start | this.negative_lookbehind_assertion_start(start, in_start) |
      this.groupContents(start, end, in_start, _)
    )
  }

  predicate positiveLookaheadAssertionGroup(int start, int end) {
    exists(int in_start | this.lookahead_assertion_start(start, in_start) |
      this.groupContents(start, end, in_start, _)
    )
  }

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
    this.comment_group_start(start, end)
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
    this.getChar(start + 2) = "P" and
    this.getChar(start + 3) = "<" and
    not this.getChar(start + 4) = "=" and
    not this.getChar(start + 4) = "!" and
    exists(int name_end |
      name_end = min(int i | i > start + 4 and this.getChar(i) = ">") and
      end = name_end + 1
    )
  }

  private predicate named_backreference_start(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "P" and
    this.getChar(start + 3) = "=" and
    end = min(int i | i > start + 4 and this.getChar(i) = "?")
  }

  private predicate flag_group_start(int start, int end, string c) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    end = start + 3 and
    c = this.getChar(start + 2) and
    (
      c = "i" or
      c = "L" or
      c = "m" or
      c = "s" or
      c = "u" or
      c = "x"
    )
  }

  /**
   * Gets the mode of this regular expression string if
   * it is defined by a prefix.
   */
  string getModeFromPrefix() {
    exists(string c | this.flag_group_start(_, _, c) |
      c = "i" and result = "IGNORECASE"
      or
      c = "L" and result = "LOCALE"
      or
      c = "m" and result = "MULTILINE"
      or
      c = "s" and result = "DOTALL"
      or
      c = "u" and result = "UNICODE"
      or
      c = "x" and result = "VERBOSE"
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

  private predicate comment_group_start(int start, int end) {
    this.isGroupStart(start) and
    this.getChar(start + 1) = "?" and
    this.getChar(start + 2) = "#" and
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
    exists(string text, string svalue, int len |
      end = start + len and
      text = this.getText() and
      len in [2 .. 3]
    |
      svalue = text.substring(start + 1, start + len) and
      value = svalue.toInt() and
      not exists(text.substring(start + 1, start + len + 1).toInt()) and
      value != 0
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
    not this.getChar(end) = "?"
    or
    exists(int short_end | this.short_qualifier(start, short_end, maybe_empty, may_repeat_forever) |
      if this.getChar(short_end) = "?" then end = short_end + 1 else end = short_end
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

  predicate multiples(int start, int end, string lower, string upper) {
    this.getChar(start) = "{" and
    this.getChar(end - 1) = "}" and
    exists(string inner | inner = this.getText().substring(start + 1, end - 1) |
      inner.regexpMatch("[0-9]+") and
      lower = inner and
      upper = lower
      or
      inner.regexpMatch("[0-9]*,[0-9]*") and
      exists(int commaIndex | commaIndex = inner.indexOf(",") |
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

  predicate qualifiedPart(
    int start, int part_end, int end, boolean maybe_empty, boolean may_repeat_forever
  ) {
    this.baseItem(start, part_end) and
    this.qualifier(part_end, end, maybe_empty, may_repeat_forever)
  }

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
    this.backreference(start, _)
  }

  private predicate item_end(int end) {
    this.character(_, end)
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
    ) and
    this.lastPart(start, end)
  }
}

/** A StrConst used as a regular expression */
class Regex extends RegexString {
  Regex() { used_as_regex(this, _) }

  /**
   * Gets a mode (if any) of this regular expression. Can be any of:
   * DEBUG
   * IGNORECASE
   * LOCALE
   * MULTILINE
   * DOTALL
   * UNICODE
   * VERBOSE
   */
  string getAMode() {
    result != "None" and
    used_as_regex(this, result)
    or
    result = this.getModeFromPrefix()
  }
}

import python
import semmle.python.objects.ObjectInternal

private predicate re_module_function(string name, int flags) {
  name = "compile" and flags = 1
  or
  name = "search" and flags = 2
  or
  name = "match" and flags = 2
  or
  name = "split" and flags = 3
  or
  name = "findall" and flags = 2
  or
  name = "finditer" and flags = 2
  or
  name = "sub" and flags = 4
  or
  name = "subn" and flags = 4
}

/**
 * Holds if `s` is used as a regex with the `re` module, with the regex-mode `mode` (if known).
 * If regex mode is not known, `mode` will be `"None"`.
 */
predicate used_as_regex(Expr s, string mode) {
  (s instanceof Bytes or s instanceof Unicode) and
  /* Call to re.xxx(regex, ... [mode]) */
  exists(CallNode call, string name |
    call.getArg(0).pointsTo(_, _, s.getAFlowNode()) and
    call.getFunction().pointsTo(Module::named("re").attr(name)) and
    not name = "escape"
  |
    mode = "None"
    or
    exists(Value obj | mode = mode_from_mode_object(obj) |
      exists(int flags_arg |
        re_module_function(name, flags_arg) and
        call.getArg(flags_arg).pointsTo(obj)
      )
      or
      call.getArgByName("flags").pointsTo(obj)
    )
  )
}

string mode_from_mode_object(Value obj) {
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
    flag = Value::named("sre_constants.SRE_FLAG_" + result).(ObjectInternal).intValue() and
    obj.(ObjectInternal).intValue().bitAnd(flag) = flag
  )
}

/** A StrConst used as a regular expression */
abstract class RegexString extends Expr {
  RegexString() { (this instanceof Bytes or this instanceof Unicode) }

  predicate char_set_start(int start, int end) {
    this.nonEscapedCharAt(start) = "[" and
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
    not this.escapingChar(i - 1)
  }

  private predicate isOptionDivider(int i) { this.nonEscapedCharAt(i) = "|" }

  private predicate isGroupEnd(int i) { this.nonEscapedCharAt(i) = ")" }

  private predicate isGroupStart(int i) { this.nonEscapedCharAt(i) = "(" }

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

  private predicate escapedCharacter(int start, int end) {
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

  private predicate inCharSet(int index) {
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
      not this.qualifier(start, _, _)
    )
  }

  predicate character(int start, int end) {
    (
      this.simpleCharacter(start, end) and
      not exists(int x, int y | this.escapedCharacter(x, y) and x <= start and y >= end)
      or
      this.escapedCharacter(start, end)
    ) and
    not exists(int x, int y | this.group_start(x, y) and x <= start and y >= end)
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
    positiveLookaheadAssertionGroup(start, end)
    or
    this.positiveLookbehindAssertionGroup(start, end)
  }

  private predicate emptyGroup(int start, int end) {
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

  private predicate positiveLookaheadAssertionGroup(int start, int end) {
    exists(int in_start | this.lookahead_assertion_start(start, in_start) |
      this.groupContents(start, end, in_start, _)
    )
  }

  private predicate positiveLookbehindAssertionGroup(int start, int end) {
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
  }

  private predicate qualifier(int start, int end, boolean maybe_empty) {
    this.short_qualifier(start, end, maybe_empty) and not this.getChar(end) = "?"
    or
    exists(int short_end | this.short_qualifier(start, short_end, maybe_empty) |
      if this.getChar(short_end) = "?" then end = short_end + 1 else end = short_end
    )
  }

  private predicate short_qualifier(int start, int end, boolean maybe_empty) {
    (
      this.getChar(start) = "+" and maybe_empty = false
      or
      this.getChar(start) = "*" and maybe_empty = true
      or
      this.getChar(start) = "?" and maybe_empty = true
    ) and
    end = start + 1
    or
    exists(int endin | end = endin + 1 |
      this.getChar(start) = "{" and
      this.getChar(endin) = "}" and
      end > start and
      exists(string multiples | multiples = this.getText().substring(start + 1, endin) |
        multiples.regexpMatch("0+") and maybe_empty = true
        or
        multiples.regexpMatch("0*,[0-9]*") and maybe_empty = true
        or
        multiples.regexpMatch("0*[1-9][0-9]*") and maybe_empty = false
        or
        multiples.regexpMatch("0*[1-9][0-9]*,[0-9]*") and maybe_empty = false
      ) and
      not exists(int mid |
        this.getChar(mid) = "}" and
        mid > start and
        mid < endin
      )
    )
  }

  /**
   * Whether the text in the range start,end is a qualified item, where item is a character,
   * a character set or a group.
   */
  predicate qualifiedItem(int start, int end, boolean maybe_empty) {
    this.qualifiedPart(start, _, end, maybe_empty)
  }

  private predicate qualifiedPart(int start, int part_end, int end, boolean maybe_empty) {
    this.baseItem(start, part_end) and
    this.qualifier(part_end, end, maybe_empty)
  }

  private predicate item(int start, int end) {
    this.qualifiedItem(start, end, _)
    or
    this.baseItem(start, end) and not this.qualifier(end, _, _)
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
    not this.qualifiedItem(start, end, _)
  }

  private predicate sequenceOrQualified(int start, int end) {
    this.subsequence(start, end) and
    not this.item_start(end)
  }

  private predicate item_start(int start) {
    this.character(start, _) or
    this.isGroupStart(start) or
    this.charSet(start, _)
  }

  private predicate item_end(int end) {
    this.character(_, end)
    or
    exists(int endm1 | this.isGroupEnd(endm1) and end = endm1 + 1)
    or
    this.charSet(_, end)
    or
    this.qualifier(_, end, _)
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
      this.qualifiedItem(x, start, true) or
      this.specialCharacter(x, start, "^")
    )
    or
    exists(int y | this.firstPart(start, y) |
      this.item(start, end)
      or
      this.qualifiedPart(start, end, y, _)
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
      this.qualifiedItem(end, y, true)
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
    exists(int y | this.lastPart(start, y) | this.qualifiedPart(start, end, y, _))
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
      this.qualifiedItem(start, end, _)
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
      this.qualifiedItem(start, end, _)
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

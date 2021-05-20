import Parser
private import RegexLiteral

module RegexSpecific {
  predicate allowedEmptyClasses() { none() }
}

import RegexSpecific as Conf

class RegexParserConfiguration extends ParserConfiguration {
  RegexParserConfiguration() { this = "Extended regex parser configuration" }

  override predicate hasTokenRegex(string regex) {
    regex = "[()|*+?\\-\\[\\]]"
    or
    regex = "\\[\\^"
  }

  override predicate hasTokenRegex(string regex, string id) {
    regex = "[^()|.$\\^\\[\\]\\\\]" and id = "normalchar"
    or
    regex = "\\\\[0-9]+" and id = "backref"
    or
    regex = "\\(\\?P=\\w+\\)" and id = "backref"
    or
    regex = "[.]" and id = "anychar"
    or
    regex = "[$]" and id = "dollar"
    or
    regex = "[\\^]" and id = "caret"
    or
    regex = "\\{[0-9]+\\}" and id = "fixedrepeat"
    or
    regex = "\\{,[0-9]+\\}" and id = "uptorepeat"
    or
    regex = "\\{[0-9]+,[0-9]+\\}" and id = "rangerepeat"
    or
    regex = "\\{[0-9]+,\\}" and id = "openrepeat"
    or
    regex = "\\\\[^AbBdDsSwWZafnNrtuUvx\\\\0-9]" and id = "normalchar"
    or
    regex = "\\\\[AbBdDsSwWZafnNrtuUvx\\\\]" and id = "escclass"
    or
    regex = "\\(\\?[aiLmsux]+\\)" and id = "confgroup"
    or
    regex = "\\(\\?:" and id = "("
    or
    regex = "\\(\\?[aiLmsux]*-[imsx]+:" and id = "("
    or
    regex = "\\(\\?#" and id = "(?#"
    or
    regex = "\\(\\?=" and id = "(?="
    or
    regex = "\\(\\?!" and id = "(?!"
    or
    regex = "\\(\\?<=" and id = "(?<="
    or
    regex = "\\(\\?<!" and id = "(?<!"
    or
    regex = "\\(\\?P<\\w+>" and id = "(named"
  }

  /*
   * Use a proper unambiguous grammar for regexes:
   *
   * regex -> orregex
   * orregex -> seqregex
   * |      orregex '|' seqregex
   * |      '|' seqregex
   * |      orregex '|'
   * seqregex -> primary
   * |      primary seqregex
   * primary -> group
   * |      primary '*'
   * |      primary '+'
   * |      primary '?'
   * |      char
   * |      class
   * |      escclass
   * group -> '(' regex ')'
   * |      '(?#' regex ')'
   * |      '(?=' regex ')'
   * |      '(?!' regex ')'
   * |      '(?<=' regex ')'
   * |      '(?<!' regex ')'
   * |      '(named' regex ')'
   * |      confgroup
   * class -> '[' classinner ']'
   * |      '[^' classinner ']'
   * |      '[]'  if allowed empty classes
   * |      '[^]' if allowed empty classes
   * classinner -> classstart classinner1
   * |      classstart
   * |      classinner1
   * classstart -> ']'
   * classinner1 -> classpart
   * |      classpart classinner1
   * |      classpart_c
   * |      classpart_c-
   * |      '-'
   * classpart_c -> clschar
   *        classpart_c clschar
   *        classpart clschar
   * classpart_c- -> classpart_c '-'
   * classpart -> // does not end in a clschar
   * |      escclass
   * |      classpart_c escclass
   * |      classpart_c- escclass
   * |      classpart_c- '-'
   * |      classrange
   * classrange -> clschar '-' clschar
   * clschar -> normalchar
   * |      anychar
   * |      '(', ')', '|', '+', '*', '?'
   *
   * Things that currently don't parse:
   * - Empty regexes (as standalone empty strings, or part of a group, e.g. `()`)
   *
   * Things that parse but with the wrong semantics:
   * - Most escape sequences with special meanings (i.e. besides "quote the next character" or predefined character classes)
   */

  override string rule(string a) {
    a in ["char", "anychar", "dollar", "caret", "backref", "class", "escclass", "group"] and
    result = "primary"
    or
    a = "primary" and result = "seqregex"
    or
    // a = "orregex|" and result = "orregex"
    // or
    a = "seqregex" and result = "orregex"
    or
    a = "orregex" and result = "regex"
    or
    a = "confgroup" and result = "group"
    or
    a in ["normalchar", "-", "]"] and
    result = "char"
    or
    a in ["normalchar", "anychar", "()|+*?[".charAt(_)] and result = "clschar"
    or
    a in ["classstart", "classinner1"] and result = "classinner"
    or
    a in ["classpart", "classpart_c", "classpart_c-", "-"] and result = "classinner1"
    or
    a = "]" and not Conf::allowedEmptyClasses() and result = "classstart"
    or
    a in ["classrange", "escclass"] and result = "classpart"
    or
    a = "clschar" and result = "classpart_c"
  }

  override string rule(string a, string b) {
    a = "|" and b = "seqregex" and result = "orregex"
    or
    a = "orregex" and b = "|" and result = "orregex"
    or
    a = "primary" and b = "seqregex" and result = "seqregex"
    or
    a = "primary" and b = "*" and result = "primary"
    or
    a = "primary" and b = "+" and result = "primary"
    or
    a = "primary" and b = "?" and result = "primary"
    or
    a = "primary" and b = "fixedrepeat" and result = "primary"
    or
    a = "primary" and b = "rangerepeat" and result = "primary"
    or
    a = "primary" and b = "uptorepeat" and result = "primary"
    or
    a = "primary" and b = "openrepeat" and result = "primary"
    or
    a in ["[", "[^"] and b = "]" and Conf::allowedEmptyClasses() and result = "class"
    or
    a = "classstart" and b = "classinner1" and result = "classinner"
    or
    a = "classpart" and b = "classinner1" and result = "classinner1"
    or
    a in ["classpart", "classpart_c"] and b = "clschar" and result = "classpart_c"
    or
    a = "classpart_c" and b = "-" and result = "classpart_c-"
    or
    a = "classpart_c" and b = "escclass" and result = "classpart"
    or
    a = "classpart_c-" and b = "escclass" and result = "classpart"
    or
    a = "classpart_c-" and b = "-" and result = "classpart"
  }

  override string rule(string a, string b, string c) {
    a = "orregex" and b = "|" and c = "seqregex" and result = "orregex"
    or
    a = "(" and b = "regex" and c = ")" and result = "group"
    or
    a = "(?#" and b = "regex" and c = ")" and result = "group"
    or
    a = "(?=" and b = "regex" and c = ")" and result = "group"
    or
    a = "(?!" and b = "regex" and c = ")" and result = "group"
    or
    a = "(?<=" and b = "regex" and c = ")" and result = "group"
    or
    a = "(?<!" and b = "regex" and c = ")" and result = "group"
    or
    a = "(named" and b = "regex" and c = ")" and result = "group"
    or
    a = "[" and b = "classinner" and c = "]" and result = "class"
    or
    a = "[^" and b = "classinner" and c = "]" and result = "class"
    or
    a = "clschar" and b = "-" and c = "clschar" and result = "classrange"
  }
}

class Regex extends Node {
  Regex() { this.hasId("regex") }
}

bindingset[t]
private string getChar(string t) {
  t.length() = 1 and
  result = t
  or
  exists(string c |
    t.charAt(0) = "\\" and
    t.charAt(1) = c and
    result = c
  )
}

class ChRegex extends Regex {
  ChRegex() { this.hasId("char") and not this.getParent*() instanceof ClassRegex }

  string getChar() { result = getChar(this.getText()) }
}

class ClassRegex extends Regex {
  ClassRegex() { this.hasId("class") }

  predicate isInverted() { this.getLeftNode().getLeftNode().hasId("[^") }
}

class EscapeClassRegex extends Regex {
  EscapeClassRegex() { id = "escclass" }

  string getClass() { result = getText().charAt(1) }
}

class ClassChar extends Node {
  ClassRegex reg;

  ClassChar() {
    this.getParent*() = reg and
    (
      this.hasId("clschar")
      or
      this.getId() = "-" and
      not this.getParent().getParent().getId() = "clschar-clschar"
      or
      this.getId() = "]" and
      not this = reg.getRightNode()
    )
  }

  string getChar() { result = getChar(this.getText()) }

  ClassRegex getClass() { result = reg }
}

abstract class SpecialCharRegex extends Regex { }

class DotRegex extends SpecialCharRegex {
  DotRegex() { id = "anychar" and not this.getParent*() instanceof ClassRegex }
}

class DollarRegex extends SpecialCharRegex {
  DollarRegex() { id = "dollar" and not this.getParent*() instanceof ClassRegex }
}

class CaretRegex extends SpecialCharRegex {
  CaretRegex() { id = "caret" and not this.getParent*() instanceof ClassRegex }
}

class ClassRange extends Node {
  ClassRange() { id = "clschar-clschar" }

  ClassChar getLowerBound() { result = getLeftNode().getLeftNode() }

  ClassChar getUpperBound() { result = getRightNode() }
}

class SequenceRegex extends Regex {
  SequenceRegex() {
    this.hasId("primaryseqregex") and not this.getParent().getId() = "primaryseqregex"
  }

  Regex getLeft() { result = this.getLeftNode() }

  Regex getRight() { result = this.getRightNode() }
}

abstract class SuffixRegex extends Regex {
  Regex getBody() {
    if this.isNonGreedy()
    then result = this.getLeftNode().getLeftNode()
    else result = this.getLeftNode()
  }

  abstract predicate isMaybeEmpty();

  abstract predicate isNonGreedy();
}

abstract class UnboundedRegex extends SuffixRegex { }

abstract class RepeatRegex extends SuffixRegex {
  abstract int getLowerBound();

  abstract int getUpperBound();

  override predicate isMaybeEmpty() { getLowerBound() = 0 }

  override predicate isNonGreedy() { none() }
}

class StarRegex extends UnboundedRegex {
  boolean nonGreedy;

  StarRegex() {
    id = "primary*" and not this.getParent().getId() = "primary?" and nonGreedy = false
    or
    id = "primary?" and this.getLeftNode().getId() = "primary*" and nonGreedy = true
  }

  override predicate isMaybeEmpty() { any() }

  override predicate isNonGreedy() { nonGreedy = true }
}

class PlusRegex extends UnboundedRegex {
  boolean nonGreedy;

  PlusRegex() {
    id = "primary+" and not this.getParent().getId() = "primary?" and nonGreedy = false
    or
    id = "primary?" and this.getLeftNode().getId() = "primary+" and nonGreedy = true
  }

  override predicate isMaybeEmpty() { none() }

  override predicate isNonGreedy() { nonGreedy = true }
}

class FixedRepeatRegex extends SuffixRegex, RepeatRegex {
  FixedRepeatRegex() { id = "primaryfixedrepeat" }

  override int getLowerBound() {
    exists(string suff, string num |
      suff = getRightNode().getText() and
      suff = "{" + num + "}" and
      result = num.toInt()
    )
  }

  override int getUpperBound() { result = getLowerBound() }
}

class UptoRepeatRegex extends SuffixRegex, RepeatRegex {
  UptoRepeatRegex() { id = "primaryuptorepeat" }

  override int getLowerBound() { result = 0 }

  override int getUpperBound() {
    exists(string suff, string num |
      suff = getRightNode().getText() and
      suff = "{," + num + "}" and
      result = num.toInt()
    )
  }
}

class RangeRegex extends SuffixRegex, RepeatRegex {
  RangeRegex() { id = "primaryrangerepeat" }

  override int getLowerBound() {
    exists(string suff, string numl |
      suff = getRightNode().getText() and
      numl = suff.regexpCapture("\\{([0-9]+),([0-9]+)\\}", 1) and
      result = numl.toInt()
    )
  }

  override int getUpperBound() {
    exists(string suff, string numh |
      suff = getRightNode().getText() and
      numh = suff.regexpCapture("\\{([0-9]+),([0-9]+)\\}", 2) and
      result = numh.toInt()
    )
  }
}

class OpenRepeatRegex extends UnboundedRegex, RepeatRegex {
  OpenRepeatRegex() { id = "primaryopenrepeat" }

  override int getLowerBound() {
    exists(string suff, string num |
      suff = getRightNode().getText() and
      suff = "{" + num + ",}" and
      result = num.toInt()
    )
  }

  override int getUpperBound() { none() }
}

class OptionalRegex extends SuffixRegex {
  boolean nonGreedy;

  OptionalRegex() {
    id = "primary?" and
    not this.getLeftNode().getId() = "primary*" and
    not this.getLeftNode().getId() = "primary+" and
    if this.getLeftNode().getId() = "primary?" then nonGreedy = true else nonGreedy = false
  }

  override predicate isMaybeEmpty() { any() }

  override predicate isNonGreedy() { nonGreedy = true }
}

abstract class OrRegex extends Regex {
  abstract Regex getLeft();

  abstract Regex getRight();
}

class FullOrRegex extends OrRegex {
  FullOrRegex() { id = "orregex|seqregex" }

  override Regex getLeft() { result = this.getLeftNode().getLeftNode() }

  override Regex getRight() { result = this.getRightNode() }
}

class LeftOrRegex extends OrRegex {
  LeftOrRegex() { id = "orregex|" and not this.getParent() instanceof FullOrRegex }

  override Regex getLeft() { result = this.getLeftNode() }

  override Regex getRight() { none() }
}

class RightOrRegex extends OrRegex {
  RightOrRegex() { id = "|seqregex" }

  override Regex getLeft() { none() }

  override Regex getRight() { result = this.getRightNode() }
}

class CaptureRegex extends Regex {
  CaptureRegex() { id = "(regex)" }

  Regex getBody() { result = this.getLeftNode().getRightNode() }
}

class BackrefRegex extends Regex {
  BackrefRegex() { this.hasId("backref") } //id = "backref" }
}

class GroupRegex extends Regex {
  GroupRegex() { this.hasId("group") }

  Regex getContents() { result = this.getLeftNode().getRightNode() }
}

class ConfGroupRegex extends GroupRegex {
  ConfGroupRegex() { this.hasId("confgroup") }
}

abstract class AssertionGroupRegex extends GroupRegex { }

class NegativeLookaheadRegex extends AssertionGroupRegex {
  NegativeLookaheadRegex() { id = "(?!regex)" }
}

class NegativeLookbehindRegex extends AssertionGroupRegex {
  NegativeLookbehindRegex() { id = "(?<!regex)" }
}

class PositiveLookaheadRegex extends AssertionGroupRegex {
  PositiveLookaheadRegex() { id = "(?=regex)" }
}

class PositiveLookbehindRegex extends AssertionGroupRegex {
  PositiveLookbehindRegex() { id = "(?<=regex)" }
}

class ParsedRegex extends Regex {
  ParsedRegex() { this.isRoot() }
}

string testTokenize(ParsedString text, string id, int pos, int seq) {
  // text.toString() = "\\|\\[\\][123]|\\{\\}" and
  // text.toString() = "\\A[+-]?\\d+" and
  text.toString() = "\\[(?P<txt>[^[]*)\\]\\((?P<uri>[^)]*)" and
  // text.toString() = "(?m)^(?!$)" and
  result = tokenize(text, id, pos, seq)
}

predicate testRegex() {
  "(?P<uri>".regexpMatch("\\(\\?P<\\w+>")
  // "n1".regexpMatch("\\w+")
}

predicate testParse(ParsedString s, int start, int next, string id) {
  // s = "\\A[+-]?\\d+" and
  // s = "\\|\\[\\][123]|\\{\\}" and
  // s = "\\[(?P<txt>[^[]*)\\]\\((?P<uri>[^)]*)" and
  s = "012345678" and
  s.nodes(start, next, id)
}

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

  predicate testRegex() {
    //  "(?P<n1>".regexpMatch("\\(\\?P<[:alnum:]+>")
    "n1".regexpMatch("\\w+")
  }

  /*
   * Use a proper unambiguous grammar for regexes:
   *
   * regex -> orregex
   * orregex -> seqregex
   * |      orregex '|' seqregex
   * seqregex -> primary
   * |      primary seqregex
   * primary -> group
   * |      primary *
   * |      primary +
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
   * classinner1 -> classinner2 '-'
   * |      classinner2
   * classinner2 -> classpart
   * |      classpart classinner2
   * classstart -> '-'
   * |      ']' if not allowed empty classes
   * |      classpart
   * classpart -> normalchar
   * |      classrange
   * |      escclass
   * classrange -> normalchar '-' normalchar
   *
   *
   * Things that currently don't parse:
   * - Empty regexes (as standalone empty strings, or part of a disjunction or group, e.g. `(a|)` or `()`)
   * - Inline options, i.e. `(?s)`
   * - Lookaheads/lookbehinds
   * - Java specific: Nested character classes, intersecting character classes
   *
   * Things that parse but with the wrong semantics:
   * - Possesive and reluctant quantifiers (`a*?` is treated as an optional regex with body `a*`)
   * - Most escape sequences with special meanings (i.e. besides "quote the next character" or predefined character classes)
   */

  override string rule(string a) {
    a in ["char", "anychar", "dollar", "caret", "backref", "class", "escclass", "group"] and
    result = "primary"
    or
    a = "primary" and result = "seqregex"
    or
    a = "seqregex" and result = "orregex"
    or
    a = "orregex" and result = "regex"
    or
    a = "confgroup" and result = "group"
    or
    a in ["normalchar", "-", "]"] and
    result = "char"
    or
    a in ["normalchar", "anychar", "()|+*?".charAt(_)] and result = "clschar"
    or
    a = "classstart" and result = "classinner"
    or
    a = "classinner2" and result = "classinner1"
    or
    a in ["classpart", "-"] and result = "classstart"
    or
    a = "classpart" and result = "classinner2"
    or
    a = "]" and not Conf::allowedEmptyClasses() and result = "classstart"
    or
    a in ["clschar", "classrange", "escclass"] and result = "classpart"
  }

  override string rule(string a, string b) {
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
    a = "classpart" and b = "classinner2" and result = "classinner2"
    or
    a = "classinner2" and b = "-" and result = "classinner1"
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
  SequenceRegex() { id = "primaryseqregex" }

  Regex getLeft() { result = this.getLeftNode() }

  Regex getRight() { result = this.getRightNode() }
}

abstract class SuffixRegex extends Regex {
  Regex getBody() { result = this.getLeftNode() }
}

abstract class UnboundedRegex extends SuffixRegex { }

abstract class RepeatRegex extends SuffixRegex {
  abstract int getLowerBound();

  abstract int getUpperBound();
}

class StarRegex extends UnboundedRegex {
  StarRegex() { id = "primary*" }
}

class PlusRegex extends UnboundedRegex {
  PlusRegex() { id = "primary+" }
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
  OptionalRegex() { id = "primary?" }
}

class OrRegex extends Regex {
  OrRegex() { id = "orregex|seqregex" }

  Regex getLeft() { result = this.getLeftNode().getLeftNode() }

  Regex getRight() { result = this.getRightNode() }
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
}

class ConfGroupRegex extends Regex {
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
  // text.toString() = "\\A[+-]?\\d+" and
  text.toString() = "\\[(?P<txt>[^[]*)\\]\\((?P<uri>[^)]*)" and
  result = tokenize(text, id, pos, seq)
}

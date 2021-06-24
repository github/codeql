import python
import semmle.python.RegexTreeView

predicate kind(RegExpTerm term, string kind) {
  // kind = "term"  // consider this for completeness
  // or
  term instanceof RegExpQuantifier and kind = "quantifier"
  or
  term instanceof RegExpPlus and kind = "plus"
  or
  term instanceof RegExpStar and kind = "star"
  or
  term instanceof RegExpRange and kind = "range"
  or
  term instanceof RegExpAlt and kind = "alt"
  or
  term instanceof RegExpCharacterClass and kind = "char"
  or
  term instanceof RegExpCharacterClassEscape and kind = "charEsc"
  or
  term instanceof RegExpLookbehind and kind = "lookbehind"
  or
  term instanceof RegExpConstant and kind = "constant"
  or
  term instanceof RegExpCharacterRange and kind = "charRange"
  or
  term instanceof RegExpGroup and kind = "group"
  or
  term instanceof RegExpOpt and kind = "opt"
  or
  term instanceof RegExpDot and kind = "dot"
  or
  term instanceof RegExpSequence and kind = "sequence"
  or
  term instanceof RegExpDollar and kind = "dollar"
  or
  term instanceof RegExpCaret and kind = "caret"
}

from RegExpTerm rt, string kind
where
  rt.getFile().getBaseName() = "redos.py" and
  kind(rt, kind)
select rt, kind

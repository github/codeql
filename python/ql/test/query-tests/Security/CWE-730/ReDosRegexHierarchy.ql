import python
import semmle.python.RegexTreeView

query predicate seqChild(RegExpSequence s, RegExpTerm r, int i) { r = s.getChild(i) }

query predicate orChild(RegExpAlt s, RegExpTerm r, int i) { r = s.getChild(i) }

query predicate quantifierChild(RegExpQuantifier s, RegExpTerm r, int i) { r = s.getChild(i) }

query predicate classChild(
  RegExpCharacterClass s, RegExpTerm r, int i, boolean inverted, boolean universal
) {
  r = s.getChild(i) and
  (if s.isInverted() then inverted = true else inverted = false) and
  if s.isUniversalClass() then universal = true else universal = false
}

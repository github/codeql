import javascript

from RegExpLiteral literal, RegExpConstant wideConstant
where
  wideConstant.getLiteral() = literal and
  not literal.getFlags().matches("%u%") and
  wideConstant.getValue().length() > 1 and
  (
    wideConstant.getParent() instanceof RegExpCharacterClass
    or
    wideConstant.getParent() instanceof RegExpCharacterRange
    or
    wideConstant.getParent() instanceof RegExpQuantifier
  )
select literal, "Split supplementary character in non-unicode literal."

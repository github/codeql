import javascript

from RegExpLiteral literal, RegExpConstant wideConstant
where wideConstant.getLiteral() = literal and
  not literal.getFlags().matches("%u%") and
  wideConstant.getValue().length() > 1 and
  (
    wideConstant.getParent() instanceof RegExpCharacterClass
    or
    wideConstant.getParent() instanceof RegExpCharacterRange
  )
select literal, "Character class with supplementary characters in non-unicode literal."

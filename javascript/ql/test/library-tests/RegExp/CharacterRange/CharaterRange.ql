import javascript

query predicate range(RegExpCharacterClass cla, RegExpCharacterRange range) {
  cla.getAChild() = range
}

query predicate escapeClass(RegExpCharacterClass cla, RegExpCharacterClassEscape escape) {
  cla.getAChild() = escape
}

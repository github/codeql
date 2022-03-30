import ruby

query predicate allLiterals(Literal l, string pClass, string valueText) {
  pClass = l.getAPrimaryQlClass() and
  (
    valueText = l.getConstantValue().toString()
    or
    not exists(l.getConstantValue()) and valueText = "<none>"
  )
}

query predicate stringlikeLiterals(StringlikeLiteral l, string valueText) {
  valueText = l.getConstantValue().toString()
  or
  not exists(l.getConstantValue()) and valueText = "<none>"
}

query predicate stringLiterals(StringLiteral l, string valueText) {
  stringlikeLiterals(l, valueText)
}

query predicate regExpLiterals(RegExpLiteral l, string valueText, string flags) {
  stringlikeLiterals(l, valueText) and flags = l.getFlagString()
}

query predicate regExpInterpolations(RegExpInterpolationComponent c, int i, Expr e, string eClass) {
  e = c.getStmt(i) and eClass = e.getAPrimaryQlClass()
}

query predicate symbolLiterals(SymbolLiteral l, string valueText) {
  stringlikeLiterals(l, valueText)
}

query predicate subshellLiterals(SubshellLiteral l, string valueText) {
  stringlikeLiterals(l, valueText)
}

query predicate stringComponents(
  StringlikeLiteral l, string lClass, int i, StringComponent c, string cClass
) {
  lClass = l.getAPrimaryQlClass() and
  c = l.getComponent(i) and
  cClass = c.getAPrimaryQlClass()
}

query predicate stringInterpolations(StringInterpolationComponent c, int i, Expr e, string eClass) {
  e = c.getStmt(i) and eClass = e.getAPrimaryQlClass()
}

query predicate concatenatedStrings(StringConcatenation sc, string valueText, int n, StringLiteral l) {
  l = sc.getString(n) and
  (
    valueText = sc.getConcatenatedValueText()
    or
    not exists(sc.getConcatenatedValueText()) and valueText = "<none>"
  )
}

query predicate arrayLiterals(ArrayLiteral l, int numElements) {
  numElements = l.getNumberOfElements()
}

query predicate arrayLiteralElements(ArrayLiteral l, int n, Expr elementN, string pClass) {
  elementN = l.getElement(n) and pClass = elementN.getAPrimaryQlClass()
}

query predicate hashLiterals(HashLiteral l, int numElements) {
  numElements = l.getNumberOfElements()
}

query predicate hashLiteralElements(HashLiteral l, int n, Expr elementN, string pClass) {
  elementN = l.getElement(n) and pClass = elementN.getAPrimaryQlClass()
}

query predicate hashLiteralKeyValuePairs(HashLiteral l, Pair p, Expr k, Expr v) {
  p = l.getAKeyValuePair() and k = p.getKey() and v = p.getValue()
}

query predicate finiteRangeLiterals(RangeLiteral l, Expr begin, Expr end) {
  begin = l.getBegin() and
  end = l.getEnd()
}

query predicate beginlessRangeLiterals(RangeLiteral l, Expr end) {
  not exists(l.getBegin()) and end = l.getEnd()
}

query predicate endlessRangeLiterals(RangeLiteral l, Expr begin) {
  begin = l.getBegin() and not exists(l.getEnd())
}

query predicate inclusiveRangeLiterals(RangeLiteral l) { l.isInclusive() }

query predicate exclusiveRangeLiterals(RangeLiteral l) { l.isExclusive() }

query predicate numericLiterals(NumericLiteral l, string pClass, string valueText) {
  allLiterals(l, pClass, valueText)
}

query predicate integerLiterals(IntegerLiteral l, string pClass, string valueText) {
  allLiterals(l, pClass, valueText)
}

query predicate floatLiterals(FloatLiteral l, string pClass, string valueText) {
  allLiterals(l, pClass, valueText)
}

query predicate rationalLiterals(RationalLiteral l, string pClass, string valueText) {
  allLiterals(l, pClass, valueText)
}

query predicate complexLiterals(ComplexLiteral l, string pClass, string valueText) {
  allLiterals(l, pClass, valueText)
}

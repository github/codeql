import ruby

query predicate stringEscapeSequenceComponents(
  StringEscapeSequenceComponent c, string raw, string unescaped
) {
  (
    unescaped = c.getConstantValue().getString()
    or
    not exists(c.getConstantValue().getString()) and unescaped = "<none>"
  ) and
  raw = c.getRawText()
}

query predicate regexpEscapeSequenceComponents(RegExpEscapeSequenceComponent c, string stringValue) {
  stringValue = c.getConstantValue().getString()
  or
  not exists(c.getConstantValue().getString()) and stringValue = "<none>"
}

query predicate stringlikeLiterals(StringlikeLiteral l, string value, string kind) {
  exists(ConstantValue v |
    v = l.getConstantValue() and value = v.getStringlikeValue() and kind = v.getValueType()
  )
}

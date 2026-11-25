import unified

query predicate identifier(Identifier node, string value) {
  node.fromSource() and value = node.getValue()
}

query predicate namedPattern(NamedPattern node, string value) { value = node.getName() }

query predicate unsupported(UnsupportedNode node, string value) { value = node.getValue() }

query predicate rawStringValue(StringLiteral e, string value) {
  e.fromSource() and value = e.getValue()
}

query predicate exprStringValue(Expr e, string value) {
  e.fromSource() and value = e.getStringValue()
}

query predicate nonStructuralStringValue(
  StringLiteral literal, StringValue value, string role, string content
) {
  literal.fromSource() and
  (
    role = "raw" and value = literal.getRaw()
    or
    role = "interpreted" and value = literal.getInterpreted()
  ) and
  content = value.getValue() and
  not exists(value.getParent()) and
  not value = literal.getAFieldOrChild() and
  PrintAst::isNonStructural(value) and
  not exists(string name, int i | PrintAst::getChild(literal, name, i) = value)
}

query predicate unexpectedUnaryTuple(TupleExpr tuple) { count(tuple.getAnElement()) = 1 }

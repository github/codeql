import unified

query predicate identifier(Identifier node, string value) { value = node.getValue() }

query predicate namedPattern(NamedPattern node, string value) { value = node.getName() }

query predicate unsupported(UnsupportedNode node, string value) { value = node.getValue() }

query predicate rawStringValue(StringLiteral e, string value) { value = e.getValue() }

query predicate exprStringValue(Expr e, string value) { value = e.getStringValue() }

query predicate unexpectedUnaryTuple(TupleExpr tuple) { count(tuple.getAnElement()) = 1 }

import javascript

query predicate test_ConstKeyword(TypeExpr t) { t.isConstKeyword() }

query predicate test_ConstTypeAssertion(TypeAssertion t) { t.getTypeAnnotation().isConstKeyword() }

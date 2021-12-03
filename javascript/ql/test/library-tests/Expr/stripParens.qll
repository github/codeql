import javascript

query predicate test_stripParens(ParExpr e, Expr inner) { inner = e.stripParens() and inner != e }

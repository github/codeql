import codeql.ruby.AST

query predicate controlExprs(ControlExpr c, string pClass) { pClass = c.getAPrimaryQlClass() }

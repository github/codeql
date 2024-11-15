import rust

query predicate exprTypes(Expr e, string type) { type = e.getType() }

query predicate patTypes(Pat e, string type) { type = e.getType() }

query predicate missingExprType(Expr e) { not exists(e.getType()) }

query predicate missingPatType(Pat e) { not exists(e.getType()) }

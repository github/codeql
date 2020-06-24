import javascript

query ClassDefinition classDeclaration() { any() }

query Type exprType(Expr e) { result = e.getType() }

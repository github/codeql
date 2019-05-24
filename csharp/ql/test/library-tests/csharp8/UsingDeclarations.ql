import csharp

query predicate localVars(LocalVariable decl) { any() }

query predicate localVariableDeclarations(
  LocalVariableDeclStmt stmt, int i, LocalVariableDeclExpr decl
) {
  decl = stmt.getVariableDeclExpr(i)
}

query predicate usingStmts1(UsingStmt stmt) { any() }

query predicate usingStmts(UsingStmt stmt, int i, LocalVariableDeclExpr decl) {
  decl = stmt.getVariableDeclExpr(i)
}

query predicate usingDecls(UsingDeclStmt stmt, int i, Expr e) { e = stmt.getChild(i) }

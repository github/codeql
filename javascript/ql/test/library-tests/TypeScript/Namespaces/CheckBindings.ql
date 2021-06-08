import javascript

class ResolveCall extends CallExpr {
  ResolveCall() { this.getCallee().(VarRef).getVariable().getName() = "resolve" }

  Variable getVariable() { result = this.getArgument(0).(VarUse).getVariable() }

  string getExpectation() { result = this.getArgument(1).getStringValue() }

  string getDeclaredValue() {
    result = getVariable().getAnAssignedExpr().getStringValue()
    or
    exists(NamespaceDeclaration decl | decl.getIdentifier() = getVariable().getADeclaration() |
      result = getNamespaceName(decl)
    )
  }
}

string getNamespaceName(NamespaceDeclaration decl) {
  result = decl.getStmt(0).(ExprStmt).getExpr().getStringValue()
  or
  not decl.getStmt(0).(ExprStmt).getExpr() instanceof ConstantString and
  result =
    "Namespace " + decl.getIdentifier() + " on line " +
      decl.getFirstToken().getLocation().getStartLine()
}

from ResolveCall resolve
where resolve.getExpectation() != resolve.getDeclaredValue()
select resolve,
  resolve.getVariable().getName() + " resolves to '" + resolve.getDeclaredValue() +
    "' but should resolve to '" + resolve.getExpectation() + "'"

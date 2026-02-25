private import minimal

string getNameFromLValue(Expr e) {
  result = e.(Identifier).getName()
  or
  result = e.(PropAccess).getPropertyName()
}

string getNameFromContext(Expr e) {
  exists(AssignExpr assign |
    e = assign.getRhs() and
    result = getNameFromLValue(assign.getTarget())
  )
  or
  exists(VariableDeclarator decl |
    e = decl.getInit() and
    result = getNameFromLValue(decl.getBindingPattern())
  )
  // or
  // exists(Property prop |
  //   e = prop.getInit() and
  //   result = prop.getName()
  // )
}

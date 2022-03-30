import javascript

string getStringKind(StringLiteral lit) {
  result = "global" and lit.getStringValue().matches("global%")
  or
  result = "non-global" and not lit.getStringValue().matches("global%")
}

string getVariableKind(Variable variable) {
  result = "global" and variable.isGlobal()
  or
  result = "non-global" and not variable.isGlobal()
}

from Variable variable, string expectedKind, string actualKind
where
  expectedKind = getStringKind(variable.getAnAssignedExpr()) and
  actualKind = getVariableKind(variable) and
  expectedKind != actualKind
select variable,
  variable.getName() + " resolves as a " + actualKind + ", but it should be " + expectedKind

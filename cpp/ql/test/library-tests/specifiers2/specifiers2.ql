import cpp

string interesting(Element e) {
  e instanceof Class and result = "Class"
  or
  e instanceof Function and result = "Function"
  or
  e instanceof FunctionDeclarationEntry and result = "FunctionDeclarationEntry"
  or
  e instanceof TypedefType and result = "TypedefType"
  or
  e instanceof Variable and result = "Variable"
  or
  e instanceof VariableDeclarationEntry and result = "VariableDeclarationEntry"
}

from Element e, string name, string specifiers
where
  (
    name = e.(Declaration).getName() or
    name = e.(DeclarationEntry).getName() or
    name = e.(Type).toString()
  ) and
  specifiers =
    concat(string s |
      s = e.(Declaration).getASpecifier().toString() or
      s = e.(DeclarationEntry).getASpecifier() or
      s = e.(TypedefType).getBaseType().getASpecifier().toString()
    |
      s, ", "
    ) and
  specifiers != ""
select interesting(e), e, name, specifiers

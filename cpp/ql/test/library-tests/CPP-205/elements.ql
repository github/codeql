import cpp

string describe(Element e) {
  result = "function " + e.(Function).getFullSignature()
  or
  result =
    "function declaration entry for " +
      e.(FunctionDeclarationEntry).getFunction().getFullSignature()
  or
  result = "parameter for " + e.(Parameter).getFunction().getFullSignature()
  or
  result =
    "parameter declaration entry for " +
      e.(ParameterDeclarationEntry).getFunctionDeclarationEntry().getFunction().getFullSignature()
}

from Element e
where
  not e.getLocation() instanceof UnknownLocation and
  not e instanceof Folder
select e, concat(describe(e), ", ")

import cpp

string describe(Element e) {
  result = "from " + e.(Function).getFullSignature()
  or
  result = "from " + e.(FunctionDeclarationEntry).getFunction().getFullSignature()
  or
  result = "from " + e.(Parameter).getFunction().getFullSignature()
  or
  result = "from " + e.(ParameterDeclarationEntry).getFunctionDeclarationEntry().getFunction().getFullSignature()
}

from Element e
where not e.getLocation() instanceof UnknownLocation
  and not e instanceof Folder
select e, concat(describe(e), ", ")

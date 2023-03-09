import cpp
import semmle.code.cpp.Print

string describe(Element e) {
  e instanceof Function and
  result = "function " + getIdentityString(e)
  or
  result =
    "function declaration entry for " +
      getIdentityString(e.(FunctionDeclarationEntry).getFunction())
  or
  result = "parameter for " + getIdentityString(e.(Parameter).getFunction())
  or
  result =
    "parameter declaration entry for " +
      getIdentityString(e.(ParameterDeclarationEntry).getFunctionDeclarationEntry().getFunction())
}

from Element e
where
  not e.getLocation() instanceof UnknownLocation and
  not e instanceof Folder
select e, concat(describe(e), ", ")

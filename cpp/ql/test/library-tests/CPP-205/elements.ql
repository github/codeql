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
  or
  exists(Element template |
    e.isFromTemplateInstantiation(template) and
    result = "isFromTemplateInstantiation(" + template.toString() + ")"
  )
  or
  exists(Element template |
    e.isFromUninstantiatedTemplate(template) and
    result = "isFromUninstantiatedTemplate(" + template.toString() + ")"
  )
}

from Element e
where
  e.getLocation().getFile().getBaseName() != "" and
  not e instanceof Folder
select e, strictconcat(describe(e), ", ")

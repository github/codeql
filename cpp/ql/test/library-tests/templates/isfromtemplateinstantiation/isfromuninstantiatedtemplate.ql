import cpp

string knownKind(Element e) {
  e instanceof Expr and result = "Expr"
  or
  e instanceof DeclarationEntry and
  (
    if e.(DeclarationEntry).isDefinition()
    then result = "Definition"
    else result = "DeclarationEntry"
  )
  or
  e instanceof Declaration and result = "Declaration"
  or
  e instanceof Initializer and result = "Initializer"
  or
  e instanceof Stmt and result = "Stmt"
  or
  e instanceof ClassDerivation and result = "ClassDerivation"
}

string kind(Element e) {
  result = strictconcat(knownKind(e), "+")
  or
  not exists(knownKind(e)) and
  result = "other"
}

predicate hasTwin(Element e) {
  not e.getLocation() instanceof UnknownLocation and
  strictcount(Element other |
    exists(string file, int sl, int sc, int el, int ec |
      other.getLocation().hasLocationInfo(file, sl, sc, el, ec) and
      e.getLocation().hasLocationInfo(file, sl, sc, el, ec) and
      kind(other) = kind(e)
    )
  ) > 1
}

predicate isInteresting(Element el) {
  not el.getLocation() instanceof UnknownLocation and
  exists(el.getLocation()) and
  (
    el instanceof Class
    or
    el instanceof Function
  )
}

// This is one case where the template before or after the instantiation is
// likely to be different.
string conversionString(Element el) {
  if el instanceof VariableAccess
  then
    if el.(VariableAccess).getConversion+() instanceof ReferenceToExpr
    then result = "Ref"
    else result = "Not ref"
  else result = ""
}

query predicate isFromUninstantiatedTemplate(Element e, Element template) {
  e.isFromUninstantiatedTemplate(template)
}

from Element el
where (hasTwin(el) or isInteresting(el))
select el, any(string s | if el.isFromTemplateInstantiation(_) then s = "I" else s = ""),
  any(string s | if el.isFromUninstantiatedTemplate(_) then s = "T" else s = ""), kind(el),
  conversionString(el)

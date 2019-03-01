import javascript

string getKind(ImportTypeExpr imprt) {
  if imprt.isTypeAccess()
  then result = "type"
  else
    if imprt.isNamespaceAccess()
    then result = "namespace"
    else result = "value"
}

query predicate test_ImportTypeExpr(ImportTypeExpr imprt, string res0, string res1) {
  res0 = imprt.getPath() and res1 = getKind(imprt)
}

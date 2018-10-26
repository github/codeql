import javascript

string getKind(ImportTypeExpr imprt) {
  if imprt.isTypeAccess() then
    result = "type"
  else if imprt.isNamespaceAccess() then
    result = "namespace"
  else
    result = "value"
}

from ImportTypeExpr imprt
select imprt, imprt.getPath(), getKind(imprt)

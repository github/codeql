import javascript

query string getTypeString(TypeExpr te) { result = te.getType().toString() }

query ImportSpecifier importSpec(boolean typeOnly) {
  if result.isTypeOnly() then typeOnly = true else typeOnly = false
}

from Expr e, string mod, string name
where e.getType().(TypeReference).hasQualifiedName(mod, name)
select e, mod, name

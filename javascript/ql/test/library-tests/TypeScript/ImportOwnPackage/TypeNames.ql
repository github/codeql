import javascript

from Expr e, string mod, string name
where e.getType().(TypeReference).hasQualifiedName(mod, name)
select e, mod, name

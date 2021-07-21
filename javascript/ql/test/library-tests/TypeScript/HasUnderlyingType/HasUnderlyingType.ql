import javascript

from Expr e, TypeName typeName
where e.getType().hasUnderlyingTypeName(typeName)
select e, typeName

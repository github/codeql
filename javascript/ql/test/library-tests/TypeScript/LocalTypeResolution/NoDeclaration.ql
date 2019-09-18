import javascript

from LocalTypeName name
where not exists(name.getADeclaration())
select name.getScope(), name.toString() + " has no declaration"

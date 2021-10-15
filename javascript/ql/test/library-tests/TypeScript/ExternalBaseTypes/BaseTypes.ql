import javascript

from TypeName tn
where tn.hasQualifiedName("mylib", _)
select tn, tn.getABaseTypeName()

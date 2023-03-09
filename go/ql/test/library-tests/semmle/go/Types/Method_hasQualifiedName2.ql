import go

from Method meth, string tp, string m
where meth.hasQualifiedName(tp, m)
select meth.getDeclaration(), tp, m

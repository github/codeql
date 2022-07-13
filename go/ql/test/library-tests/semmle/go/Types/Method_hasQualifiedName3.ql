import go

from Method meth, string pkg, string tp, string m
where meth.hasQualifiedName(pkg, tp, m)
select meth.getDeclaration(), pkg, tp, m

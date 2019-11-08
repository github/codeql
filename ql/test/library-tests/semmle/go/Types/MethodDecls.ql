import go

from NamedType t, string m
select t, m, t.getMethodDecl(m)

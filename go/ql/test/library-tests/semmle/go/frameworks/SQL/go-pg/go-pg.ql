import go

from SQL::QueryString qs, Method meth, string a, string b, string c
where meth.hasQualifiedName(a, b, c) and qs = meth.getACall().getSyntacticArgument(_)
select qs, a, b, c

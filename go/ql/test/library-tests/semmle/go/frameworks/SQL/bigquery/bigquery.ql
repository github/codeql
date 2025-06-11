import go

from SQL::QueryString qs, Function func, string a, string b
where
  func.hasQualifiedName(a, b) and
  qs = func.getACall().getSyntacticArgument(_)
select qs, a, b

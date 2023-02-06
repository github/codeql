import codeql.swift.elements

from Expr e, Type t
where
  e.getLocation().getFile().getName().matches("%swift/ql/test%") and
  t = e.getType()
select e, t

import codeql.swift.elements

from Function f, AnyFunctionType t, string s
where
  f.getInterfaceType() = t and
  f.getLocation().getFile().getName().matches("%swift/ql/test%") and
  (
    t.isAsync() and s = "async"
    or
    t.isThrowing() and s = "throws"
  )
select f, t, s

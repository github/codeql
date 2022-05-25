import codeql.swift.elements

from Decl d, StructType s, string parent
where
  d.getLocation().getFile().getName().matches("%swift/ql/test%") and
  d = s.getDeclaration() and
  (
    parent = s.getParent().toString()
    or
    not exists(s.getParent()) and parent = "<no parent>"
  )
select d, s, parent

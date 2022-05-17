import swift

from FuncDecl decl, BraceStmt body
where
  decl.getLocation().getFile().getName().matches("%swift/ql/test%") and
  body = decl.getBody()
select decl, body

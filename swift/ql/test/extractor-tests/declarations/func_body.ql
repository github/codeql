import swift

from FuncDecl decl, BraceStmt body
where body = decl.getBody()
select decl, body

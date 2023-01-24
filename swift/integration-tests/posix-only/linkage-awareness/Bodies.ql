import swift

from ConcreteFuncDecl decl, BraceStmt body
where decl.getName() = "foo()" and decl.getBody() = body
select decl, body

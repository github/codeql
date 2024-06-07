import swift

from NamedFunction decl, BraceStmt body
where decl.getName() = "foo()" and decl.getBody() = body
select decl, body

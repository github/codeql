import swift

from StructDecl struct, ConstructorDecl decl, BraceStmt body
where struct.getName() = "hello_world" and decl = struct.getAMember() and body = decl.getBody()
select decl, body

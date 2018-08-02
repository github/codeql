import javascript

from EnumDeclaration enum, LocalTypeAccess access
where access = enum.getLocalTypeName().getAnAccess()
select access.getEnclosingStmt(), access

import javascript

from EnumDeclaration enum, VarAccess access
where access = enum.getVariable().getAnAccess()
select access.getEnclosingStmt(), access

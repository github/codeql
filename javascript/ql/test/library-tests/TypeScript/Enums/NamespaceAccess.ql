import javascript

from EnumDeclaration enum, LocalNamespaceAccess access
where access = enum.getLocalNamespaceName().getAnAccess()
select access.getEnclosingStmt(), access

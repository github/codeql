import csharp

from LocalVariableAccess access, string type
where
  access.getTarget().hasName("x") and
  (
    access instanceof LocalVariableRead and type = "read"
    or
    access instanceof LocalVariableWrite and type = "write"
  )
select access, type

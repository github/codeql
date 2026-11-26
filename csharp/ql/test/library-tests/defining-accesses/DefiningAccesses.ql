import csharp

from LocalVariableDeclExpr decl, LocalVariable variable, string access, string definition
where
  variable = decl.getVariable() and
  (
    if count(decl.getAccess()) != 1
    then access = "missing or duplicate access"
    else
      if decl.getAccess().getTarget() != variable
      then access = "wrong target"
      else
        if decl.getAccess() instanceof AssignableRead
        then access = "read"
        else
          if decl.getAccess() instanceof AssignableWrite
          then access = "write"
          else access = "neither read nor write"
  ) and
  (
    if exists(AssignableDefinition def | def.getTargetAccess() = decl.getAccess())
    then definition = "definition"
    else definition = "no definition"
  )
select decl, variable, access, definition

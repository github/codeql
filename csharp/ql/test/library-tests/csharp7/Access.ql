import csharp

from LocalVariableAccess a, string access
where
  a.getEnclosingCallable().getDeclaringType().hasName("OutVariables") and
  if a instanceof LocalVariableRead then access = "read" else access = "write"
select a, access

import semmle.code.java.security.ControlledString

from Expr controlled, Method method, int line
where
  controlledString(controlled) and
  method = controlled.getEnclosingCallable() and
  line = controlled.getLocation().getStartLine() - method.getLocation().getStartLine() and
  controlled.getCompilationUnit().fromSource()
select method.getName(), line, controlled

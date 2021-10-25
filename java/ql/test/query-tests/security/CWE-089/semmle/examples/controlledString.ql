import semmle.code.java.security.ControlledString

from Expr controlled, Method method, int line
where
  controlledString(controlled) and
  method = controlled.getEnclosingCallable() and
  line = controlled.getLocation().getStartLine() - method.getLocation().getStartLine() and
  controlled.getCompilationUnit().fromSource() and
  controlled.getFile().getStem() = ["Test", "Validation"]
select method.getName(), line, controlled

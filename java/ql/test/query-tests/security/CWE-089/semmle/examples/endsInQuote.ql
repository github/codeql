import semmle.code.java.security.ControlledString

from Expr precedes, Method method
where
  endsInQuote(precedes) and
  precedes.getEnclosingCallable() = method and
  precedes.getFile().getStem() = "Test"
select method.getName(),
  precedes.getLocation().getStartLine() - method.getLocation().getStartLine(), precedes

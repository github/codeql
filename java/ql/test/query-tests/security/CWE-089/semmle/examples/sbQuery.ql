import semmle.code.java.security.SqlUnescapedLib

from StringBuilderVar sbv, Expr uncontrolled, Method method, int methodLine
where
  uncontrolledStringBuilderQuery(sbv, uncontrolled) and
  method = uncontrolled.getEnclosingCallable() and
  methodLine = method.getLocation().getStartLine()
select method.getName(), sbv.getLocation().getStartLine() - methodLine, sbv,
  uncontrolled.getLocation().getStartLine() - methodLine, uncontrolled

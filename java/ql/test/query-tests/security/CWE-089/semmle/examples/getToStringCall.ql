import semmle.code.java.dataflow.TaintTracking

from StringBuilderVar sbv, MethodAccess toString, Method method
where sbv.getToStringCall() = toString and toString.getEnclosingCallable() = method
select method.getName(), sbv.getLocation().getStartLine() - method.getLocation().getStartLine(),
  sbv, toString.getLocation().getStartLine() - method.getLocation().getStartLine(), toString

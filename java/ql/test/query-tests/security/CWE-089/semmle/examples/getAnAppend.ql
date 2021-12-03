import semmle.code.java.dataflow.TaintTracking

from StringBuilderVar sbv, MethodAccess append, Method method
where sbv.getAnAppend() = append and append.getEnclosingCallable() = method
select method.getName(), sbv.getLocation().getStartLine() - method.getLocation().getStartLine(),
  sbv, append.getLocation().getStartLine() - method.getLocation().getStartLine(), append,
  append.getArgument(0)

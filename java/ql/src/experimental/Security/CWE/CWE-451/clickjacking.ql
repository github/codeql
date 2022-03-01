import java
import semmle.code.java.frameworks.Servlets

private predicate hasCodeXFrameOptions(MethodAccess header) {
  (
    header.getMethod() instanceof ResponseSetHeaderMethod or
    header.getMethod() instanceof ResponseAddHeaderMethod
  ) and
  header.getArgument(0).(CompileTimeConstantExpr).getStringValue().toLowerCase() = "x-frame-options" 
}

private predicate hasCodeXFramecheck(MethodAccess header) {
  (
    header.getMethod() instanceof ResponseSetHeaderMethod or
    header.getMethod() instanceof ResponseAddHeaderMethod
  ) and
  header.getArgument(0).(CompileTimeConstantExpr).getStringValue().toLowerCase() = "x-frame-options" and
  header.getArgument(1).(CompileTimeConstantExpr).getStringValue().toLowerCase() = "sameorigin"
}

from MethodAccess call
where
  not hasCodeXFrameOptions(call) and
  hasCodeXFramecheck(call)
select call, "Configuration missing the X-Frame-Options setting."

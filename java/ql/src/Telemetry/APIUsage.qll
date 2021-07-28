import java

private string jarName(CompilationUnit cu) {
  result = cu.getParentContainer().toString().regexpCapture(".*/(.*\\.jar)/?.*", 1)
}

predicate isJavaRuntime(Callable call) {
  jarName(call.getCompilationUnit()) = "rt.jar" or
  call.getCompilationUnit().getParentContainer().toString().substring(0, 14) = "/modules/java."
}

// TODO Is this heuristic too broad?
predicate isInterestingAPI(Callable call) {
  call.getNumberOfParameters() > 0 and
  not (
    call.getReturnType() instanceof VoidType or
    call.getReturnType() instanceof PrimitiveType or
    call.getReturnType() instanceof BoxedType
  )
}

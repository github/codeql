import java

predicate isContextCallable(Callable c) { c.getName() = ["logged", "getLogged"] }

query predicate parameters(Callable callable, Parameter parameter, int index, string parameterType) {
  isContextCallable(callable) and
  parameter = callable.getParameter(index) and
  parameterType = parameter.getType().toString()
}

query predicate calls(
  MethodCall call, Callable caller, Method target, Expr qualifier, int argumentCount
) {
  caller.fromSource() and
  call.getEnclosingCallable() = caller and
  target = call.getMethod() and
  isContextCallable(target) and
  qualifier = call.getQualifier() and
  argumentCount = call.getNumArgument()
}

query predicate arguments(MethodCall call, int index, Expr argument) {
  isContextCallable(call.getMethod()) and
  argument = call.getArgument(index)
}

import semmle.code.java.Expr

bindingset[result, i]
private int unbindInt(int i) { i <= result and i >= result }

/** Holds if the method `method` validates its `arg`-th argument in some way. */
predicate validationMethod(Method method, int arg) {
  // The method examines the contents of the string argument.
  exists(Parameter param, VarAccess paramRef, MethodAccess call |
    method.getParameter(arg) = param and
    param.getType() instanceof TypeString and
    paramRef.getVariable() = param and
    call.getQualifier() = paramRef and
    (
      call.getMethod().getName() = "contains" or
      call.getMethod().getName() = "charAt"
    )
  )
  or
  // The method calls another one that verifies the argument.
  exists(Parameter param, MethodAccess call, int recursiveArg |
    method.getParameter(arg) = param and
    call.getArgument(recursiveArg) = param.getAnAccess() and
    validationMethod(call.getMethod(), unbindInt(recursiveArg))
  )
}

/** A variable that is ever passed to a string verification method. */
class ValidatedVariable extends Variable {
  ValidatedVariable() {
    exists(MethodAccess call, int arg, VarAccess access |
      validationMethod(call.getMethod(), arg) and
      call.getArgument(arg) = access and
      access.getVariable() = this
    )
  }
}

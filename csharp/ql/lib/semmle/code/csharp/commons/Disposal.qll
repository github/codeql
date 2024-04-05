/**
 * Provides predicates for determining whether variables may be disposed.
 */

import csharp

private predicate isDisposeMethod(Callable method) {
  method.getName() = "Dispose" and
  method.getNumberOfParameters() = 0
}

private predicate disposedCSharpVariable(Variable variable) {
  // Call to a method that disposes it
  exists(Call call, int arg, VariableRead read |
    read.getTarget() = variable and
    read = call.getArgument(arg)
  |
    disposedCSharpVariable(call.getTarget().getParameter(arg))
  )
  or
  // Call to `Dispose`
  exists(MethodCall call, VariableRead read |
    read.getTarget() = variable and
    read = call.getQualifier()
  |
    isDisposeMethod(call.getTarget())
  )
  or
  // A parameter is disposed if its source declaration is disposed
  disposedCSharpVariable(variable.(Parameter).getUnboundDeclaration())
  or
  // A variable is disposed if it's assigned to another variable that is disposed
  exists(AssignableDefinition assign |
    assign.getSource() = variable.getAnAccess() and
    disposedCSharpVariable(assign.getTarget())
  )
}

/**
 * Hold if `variable` might be disposed.
 * This is a conservative overestimate.
 */
predicate mayBeDisposed(Variable variable) { disposedCSharpVariable(variable) }

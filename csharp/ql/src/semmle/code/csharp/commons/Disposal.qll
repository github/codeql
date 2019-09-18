/**
 * Provides predicates for determining whether variables may be disposed.
 */

import csharp
private import cil
private import dotnet

private predicate isDisposeMethod(DotNet::Callable method) {
  method.getName() = "Dispose" and
  method.getNumberOfParameters() = 0
}

private predicate disposedCilVariable(CIL::Variable variable) {
  // `variable` is the `this` parameter on a dispose method.
  isDisposeMethod(variable.(CIL::ThisParameter).getMethod())
  or
  // `variable` is passed to a method that disposes it.
  exists(CIL::Call call, CIL::Parameter param, CIL::ReadAccess read |
    read.getTarget() = variable and
    read.flowsTo(call.getArgumentForParameter(param)) and
    disposedCilVariable(param)
  )
  or
  // A parameter is disposed if its source declaration is disposed
  disposedCilVariable(variable.(CIL::Parameter).getSourceDeclaration())
  or
  // A variable is disposed if it's assigned to another variable
  // that may be disposed.
  exists(CIL::ReadAccess read, CIL::WriteAccess write |
    read.flowsTo(write.getExpr()) and
    read.getTarget() = variable and
    disposedCilVariable(write.getTarget())
  )
}

private predicate disposedCSharpVariable(Variable variable) {
  // A C# parameter is disposed if its corresponding CIL parameter is disposed
  exists(CIL::Method m, CIL::Parameter p, int i |
    disposedCilVariable(p) and p = m.getRawParameter(i)
  |
    variable = any(Callable c2 | c2.matchesHandle(m)).getRawParameter(i)
  )
  or
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
  disposedCSharpVariable(variable.(Parameter).getSourceDeclaration())
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
predicate mayBeDisposed(DotNet::Variable variable) {
  disposedCSharpVariable(variable) or
  disposedCilVariable(variable)
}

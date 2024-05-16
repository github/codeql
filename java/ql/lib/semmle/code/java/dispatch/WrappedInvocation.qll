/**
 * Provides classes and predicates for reasoning about calls that may invoke one
 * of their arguments.
 */

import java
import VirtualDispatch

/**
 * Holds if `m` might invoke `runmethod` through a functional interface on the
 * `n`th parameter.
 */
private predicate runner(Method m, int n, Method runmethod) {
  m.getParameterType(n).(RefType).getSourceDeclaration().(FunctionalInterface).getRunMethod() =
    runmethod and
  (
    m.isNative()
    or
    exists(Parameter p, MethodCall ma, int j |
      p = m.getParameter(n) and
      ma.getEnclosingCallable() = m and
      runner(pragma[only_bind_into](ma.getMethod().getSourceDeclaration()),
        pragma[only_bind_into](j), _) and
      ma.getArgument(pragma[only_bind_into](j)) = p.getAnAccess()
    )
  )
}

/**
 * Gets an argument of `ma` on which `ma.getMethod()` might invoke `runmethod`
 * through a functional interface. The argument is traced backwards through
 * casts and variable assignments.
 */
private Expr getRunnerArgument(MethodCall ma, Method runmethod) {
  exists(Method runner, int param |
    runner(runner, param, runmethod) and
    viableImpl_v2(ma) = runner and
    result = ma.getArgument(param)
  )
  or
  getRunnerArgument(ma, runmethod).(CastingExpr).getExpr() = result
  or
  pragma[only_bind_out](getRunnerArgument(ma, runmethod))
      .(VarAccess)
      .getVariable()
      .getAnAssignedValue() = result
}

/**
 * Gets a method that can be invoked through a functional interface as an
 * argument to `ma`.
 */
Method getRunnerTarget(MethodCall ma) {
  exists(Expr action, Method runmethod | action = getRunnerArgument(ma, runmethod) |
    action.(FunctionalExpr).asMethod().getSourceDeclaration() = result
    or
    action.(ClassInstanceExpr).getAnonymousClass().getAMethod().getSourceDeclaration() = result and
    result.overridesOrInstantiates*(runmethod)
  )
}

import semmle.code.java.dataflow.FlowSummary

private predicate mayInvokeCallback(SrcMethod m, int n) {
  m.getParameterType(n).(RefType).getSourceDeclaration() instanceof FunctionalInterface and
  (not m.fromSource() or m.isNative() or m.getFile().getAbsolutePath().matches("%/test/stubs/%"))
}

private class SummarizedCallableWithCallback extends SummarizedCallable {
  private int pos;

  SummarizedCallableWithCallback() { mayInvokeCallback(this.asCallable(), pos) }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, string model
  ) {
    input = "Argument[" + pos + "]" and
    output = "Argument[" + pos + "].Parameter[-1]" and
    preservesValue = true and
    model = "heuristic-callback"
  }

  override predicate hasProvenance(Provenance provenance) { provenance = "hq-generated" }
}

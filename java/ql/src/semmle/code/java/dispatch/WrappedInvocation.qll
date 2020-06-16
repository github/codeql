/**
 * Provides classes and predicates for reasoning about calls that may invoke one
 * of their arguments.
 */

import java
import VirtualDispatch

private string getAPublicObjectMethodSignature() {
  exists(Method m |
    m.getDeclaringType() instanceof TypeObject and
    m.isPublic() and
    result = m.getSignature()
  )
}

private Method getAPotentialRunMethod(Interface i) {
  i.inherits(result) and
  result.isPublic() and
  not result.getSignature() = getAPublicObjectMethodSignature()
}

/**
 * A functional interface is an interface that has just one abstract method
 * (aside from the methods of Object), and thus represents a single function
 * contract.
 *
 * See JLS 9.8, Functional Interfaces.
 */
class FunctionalInterface extends Interface {
  FunctionalInterface() {
    1 = strictcount(getAPotentialRunMethod(this)) and
    not exists(Method m | this.inherits(m) and m.isDefault())
  }

  /** Gets the single method of this interface. */
  Method getRunMethod() { getAPotentialRunMethod(this).getSourceDeclaration() = result }
}

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
    exists(Parameter p, MethodAccess ma, int j |
      p = m.getParameter(n) and
      ma.getEnclosingCallable() = m and
      runner(ma.getMethod().getSourceDeclaration(), j, _) and
      ma.getArgument(j) = p.getAnAccess()
    )
  )
}

/**
 * Gets an argument of `ma` on which `ma.getMethod()` might invoke `runmethod`
 * through a functional interface. The argument is traced backwards through
 * casts and variable assignments.
 */
private Expr getRunnerArgument(MethodAccess ma, Method runmethod) {
  exists(Method runner, int param |
    runner(runner, param, runmethod) and
    viableImpl(ma) = runner and
    result = ma.getArgument(param)
  )
  or
  getRunnerArgument(ma, runmethod).(CastExpr).getExpr() = result
  or
  getRunnerArgument(ma, runmethod).(VarAccess).getVariable().getAnAssignedValue() = result
}

/**
 * Gets a method that can be invoked through a functional interface as an
 * argument to `ma`.
 */
Method getRunnerTarget(MethodAccess ma) {
  exists(Expr action, Method runmethod | action = getRunnerArgument(ma, runmethod) |
    action.(FunctionalExpr).asMethod().getSourceDeclaration() = result
    or
    action.(ClassInstanceExpr).getAnonymousClass().getAMethod().getSourceDeclaration() = result and
    result.overridesOrInstantiates*(runmethod)
  )
}

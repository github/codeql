/**
 * @name Dispose may not be called if an exception is thrown during execution
 * @description Methods that create objects of type 'IDisposable' should call 'Dispose()' on those
 *              objects, even during exceptional circumstances, otherwise unmanaged resources may
 *              not be released.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/dispose-not-called-on-throw
 * @tags efficiency
 *       maintainability
 *       security
 *       external/cwe/cwe-404
 *       external/cwe/cwe-459
 *       external/cwe/cwe-460
 */

import csharp
import Dispose
import semmle.code.csharp.frameworks.System

/**
 * Gets an exception type that may be thrown during the execution of method `m`.
 * Assumes any exception may be thrown by library types.
 */
ExceptionClass getAThrownException(Method m) {
  m.fromLibrary() and
  result = any(SystemExceptionClass sc)
  or
  exists(ControlFlowElement cfe |
    cfe = any(ThrowElement te | result = te.getExpr().getType()) or
    cfe = any(MethodCall mc | result = getAThrownException(mc.getARuntimeTarget())) |
    cfe.getEnclosingCallable() = m and
    not isTriedAgainstException(cfe, result)
  )
}

/**
 * Holds if control flow element is tried against throwing an exception of type
 * `ec`.
 */
pragma [noinline]
predicate isTriedAgainstException(ControlFlowElement cfe, ExceptionClass ec) {
  (cfe instanceof ThrowElement or cfe instanceof MethodCall) and
  exists(TryStmt ts |
    ts.getATriedElement() = cfe and
    exists(ts.getAnExceptionHandler(ec))
  )
}

/**
 * Holds if `disposeCall` disposes the object created by `disposableCreation`.
 */
predicate disposeReachableFromDisposableCreation(MethodCall disposeCall, Expr disposableCreation) {
  // The qualifier of the Dispose call flows from something that introduced a disposable into scope
  (disposableCreation instanceof LocalScopeDisposableCreation or disposableCreation instanceof MethodCall)
  and DataFlow::localFlowStep+(DataFlow::exprNode(disposableCreation), DataFlow::exprNode(disposeCall.getQualifier()))
  and disposeCall.getTarget() instanceof DisposeMethod
}


from MethodCall disposeCall, Expr disposableCreation, MethodCall callThatThrows
where
  disposeReachableFromDisposableCreation(disposeCall, disposableCreation)
  // The dispose call is not, itself, within a dispose method.
  and not disposeCall.getEnclosingCallable() instanceof DisposeMethod
  // Dispose call not within a finally or catch block
  and not exists(TryStmt ts |
    ts.getACatchClause().getAChild*() = disposeCall or ts.getFinally().getAChild*() = disposeCall)
  // At least one method call exists between the allocation and disposal that could throw
  and disposableCreation.getAReachableElement() = callThatThrows
  and callThatThrows.getAReachableElement() = disposeCall
  and exists(getAThrownException(callThatThrows.getARuntimeTarget()))
select disposeCall, "Dispose missed if exception is thrown by $@.", callThatThrows, callThatThrows.toString()

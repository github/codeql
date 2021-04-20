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
 *       external/cwe/cwe-404
 *       external/cwe/cwe-459
 *       external/cwe/cwe-460
 */

import csharp
import Dispose
import semmle.code.csharp.frameworks.System

private class DisposeCall extends MethodCall {
  DisposeCall() { this.getTarget() instanceof DisposeMethod }
}

private predicate localFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  DataFlow::localFlowStep(nodeFrom, nodeTo) and
  not exists(AssignableDefinition def, UsingStmt us |
    nodeTo.asExpr() = def.getAReachableRead() and
    def.getTargetAccess() = us.getAVariableDeclExpr().getAccess()
  )
}

private predicate reachesDisposeCall(DisposeCall disposeCall, DataFlow::Node node) {
  localFlowStep(node, DataFlow::exprNode(disposeCall.getQualifier()))
  or
  exists(DataFlow::Node mid | reachesDisposeCall(disposeCall, mid) | localFlowStep(node, mid))
}

/**
 * Holds if `disposeCall` disposes the object created by `disposableCreation`.
 */
predicate disposeReachableFromDisposableCreation(DisposeCall disposeCall, Expr disposableCreation) {
  // The qualifier of the Dispose call flows from something that introduced a disposable into scope
  (
    disposableCreation instanceof LocalScopeDisposableCreation or
    disposableCreation instanceof MethodCall
  ) and
  reachesDisposeCall(disposeCall, DataFlow::exprNode(disposableCreation))
}

/**
 * Holds if control flow element is tried against throwing an exception of type
 * `ec`.
 */
pragma[noinline]
predicate isTriedAgainstException(ControlFlowElement cfe, ExceptionClass ec) {
  (cfe instanceof ThrowElement or cfe instanceof MethodCall) and
  exists(TryStmt ts |
    ts.getATriedElement() = cfe and
    exists(ts.getAnExceptionHandler(ec))
  )
}

ControlFlowElement getACatchOrFinallyClauseChild() {
  exists(TryStmt ts | result = ts.getACatchClause() or result = ts.getFinally())
  or
  result = getACatchOrFinallyClauseChild().getAChild()
}

private predicate candidate(DisposeCall disposeCall, Call call, Expr disposableCreation) {
  disposeReachableFromDisposableCreation(disposeCall, disposableCreation) and
  // The dispose call is not, itself, within a dispose method.
  not disposeCall.getEnclosingCallable() instanceof DisposeMethod and
  // Dispose call not within a finally or catch block
  not getACatchOrFinallyClauseChild() = disposeCall and
  // At least one method call exists between the allocation and disposal that could throw
  disposableCreation.getAReachableElement() = call and
  call.getAReachableElement() = disposeCall
}

private class RelevantMethod extends Method {
  RelevantMethod() {
    exists(Call call |
      candidate(_, call, _) and
      this = call.getARuntimeTarget()
    )
    or
    exists(RelevantMethod other | other.calls(this))
  }

  pragma[noinline]
  private RelevantMethod callsNoTry() {
    exists(MethodCall mc |
      result = mc.getARuntimeTarget() and
      not isTriedAgainstException(mc, _) and
      mc.getEnclosingCallable() = this
    )
  }

  pragma[noinline]
  private RelevantMethod callsInTry(MethodCall mc) {
    result = mc.getARuntimeTarget() and
    isTriedAgainstException(mc, _) and
    mc.getEnclosingCallable() = this
  }

  /**
   * Gets an exception type that may be thrown during the execution of this method.
   * Assumes any exception may be thrown by library types.
   */
  Class getAThrownException() {
    this.fromLibrary() and
    result instanceof SystemExceptionClass
    or
    exists(ControlFlowElement cfe |
      result = cfe.(ThrowElement).getExpr().getType() and
      cfe.getEnclosingCallable() = this
      or
      result = this.callsInTry(cfe).getAThrownException()
    |
      not isTriedAgainstException(cfe, result)
    )
    or
    result = this.callsNoTry().getAThrownException()
  }
}

class MethodCallThatMayThrow extends MethodCall {
  MethodCallThatMayThrow() {
    exists(this.getARuntimeTarget().(RelevantMethod).getAThrownException())
  }
}

from DisposeCall disposeCall, Expr disposableCreation, MethodCallThatMayThrow callThatThrows
where candidate(disposeCall, callThatThrows, disposableCreation)
select disposeCall, "Dispose missed if exception is thrown by $@.", callThatThrows,
  callThatThrows.toString()

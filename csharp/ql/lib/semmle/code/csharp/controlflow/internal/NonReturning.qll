/**
 * INTERNAL: Do not use.
 *
 * Provides a simple analysis for identifying calls to callables that will
 * not return.
 */

import csharp
private import semmle.code.csharp.ExprOrStmtParent
private import semmle.code.csharp.commons.Assertions
private import semmle.code.csharp.frameworks.System

/** A call that definitely does not return (conservative analysis). */
abstract class NonReturningCall extends Call { }

private class ExitingCall extends NonReturningCall {
  ExitingCall() {
    this.getTarget() instanceof ExitingCallable
    or
    this = any(FailingAssertion fa | fa.getAssertionFailure().isExit())
  }
}

private class ThrowingCall extends NonReturningCall {
  ThrowingCall() {
    this.getTarget() instanceof ThrowingCallable
    or
    this.(FailingAssertion).getAssertionFailure().isException(_)
    or
    this =
      any(MethodCall mc |
        mc.getTarget()
            .hasFullyQualifiedName("System.Runtime.ExceptionServices", "ExceptionDispatchInfo",
              "Throw")
      )
  }
}

/** Holds if accessor `a` has an auto-implementation. */
private predicate hasAccessorAutoImplementation(Accessor a) { not a.hasBody() }

abstract private class NonReturningCallable extends Callable {
  NonReturningCallable() {
    not exists(ReturnStmt ret | ret.getEnclosingCallable() = this) and
    not hasAccessorAutoImplementation(this) and
    not exists(Virtualizable v | v.isOverridableOrImplementable() |
      v = this or
      v = this.(Accessor).getDeclaration()
    )
  }
}

abstract private class ExitingCallable extends NonReturningCallable { }

private class DirectlyExitingCallable extends ExitingCallable {
  DirectlyExitingCallable() {
    this =
      any(Method m |
        m.hasFullyQualifiedName("System", "Environment", "Exit") or
        m.hasFullyQualifiedName("System.Windows.Forms", "Application", "Exit")
      )
  }
}

private class IndirectlyExitingCallable extends ExitingCallable {
  IndirectlyExitingCallable() {
    forex(ControlFlowElement body | body = this.getBody() | body = getAnExitingElement())
  }
}

private ControlFlowElement getAnExitingElement() {
  result instanceof ExitingCall
  or
  result = getAnExitingStmt()
}

private Stmt getAnExitingStmt() {
  result.(ExprStmt).getExpr() = getAnExitingElement()
  or
  result.(BlockStmt).getFirstStmt() = getAnExitingElement()
  or
  exists(IfStmt ifStmt |
    result = ifStmt and
    ifStmt.getThen() = getAnExitingElement() and
    ifStmt.getElse() = getAnExitingElement()
  )
}

private class ThrowingCallable extends NonReturningCallable {
  ThrowingCallable() {
    forex(ControlFlowElement body | body = this.getBody() | body = getAThrowingElement())
  }
}

private predicate directlyThrows(ThrowElement te) {
  // For stub implementations, there may exist proper implementations that are not seen
  // during compilation, so we conservatively rule those out
  not isStub(te)
}

private ControlFlowElement getAThrowingElement() {
  result instanceof ThrowingCall
  or
  directlyThrows(result)
  or
  result = getAThrowingStmt()
}

private Stmt getAThrowingStmt() {
  directlyThrows(result)
  or
  result.(ExprStmt).getExpr() = getAThrowingElement()
  or
  result.(BlockStmt).getFirstStmt() = getAThrowingStmt()
  or
  exists(IfStmt ifStmt |
    result = ifStmt and
    ifStmt.getThen() = getAThrowingStmt() and
    ifStmt.getElse() = getAThrowingStmt()
  )
}

/** Holds if `throw` element `te` indicates a stub implementation. */
private predicate isStub(ThrowElement te) {
  exists(Expr e | e = te.getExpr() |
    e instanceof NullLiteral or
    e.getType() instanceof SystemNotImplementedExceptionClass
  )
}

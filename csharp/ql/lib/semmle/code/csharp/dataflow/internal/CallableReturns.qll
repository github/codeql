/**
 * Provides predicates for analyzing the return values of callables.
 */

import csharp
private import cil
private import semmle.code.csharp.dataflow.Nullness
private import semmle.code.cil.CallableReturns as CR

private predicate finalCallable(Callable c) {
  not c.(Virtualizable).isVirtual() and
  not exists(DeclarationWithGetSetAccessors p | c = p.getAnAccessor() and p.isVirtual())
}

/** Holds if callable `c` always returns null. */
predicate alwaysNullCallable(Callable c) {
  finalCallable(c) and
  (
    exists(CIL::Method m | m.matchesHandle(c) | CR::alwaysNullMethod(m))
    or
    forex(Expr e | c.canReturn(e) | e instanceof AlwaysNullExpr)
  )
}

/** Holds if callable `c` always returns a non-null value. */
predicate alwaysNotNullCallable(Callable c) {
  finalCallable(c) and
  (
    exists(CIL::Method m | m.matchesHandle(c) | CR::alwaysNotNullMethod(m))
    or
    forex(Expr e | c.canReturn(e) | e instanceof NonNullExpr)
  )
}

/** Holds if callable 'c' always throws an exception. */
predicate alwaysThrowsCallable(Callable c) {
  finalCallable(c) and
  (
    forex(ControlFlow::Node pre | pre = c.getExitPoint().getAPredecessor() |
      pre.getElement() instanceof ThrowElement
    )
    or
    exists(CIL::Method m | m.matchesHandle(c) | CR::alwaysThrowsMethod(m))
  )
}

/** Holds if callable `c` always throws exception `ex`. */
predicate alwaysThrowsException(Callable c, Class ex) {
  finalCallable(c) and
  (
    forex(ControlFlow::Node pre | pre = c.getExitPoint().getAPredecessor() |
      pre.getElement().(ThrowElement).getThrownExceptionType() = ex
    )
    or
    exists(CIL::Method m, CIL::Type t | m.matchesHandle(c) |
      CR::alwaysThrowsException(m, t) and t.matchesHandle(ex)
    )
  )
}

/**
 * Provides predicates for analysing the return values of callables.
 */

import csharp
private import cil
private import semmle.code.csharp.dataflow.Nullness
private import semmle.code.cil.CallableReturns as CR

/** Holds if callable `c` always returns null. */
predicate alwaysNullCallable(Callable c) {
  exists(CIL::Method m | m.matchesHandle(c) | CR::alwaysNullMethod(m))
  or
  forex(Expr e | callableReturns(c, e) | e instanceof AlwaysNullExpr)
}

/** Holds if callable `c` always returns a non-null value. */
predicate alwaysNotNullCallable(Callable c) {
  exists(CIL::Method m | m.matchesHandle(c) | CR::alwaysNotNullMethod(m))
  or
  forex(Expr e | callableReturns(c, e) | e instanceof NonNullExpr)
}

/** Holds if callable 'c' always throws an exception. */
predicate alwaysThrowsCallable(Callable c) {
  forex(ControlFlow::Node pre | pre = c.getExitPoint().getAPredecessor() |
    pre.getElement() instanceof ThrowElement
  )
  or
  exists(CIL::Method m | m.matchesHandle(c) | CR::alwaysThrowsMethod(m))
}

/** Holds if callable `c` always throws exception `ex`. */
predicate alwaysThrowsException(Callable c, Class ex) {
  forex(ControlFlow::Node pre | pre = c.getExitPoint().getAPredecessor() |
    pre.getElement().(ThrowElement).getThrownExceptionType() = ex
  )
  or
  exists(CIL::Method m, CIL::Type t | m.matchesHandle(c) | CR::alwaysThrowsException(m, t) and t.matchesHandle(ex))
}

/** Holds if callable `m' can return expression `ret` directly or indirectly. */
private predicate callableReturns(Callable m, Expr e) {
  exists(DataFlow::Node srcNode, DataFlow::Node retNode |
    e = srcNode.asExpr() and m.canReturn(retNode.asExpr())
  |
    DataFlow::localFlow(srcNode, retNode)
  )
}


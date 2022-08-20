/**
 * Provides predicates for analysing the return values of callables.
 */

private import CIL

cached
private module Cached {
  /** Holds if method `m` always returns null. */
  cached
  predicate alwaysNullMethod(Method m) { forex(Expr e | m.canReturn(e) | alwaysNullExpr(e)) }

  /** Holds if method `m` always returns non-null. */
  cached
  predicate alwaysNotNullMethod(Method m) { forex(Expr e | m.canReturn(e) | alwaysNotNullExpr(e)) }

  /** Holds if method `m` always throws an exception. */
  cached
  predicate alwaysThrowsMethod(Method m) {
    m.hasBody() and
    not exists(m.getImplementation().getAnInstruction().(Return))
  }

  /** Holds if method `m` always throws an exception of type `t`. */
  cached
  predicate alwaysThrowsException(Method m, Type t) {
    alwaysThrowsMethod(m) and
    forex(Throw ex | ex = m.getImplementation().getAnInstruction() | t = ex.getExceptionType())
  }
}

import Cached

pragma[noinline]
private predicate alwaysNullVariableUpdate(VariableUpdate vu) {
  forex(Expr src | src = vu.getSource() | alwaysNullExpr(src))
}

/** Holds if expression `expr` always evaluates to `null`. */
private predicate alwaysNullExpr(Expr expr) {
  expr instanceof NullLiteral
  or
  alwaysNullMethod(expr.(StaticCall).getTarget())
  or
  forex(Ssa::Definition def |
    expr = any(Ssa::Definition def0 | def = def0.getAnUltimateDefinition()).getARead()
  |
    alwaysNullVariableUpdate(def.getVariableUpdate())
  )
}

pragma[noinline]
private predicate alwaysNotNullVariableUpdate(VariableUpdate vu) {
  forex(Expr src | src = vu.getSource() | alwaysNotNullExpr(src))
}

/** Holds if expression `expr` always evaluates to non-null. */
private predicate alwaysNotNullExpr(Expr expr) {
  expr instanceof Opcodes::Newobj
  or
  expr instanceof Literal and not expr instanceof NullLiteral
  or
  alwaysNotNullMethod(expr.(StaticCall).getTarget())
  or
  forex(Ssa::Definition def |
    expr = any(Ssa::Definition def0 | def = def0.getAnUltimateDefinition()).getARead()
  |
    alwaysNotNullVariableUpdate(def.getVariableUpdate())
  )
}

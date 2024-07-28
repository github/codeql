/**
 * Provides predicates for analysing the return values of callables.
 */

private import CIL

cached
private module Cached {
  /** Holds if method `m` always returns null. */
  cached
  deprecated predicate alwaysNullMethod(Method m) {
    forex(Expr e | m.canReturn(e) | alwaysNullExpr(e))
  }

  /** Holds if method `m` always returns non-null. */
  cached
  deprecated predicate alwaysNotNullMethod(Method m) {
    forex(Expr e | m.canReturn(e) | alwaysNotNullExpr(e))
  }

  /** Holds if method `m` always throws an exception. */
  cached
  deprecated predicate alwaysThrowsMethod(Method m) {
    m.hasBody() and
    not exists(m.getImplementation().getAnInstruction().(Return))
  }

  /** Holds if method `m` always throws an exception of type `t`. */
  cached
  deprecated predicate alwaysThrowsException(Method m, Type t) {
    alwaysThrowsMethod(m) and
    forex(Throw ex | ex = m.getImplementation().getAnInstruction() | t = ex.getExceptionType())
  }
}

import Cached

pragma[noinline]
deprecated private predicate alwaysNullVariableUpdate(VariableUpdate vu) {
  forex(Expr src | src = vu.getSource() | alwaysNullExpr(src))
}

/** Holds if expression `expr` always evaluates to `null`. */
deprecated private predicate alwaysNullExpr(Expr expr) {
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
deprecated private predicate alwaysNotNullVariableUpdate(VariableUpdate vu) {
  forex(Expr src | src = vu.getSource() | alwaysNotNullExpr(src))
}

/** Holds if expression `expr` always evaluates to non-null. */
deprecated private predicate alwaysNotNullExpr(Expr expr) {
  expr instanceof Opcodes::NewObj
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

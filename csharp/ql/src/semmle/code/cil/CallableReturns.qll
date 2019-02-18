/**
 * Provides predicates for analysing the return values of callables.
 */

private import CIL

/** Holds if method `m` always returns null. */
predicate alwaysNullMethod(Method m) { forex(Expr e | methodReturns(m, e) | alwaysNullExpr(e)) }

/** Holds if method `m` always returns non-null. */
predicate alwaysNotNullMethod(Method m) {
  forex(Expr e | methodReturns(m, e) | alwaysNotNullExpr(e))
}

/** Holds if expression `expr` always evaluates to `null`. */
predicate alwaysNullExpr(Expr expr) {
  expr instanceof NullLiteral
  or
  alwaysNullMethod(expr.(StaticCall).getTarget())
}

/** Holds if expression `expr` always evaluates to non-null. */
predicate alwaysNotNullExpr(Expr expr) {
  expr instanceof Opcodes::Newobj
  or
  expr instanceof Literal and not expr instanceof NullLiteral
  or
  alwaysNotNullMethod(expr.(StaticCall).getTarget())
}

/** Holds if method `m` can return expression `ret` either directly or indirectly. */
private predicate methodReturns(Method m, Expr ret) {
  exists(BestImplementation i, Expr e, Return r | i = m.getImplementation() |
    ret.getImplementation() = i and
    e.flowsTo(ret) and
    r.getExpr() = ret
  )
}

/** Holds if method `m` always throws an exception. */
predicate alwaysThrowsMethod(Method m) {
  m.hasBody() and
  not exists(m.getImplementation().getAnInstruction().(Return))
}

/** Holds if method `m` always throws an exception of type `t`. */
predicate alwaysThrowsException(Method m, Type t) {
  alwaysThrowsMethod(m) and
  forex(Throw ex | ex = m.getImplementation().getAnInstruction() | t = ex.getExpr().getType())
}

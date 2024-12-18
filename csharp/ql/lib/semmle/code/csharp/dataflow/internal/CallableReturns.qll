/**
 * Provides predicates for analyzing the return values of callables.
 */

import csharp
private import semmle.code.csharp.dataflow.Nullness

private predicate finalCallable(Callable c) {
  not c.(Virtualizable).isVirtual() and
  not exists(DeclarationWithGetSetAccessors p | c = p.getAnAccessor() and p.isVirtual())
}

/** Holds if callable `c` always returns null. */
predicate alwaysNullCallable(Callable c) {
  finalCallable(c) and
  forex(Expr e | c.canReturn(e) | e instanceof AlwaysNullExpr)
}

/** Holds if callable `c` always returns a non-null value. */
predicate alwaysNotNullCallable(Callable c) {
  finalCallable(c) and
  forex(Expr e | c.canReturn(e) | e instanceof NonNullExpr)
}

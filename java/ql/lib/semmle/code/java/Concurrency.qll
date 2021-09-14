import java

/**
 * Holds if `e` is synchronized by a local synchronized statement `sync` on the variable `v`.
 */
predicate locallySynchronizedOn(Expr e, SynchronizedStmt sync, Variable v) {
  e.getEnclosingStmt().getEnclosingStmt+() = sync and
  sync.getExpr().(VarAccess).getVariable() = v
}

/**
 * Holds if `e` is synchronized by a local synchronized statement on a `this` of type `thisType`, or by a synchronized
 * modifier on the enclosing (non-static) method.
 */
predicate locallySynchronizedOnThis(Expr e, RefType thisType) {
  exists(SynchronizedStmt sync | e.getEnclosingStmt().getEnclosingStmt+() = sync |
    sync.getExpr().(ThisAccess).getType().(RefType).getSourceDeclaration() = thisType
  )
  or
  exists(SynchronizedCallable c | c = e.getEnclosingCallable() |
    not c.isStatic() and thisType = c.getDeclaringType()
  )
}

/**
 * Holds if `e` is synchronized by a `synchronized` modifier on the enclosing (static) method.
 */
predicate locallySynchronizedOnClass(Expr e, RefType classType) {
  exists(SynchronizedCallable c | c = e.getEnclosingCallable() |
    c.isStatic() and classType = c.getDeclaringType()
  )
}

/**
 * A callable that is synchronized on its enclosing instance, either by a `synchronized` modifier, or
 * by having a body which is precisely `synchronized(this) { ... }`.
 */
class SynchronizedCallable extends Callable {
  SynchronizedCallable() {
    this.isSynchronized()
    or
    // The body is just `synchronized(this) { ... }`.
    exists(SynchronizedStmt s | this.getBody().(SingletonBlock).getStmt() = s |
      s.getExpr().(ThisAccess).getType() = this.getDeclaringType()
    )
  }
}

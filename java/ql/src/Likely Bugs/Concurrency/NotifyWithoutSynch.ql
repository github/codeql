/**
 * @name Notify on unlocked object
 * @description Calling 'wait', 'notify', or 'notifyAll' on an object which has not
 *              been locked (with a synchronized method or statement) will throw.
 * @kind problem
 * @problem.severity error
 * @precision low
 * @id java/notify-without-sync
 * @tags correctness
 *       concurrency
 *       language-features
 */

import java

/** The set of methods to test: `wait`, `notify`, `notifyAll`. */
class MethodRequiresSynch extends Method {
  MethodRequiresSynch() {
    (
      this.hasName("wait") or
      this.hasName("notify") or
      this.hasName("notifyAll")
    ) and
    this.getDeclaringType().hasQualifiedName("java.lang", "Object")
  }
}

/**
 * Auxiliary predicate for `synchronizedThisAccess`. It holds if `c`
 * has a `synchronized` modifier or if `c` is private and all of
 * its call sites are from an appropriate synchronization context.
 *
 * This means that the following example is OK:
 *
 * ```
 *  void foo() {
 *    synchronized(x) {
 *      bar();
 *    }
 *  }
 *
 *  void bar() {
 *    x.notify()
 *  }
 * ```
 */
private predicate synchronizedCallable(Callable c) {
  c.isSynchronized()
  or
  c.isPrivate() and
  forall(MethodCall parent | parent.getCallee() = c |
    synchronizedThisAccess(parent, c.getDeclaringType())
  )
}

/**
 * Auxiliary predicate for `unsynchronizedExplicitThisAccess` and
 * `unsynchronizedImplicitThisAccess`. It holds if there is an
 * enclosing synchronization context of the appropriate type. For
 * example, if the method call is `MyClass.wait()`, then the predicate
 * holds if there is an enclosing synchronization on `MyClass.this`.
 */
private predicate synchronizedThisAccess(MethodCall ma, Type thisType) {
  // Are we inside a synchronized method?
  exists(Callable c |
    c = ma.getEnclosingCallable() and
    c.getDeclaringType() = thisType and
    synchronizedCallable(c)
  )
  or
  // Is there an enclosing `synchronized` statement?
  exists(SynchronizedStmt s, ThisAccess x |
    s.getAChild*() = ma.getEnclosingStmt() and
    s.getExpr() = x and
    x.getType() = thisType
  )
}

/**
 * Auxiliary predicate for `unsynchronizedVarAccess`. Holds if
 * there is an enclosing `synchronized` statement on the variable.
 */
predicate synchronizedVarAccess(VarAccess x) {
  exists(SynchronizedStmt s, VarAccess y |
    s.getAChild*() = x.getEnclosingStmt() and
    s.getExpr() = y and
    y.getVariable() = x.getVariable() and
    y.toString() = x.toString()
  )
}

/**
 * This predicate holds if the `MethodCall` is a qualified call,
 * such as `this.wait()`, and it is not inside a synchronized statement
 * or method.
 */
private predicate unsynchronizedExplicitThisAccess(MethodCall ma) {
  exists(ThisAccess x |
    x = ma.getQualifier() and
    not synchronizedThisAccess(ma, x.getType())
  )
}

/**
 * Holds if the `MethodCall` is an unqualified call,
 * such as `wait()`, and it is not inside a synchronized statement
 * or method.
 */
private predicate unsynchronizedImplicitThisAccess(MethodCall ma) {
  not ma.hasQualifier() and
  not synchronizedThisAccess(ma, ma.getEnclosingCallable().getDeclaringType())
}

/**
 * Holds if the `MethodCall` is on a variable,
 * such as `x.wait()`, and it is not inside a synchronized statement.
 */
private predicate unsynchronizedVarAccess(MethodCall ma) {
  exists(VarAccess x |
    x = ma.getQualifier() and
    not synchronizedVarAccess(x)
  )
}

from MethodCall ma, Method m
where
  m = ma.getMethod() and
  m instanceof MethodRequiresSynch and
  (
    unsynchronizedExplicitThisAccess(ma) or
    unsynchronizedImplicitThisAccess(ma) or
    unsynchronizedVarAccess(ma)
  )
select ma, "Calling " + m.getName() + " on an unsynchronized object."

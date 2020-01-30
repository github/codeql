/**
 * @name Inconsistent synchronization of getter and setter
 * @description If a class has a synchronized 'set' method, and a similarly-named 'get' method is
 *              not also synchronized, calls to the 'get' method may not return a consistent state
 *              for the object.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/unsynchronized-getter
 * @tags reliability
 *       correctness
 *       concurrency
 *       language-features
 *       external/cwe/cwe-413
 *       external/cwe/cwe-662
 */

import java

/**
 * Holds if this method is synchronized by a `synchronized(Foo.class){...}` block
 * (for static methods) or a `synchronized(this){...}` block (for instance methods).
 */
predicate isSynchronizedByBlock(Method m) {
  exists(SynchronizedStmt sync, Expr on | sync = m.getBody().getAChild*() and on = sync.getExpr() |
    if m.isStatic()
    then on.(TypeLiteral).getTypeName().getType() = m.getDeclaringType()
    else on.(ThisAccess).getType().(RefType).getSourceDeclaration() = m.getDeclaringType()
  )
}

/**
 * Holds if `get` is a getter method for a volatile field that `set` writes to.
 *
 * In this case, even if `set` is synchronized and `get` is not, `get` will never see stale
 * values for the field, so synchronization is optional.
 */
predicate bothAccessVolatileField(Method set, Method get) {
  exists(Field f | f.isVolatile() |
    f = get.(GetterMethod).getField() and
    f.getAnAccess().(FieldWrite).getEnclosingCallable() = set
  )
}

from Method set, Method get
where
  set.getDeclaringType() = get.getDeclaringType() and
  set.getName().matches("set%") and
  get.getName() = "get" + set.getName().substring(3, set.getName().length()) and
  set.isSynchronized() and
  not (get.isSynchronized() or isSynchronizedByBlock(get)) and
  not bothAccessVolatileField(set, get) and
  set.fromSource()
select get, "This get method is unsynchronized, but the corresponding $@ is synchronized.", set,
  "set method"

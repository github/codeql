/**
 * @name Double-checked locking is not thread-safe
 * @description A repeated check on a non-volatile field is not thread-safe, and
 *              could result in unexpected behavior.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-double-checked-locking
 * @tags reliability
 *       correctness
 *       concurrency
 *       external/cwe/cwe-609
 */

import java
import DoubleCheckedLocking

predicate allFieldsFinal(Class c) { forex(Field f | c.inherits(f) | f.isFinal()) }

predicate immutableFieldType(Type t) {
  allFieldsFinal(t) or
  t instanceof ImmutableType
}

from IfStmt if1, IfStmt if2, SynchronizedStmt sync, Field f
where
  doubleCheckedLocking(if1, if2, sync, f) and
  not f.isVolatile() and
  not (
    // Non-volatile double-checked locking is ok when the object is immutable and
    // there is only a single non-synchronized field read.
    immutableFieldType(f.getType()) and
    1 =
      strictcount(FieldAccess fa |
        fa.getField() = f and
        fa.getEnclosingCallable() = sync.getEnclosingCallable() and
        not fa.getEnclosingStmt().getEnclosingStmt*() = sync.getBlock()
      )
  )
select sync, "Double-checked locking on the non-volatile field $@ is not thread-safe.", f,
  f.toString()

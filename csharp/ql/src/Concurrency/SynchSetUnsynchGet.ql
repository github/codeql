/**
 * @name Inconsistently synchronized property
 * @description If a property has a lock in its setter, but not in its getter,
 *              then the value returned by the getter can be inconsistent.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cs/unsynchronized-getter
 * @tags correctness
 *       concurrency
 *       external/cwe/cwe-662
 */

import csharp

from Property p, Field f
where
  f.getDeclaringType() = p.getDeclaringType() and
  exists(Setter setter, LockStmt writelock, FieldWrite writeaccess |
    p.getSetter() = setter and
    writeaccess = f.getAnAccess() and
    writelock.getEnclosingCallable() = setter and
    writelock.getAChildStmt+().getAChildExpr+() = writeaccess
  ) and
  exists(Getter getter, FieldRead readaccess |
    getter = p.getGetter() and
    readaccess = f.getAnAccess() and
    readaccess.getEnclosingCallable() = getter and
    not exists(LockStmt readlock | readlock.getAChildStmt+().getAChildExpr+() = readaccess)
  )
select p, "Field '$@' is guarded by a lock in the setter but not in the getter.", f, f.getName()

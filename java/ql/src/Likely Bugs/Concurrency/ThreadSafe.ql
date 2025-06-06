/**
 * @name Not thread-safe
 * @description This class is not thread-safe. It is annotated as `@ThreadSafe`, but it has a
 *              conflicting access to a field that is not synchronized with the same monitor.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id java/not-threadsafe
 * @tags quality
 *       reliability
 *       concurrency
 */

import java
import semmle.code.java.ConflictingAccess

from
  ClassAnnotatedAsThreadSafe cls, FieldAccess modifyingAccess, Expr witness_modifyingAccess,
  FieldAccess conflictingAccess, Expr witness_conflictingAccess
where
  cls.witness(modifyingAccess, witness_modifyingAccess, conflictingAccess, witness_conflictingAccess)
select modifyingAccess,
  "This modifying field access (publicly accessible via $@) is conflicting with $@ (publicly accessible via $@) because they are not synchronized with the same monitor.",
  witness_modifyingAccess, "this expression", conflictingAccess, "this field access",
  witness_conflictingAccess, "this expression"
// select c, a.getField()

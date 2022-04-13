/**
 * @name Double-checked lock is not thread-safe
 * @description A repeated check on a non-volatile field is not thread-safe on some platforms,
 *              and could result in unexpected behavior.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cs/unsafe-double-checked-lock
 * @tags correctness
 *       concurrency
 *       external/cwe/cwe-609
 */

import csharp
import semmle.code.csharp.commons.StructuralComparison

predicate doubleCheckedLock(Field field, IfStmt unlockedIf) {
  exists(LockStmt lock, IfStmt lockedIf |
    lock = unlockedIf.getThen().stripSingletonBlocks() and
    lockedIf.getParent*() = lock.getBlock() and
    sameGvn(unlockedIf.getCondition(), lockedIf.getCondition()) and
    field.getAnAccess() = unlockedIf.getCondition().getAChildExpr*()
  )
}

from Field field, IfStmt ifs
where
  doubleCheckedLock(field, ifs) and
  not field.isVolatile() and
  exists(VariableWrite write | write = ifs.getThen().getAChild+() and write.getTarget() = field) and
  field.getType() instanceof RefType
select ifs, "Field $@ should be 'volatile' for this double-checked lock.", field, field.getName()

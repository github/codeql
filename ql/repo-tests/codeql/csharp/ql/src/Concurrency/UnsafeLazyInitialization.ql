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

class DoubleCheckedLock extends StructuralComparisonConfiguration {
  DoubleCheckedLock() { this = "double checked lock" }

  override predicate candidate(ControlFlowElement x, ControlFlowElement y) {
    exists(IfStmt unlockedIf, IfStmt lockedIf, LockStmt lock |
      x = unlockedIf.getCondition() and
      y = lockedIf.getCondition() and
      lock = unlockedIf.getThen().stripSingletonBlocks() and
      lockedIf.getParent*() = lock.getBlock()
    )
  }
}

predicate doubleCheckedLock(Field field, IfStmt ifs) {
  exists(DoubleCheckedLock config, LockStmt lock, Expr eq1, Expr eq2 | ifs.getCondition() = eq1 |
    lock = ifs.getThen().stripSingletonBlocks() and
    config.same(eq1, eq2) and
    field.getAnAccess() = eq1.getAChildExpr*()
  )
}

from Field field, IfStmt ifs
where
  doubleCheckedLock(field, ifs) and
  not field.isVolatile() and
  exists(VariableWrite write | write = ifs.getThen().getAChild+() and write.getTarget() = field) and
  field.getType() instanceof RefType
select ifs, "Field $@ should be 'volatile' for this double-checked lock.", field, field.getName()

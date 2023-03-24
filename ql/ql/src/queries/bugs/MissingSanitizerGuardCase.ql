/**
 * @name Unmentioned guard class
 * @description A sanitizer guard should be included in the `isSanitizerGuard` predicate.
 * @kind problem
 * @problem.severity warning
 * @id ql/unmentioned-guard
 * @tags correctness
 *       maintainability
 * @precision medium
 */

import ql

class SanGuard extends Class {
  SanGuard() {
    exists(Class sup |
      sup = this.getASuperType().getResolvedType().(ClassType).getDeclaration() and
      sup.getName() = ["SanitizerGuardNode", "SanitizerGuard", "BarrierGuardNode", "BarrierGuard"] and
      sup.getLocation().getFile() != this.getLocation().getFile()
    )
  }
}

from SanGuard guard
where
  not exists(TypeExpr t | t.getResolvedType().(ClassType).getDeclaration() = guard) and
  not guard.hasAnnotation("deprecated")
select guard, "Guard class is not mentioned anywhere."

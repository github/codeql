/**
 * @name Ssa completeness test
 * @description Ssa completeness test. If there is a SsaDefinition for a variable that reaches a use of that variable
 *                                     then there must be a SsaDefinition for that use
 * @kind test
 */

import cpp
import semmle.code.cpp.controlflow.SSA

/*
 * Count of number of uses of a StackVariable where no corresponding SSA definition exists,
 *   but at least one SSA definition for that variable can reach that use.
 *   Should always be zero *regardless* of the input
 */

select count(StackVariable v, Expr use |
    exists(SsaDefinition def, BasicBlock db, BasicBlock ub |
      def.getAUse(v) = use and db.contains(def.getDefinition()) and ub.contains(use)
    |
      db.getASuccessor+() = ub
    ) and
    not exists(SsaDefinition def | def.getAUse(v) = use)
  )

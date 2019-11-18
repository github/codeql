/**
 * @name RangeSsa completeness test
 * @description RangeSsa completeness test. If there is a
 *    RangeSsaDefinition for a variable that reaches a use of that
 *    variable then there must be a RangeSsaDefinition for that use
 * @kind test
 */

import cpp
import semmle.code.cpp.rangeanalysis.RangeSSA

/*
 * Count of number of uses of a StackVariable where no corresponding SSA definition exists,
 *   but at least one SSA definition for that variable can reach that use.
 *   Should always be zero *regardless* of the input
 */

select count(StackVariable v, Expr use |
    exists(RangeSsaDefinition def, BasicBlock db, BasicBlock ub |
      def.getAUse(v) = use and db.contains(def.getDefinition()) and ub.contains(use)
    |
      db.getASuccessor+() = ub
    ) and
    not exists(RangeSsaDefinition def | def.getAUse(v) = use)
  )

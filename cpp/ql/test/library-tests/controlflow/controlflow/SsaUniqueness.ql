/**
 * @name SSA unique definition test
 * @description SSA unique definition test. For each use there must be zero or one SSA definitions.
 * @kind test
 */

import cpp
import semmle.code.cpp.controlflow.SSA

/*
 * Count of number of uses where the number of SSA definitions exceeds one.
 *  Should always be zero *regardless* of the input
 */

select count(SsaDefinition d1, SsaDefinition d2, Expr u, StackVariable v |
    d1.getAUse(v) = u and
    d2.getAUse(v) = u and
    not d1 = d2
  )

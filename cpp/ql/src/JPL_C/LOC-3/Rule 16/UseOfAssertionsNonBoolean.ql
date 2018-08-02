/**
 * @name Non-boolean assertion
 * @description Assertions should be defined as Boolean tests, meaning "assert(p != NULL)" rather than "assert(p)".
 * @kind problem
 * @id cpp/jpl-c/use-of-assertions-non-boolean
 * @problem.severity warning
 */

import semmle.code.cpp.commons.Assertions

from Assertion a
where a.getAsserted().getType() instanceof PointerType
select a.getAsserted(), "Assertions should be defined as Boolean tests."

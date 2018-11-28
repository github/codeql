/**
 * @name Non-Boolean assertion
 * @description Assertions should be defined as Boolean tests, meaning "assert(p != NULL)" rather than "assert(p)".
 * @kind problem
 * @id cpp/power-of-10/non-boolean-assertion
 * @problem.severity warning
 * @tags correctness
 *       external/powerof10
 */

import semmle.code.cpp.commons.Assertions

from Assertion a
where a.getAsserted().getType() instanceof PointerType
select a.getAsserted(), "Assertions should be defined as Boolean tests."

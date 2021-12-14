/**
 * @name Assertion with side effects
 * @description When an assertion has side effects, disabling assertions will
 *              alter program behavior.
 * @kind problem
 * @id cpp/power-of-10/assertion-side-effect
 * @problem.severity warning
 * @tags correctness
 *       external/powerof10
 */

import semmle.code.cpp.commons.Assertions

from Assertion a
where not a.getAsserted().isPure()
select a.getAsserted(), "Assertions should not have side effects."

/**
 * @name Assertion with side effects
 * @description Assertions should not have side-effects -- they may be disabled completely, changing program behavior.
 * @kind problem
 * @id cpp/jpl-c/use-of-assertions-side-effect
 * @problem.severity warning
 * @tags correctness
 *       external/jpl
 */

import semmle.code.cpp.commons.Assertions

from Assertion a
where not a.getAsserted().isPure()
select a.getAsserted(), "Assertions should not have side effects."

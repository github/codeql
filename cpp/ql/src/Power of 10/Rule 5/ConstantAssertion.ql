/**
 * @name Constant assertion
 * @description Assertions should check dynamic properties of pre-/post-conditions and invariants. Assertions that either always succeed or always fail are an error.
 * @kind problem
 * @id cpp/power-of-10/constant-assertion
 * @problem.severity warning
 * @tags maintainability
 *       reliability
 *       external/powerof10
 */

import semmle.code.cpp.commons.Assertions

from Assertion a, string value, string msg
where
  value = a.getAsserted().getValue() and
  if value.toInt() = 0
  then msg = "This assertion is always false."
  else msg = "This assertion is always true."
select a.getAsserted(), msg

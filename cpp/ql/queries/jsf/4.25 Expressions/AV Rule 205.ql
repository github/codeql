/**
 * @name AV Rule 205
 * @description The volatile keyword shall not be used unless directly interfacing with hardware.
 * @kind problem
 * @id cpp/jsf/av-rule-205
 * @problem.severity warning
 * @tags efficiency
 *       external/jsf
 */

import cpp

// whether it is acceptable for s to be declared volatile
// by default, we accept volatile specifiers on external global variables
predicate acceptableVolatile(Variable v) {
  v instanceof GlobalVariable and v.hasSpecifier("extern")
}

from Variable v
where
  v.getType().hasSpecifier("volatile") and
  not acceptableVolatile(v)
select v,
  "AV Rule 205: The volatile keyword shall not be used unless directly interfacing with hardware."

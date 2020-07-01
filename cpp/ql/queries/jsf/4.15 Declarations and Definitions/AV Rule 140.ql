/**
 * @name Register variables
 * @description The register storage class specifier shall not be used. It is better and more portable to rely on the compiler to allocate registers automatically.
 * @kind problem
 * @id cpp/jsf/av-rule-140
 * @problem.severity warning
 * @tags maintainability
 *       portability
 *       external/jsf
 */

import cpp

from Declaration d
where d.hasSpecifier("register")
select d,
  "The register storage class specifier should not be used; compilers can be trusted to decide whether to store a variable in a register."

/**
 * @name If expression always true
 * @description Expressions used in If conditions with extra spaces are always true.
 * @kind problem
 * @security-severity 9.0
 * @problem.severity error
 * @precision very-high
 * @id actions/if-expression-always-true/critical
 * @tags actions
 *       maintainability
 *       external/cwe/cwe-275
 */

import actions
import codeql.actions.security.ControlChecks

from ControlCheck i
where
  i.(If).getCondition().matches("%${{%") and
  (
    not i.(If).getCondition().matches("${{%") or
    not i.(If).getCondition().matches("%}}")
  )
  or
  count(i.(If).getCondition().splitAt("${{")) > 2
select i, "Expression always evaluates to true"

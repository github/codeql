/**
 * @name If expression always true
 * @description Expressions used in If conditions with extra spaces are always true.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @security-severity 7.5
 * @id actions/if-expression-always-true/high
 * @tags actions
 *       maintainability
 *       external/cwe/cwe-275
 */

import actions
import codeql.actions.security.ControlChecks

from If i
where
  not i instanceof ControlCheck and
  (
    i.getCondition().matches("%${{%") and
    (
      not i.getCondition().matches("${{%") or
      not i.getCondition().matches("%}}")
    )
    or
    count(i.getCondition().splitAt("${{")) > 2
  )
select i, "Expression always evaluates to true"

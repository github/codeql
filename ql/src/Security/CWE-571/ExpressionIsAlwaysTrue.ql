/**
 * @name If expression always true
 * @description Expressions used in If conditions with extra spaces are always true.
 * @kind problem
 * @security-severity 9.0
 * @problem.severity error
 * @precision high
 * @id actions/if-expression-always-true
 * @tags actions
 *       maintainability
 *       external/cwe/cwe-275
 */

import actions

from If i
where
  i.getCondition().matches("%${{%") and
  i.getConditionStyle() = ["|", ">"]
  or
  i.getCondition().matches("%${{%") and
  not i.getCondition().matches("${{%")
  or
  count(i.getCondition().splitAt("${{")) > 2
select i, "Expression always evaluates to true"

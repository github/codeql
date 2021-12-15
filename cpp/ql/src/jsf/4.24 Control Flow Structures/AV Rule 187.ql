/**
 * @name AV Rule 187
 * @description All non-null statements shall potentially have a side-effect.
 * @kind problem
 * @id cpp/jsf/av-rule-187
 * @problem.severity error
 * @tags correctness
 *       external/jsf
 */

import cpp

from Stmt s
where
  s.fromSource() and
  // Exclude empty statements
  not s instanceof EmptyStmt and
  // Exclude control statements
  not s instanceof LabelStmt and
  not s instanceof JumpStmt and
  not s instanceof ReturnStmt and
  not s instanceof ControlStructure and
  // Exclude blocks; if a child of the block violates the rule that will still
  // be picked up so there is no point in blaming the block as well
  not s instanceof BlockStmt and
  s.isPure()
select s, "AV Rule 187: All non-null statements shall potentially have a side-effect."

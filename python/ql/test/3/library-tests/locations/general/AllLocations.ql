/**
 * @name All must have locations
 * @description
 * @kind table
 * @problem.severity error
 */

import python

from string classname
where
  exists(AstNode node | not exists(node.getLocation()) and classname = node.getAQlClass())
  or
  exists(ControlFlowNode node | not exists(node.getLocation()) and classname = node.getAQlClass())
select classname

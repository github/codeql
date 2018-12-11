/**
 * @name Branch
 * @description Insert description here...
 * @kind problem
 * @problem.severity warning
 */

import python

from ControlFlowNode f
where f.isBranch() and f.getLocation().getFile().getShortName() = "boolops.py"
select f.getLocation().getStartLine(), f

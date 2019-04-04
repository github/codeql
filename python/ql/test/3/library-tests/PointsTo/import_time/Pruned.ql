/**
 * @name Naive
 * @description Insert description here...
 * @kind table
 * @problem.severity warning
 */

import python
import semmle.python.pointsto.PointsTo

from ControlFlowNode f, Location l
where not PointsTo::Test::reachableBlock(f.getBasicBlock(), _) and l = f.getLocation() and l.getFile().getName().matches("%test.py")
select l.getStartLine()

import python
import semmle.dataflow.SSA
import semmle.python.pointsto.PointsTo

import Util

from SsaSourceVariable var, ControlFlowNode defn, string kind
where 
var.hasDefiningNode(defn) and kind = "definition"
or
var.hasRefinement(_, defn) and kind = "refinement"
select locate(defn.getLocation(), "ab"), var.(Variable), defn.toString(), kind

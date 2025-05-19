/**
 * @kind path-problem
 */

import powershell
import semmle.code.powershell.dataflow.DataFlow
private import TestUtilities.InlineFlowTest
import DefaultFlowTest
import TaintFlow::PathGraph

from TaintFlow::PathNode source, TaintFlow::PathNode sink
where TaintFlow::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
